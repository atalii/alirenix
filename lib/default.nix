let
  mkConfigurePhase = indexDrv: ''
    mkdir -p /tmp/.config/

    cp -r ${indexDrv} /tmp/.config/alire/
    chmod +w -R /tmp/.config

    alr settings --set index.auto_update 0
    alr settings --set toolcahin.assisstant false
    alr settings --set warning.old_index false
    alr -vv toolchain --select gnat_external
  '';
in
rec {
  fetchDeps =
    { pkgs }:
    {
      src,
      pname,
      version,
      index,
      alire,
      depsHash,

      gnat ? pkgs.gnat,
      gprbuild ? pkgs.gprbuild,
    }:
    pkgs.stdenv.mkDerivation {
      inherit src version;
      pname = "${pname}-deps";

      nativeBuildInputs = [
        pkgs.git
        pkgs.curl
        pkgs.cacert
        pkgs.zip
        pkgs.unzip

        alire
        gprbuild
        gnat
      ];

      configurePhase = mkConfigurePhase index;

      buildPhase = ''
        alr build --stop-after=pre-build

        # git hooks created by git clone, when git is installed via
        # nix, contain a shebang pointing to the nix store. these
        # paths are illegal in FODs. remove them.
        rm -rf alire/cache/pins/*/.git
      '';

      installPhase = ''
        mkdir -p $out

        cp -r /tmp/.local/share/alire $out/global-cache \
          || mkdir $out/global-cache

        cp -r ./alire/cache $out/local-cache \
          || mkdir $out/local-cache
      '';

      outputHashMode = "recursive";
      outputHashAlgo = null;
      outputHash = depsHash;

      # Sometimes pinned git repos will have shebangs, which will then
      # be 'fixed', resulting in an illegal path in a FOD.
      dontPatchShebangs = true;
    };

  buildAlireCrate =
    { pkgs }:
    {
      src,
      pname,
      version,
      index,
      alire,
      depsHash ? null,

      gnat ? pkgs.gnat,
      gprbuild ? pkgs.gprbuild,
    }:
    let
      deps = (fetchDeps { inherit pkgs; }) {
        inherit
          src
          pname
          version
          index
          alire
          depsHash
          ;
      };
    in
    (pkgs.stdenv.mkDerivation {
      inherit src pname version;

      nativeBuildInputs = [
        gprbuild
        gnat
        alire

        pkgs.git
      ];

      configurePhase = mkConfigurePhase index;

      buildPhase =
        (
          if depsHash != null then
            ''
              mkdir -p /tmp/.local/share

              cp -r ${deps}/global-cache /tmp/.local/share/alire
              chmod +w -R /tmp/.local/share/alire

              rm -rf ./alire/cache

              cp -r ${deps}/local-cache ./alire/cache
              chmod +w -R ./alire/cache
            ''
          else
            ""
        )
        + ''
          alr -n -v build
        '';

      installPhase = ''
        mkdir -p $out
        cp -r bin $out/bin
      '';
    });

  # Create a derivation given an index name, source, and version.
  indexDerivation =
    {
      stdenv,
      idxSrc,
      pname,
      version,
    }:
    stdenv.mkDerivation {
      src = ./.;

      inherit pname version;
      unpackPhase = ''
        mkdir -p ./indexes/${pname}
        cp -r ${idxSrc} ./indexes/${pname}/repo
      '';

      buildPhase = ''
        # ew gross hack
        echo 'url = "git+https://github.com/alire-project/alire-index#${pname}"' >> ./indexes/community/index.toml
        echo 'name = "community"' >> ./indexes/community/index.toml
        echo 'priority = 1' >> ./indexes/community/index.toml
      '';

      installPhase = ''
        mkdir $out
        cp -r indexes $out
      '';
    };
}
