rec {
  fetchDeps = { pkgs }: { src, pname, version, index, alire }:
    with pkgs; stdenv.mkDerivation {
      inherit src version;
      pname = "${pname}-deps";

      nativeBuildInputs = [ cacert gprbuild gnat git alire ];

      configurePhase = ''
        mkdir -p /tmp/.config/

        cp -r ${index} /tmp/.config/alire/
        chmod +w -R /tmp/.config # why isn't it created writable??
        alr settings --set index.auto_update 0
        alr settings --set toolcahin.assisstant false
        alr settings --set warning.old_index false
        alr -vv toolchain --select gnat_external
      '';

      buildPhase = ''
        alr build --stop-after=pre-build
      '';

      installPhase = ''
        cp -r /tmp/.local/share/alire $out
      '';

      outputHashMode = "recursive";
      outputHashAlgo = null;
      outputHash = "sha256-gpRL7/ma+cHVprf+Yl7+pIt5n0VtrPkvt3y2OFUaKD0=";
  };

  buildAlireCrate = { pkgs }: { src, pname, version, index, alire }:
    with pkgs; stdenv.mkDerivation {
      inherit src pname version;

      nativeBuildInputs = [ pkgs.gprbuild pkgs.gnat pkgs.git alire ];

      configurePhase = ''
        mkdir -p /tmp/.config/

        cp -r ${index} /tmp/.config/alire/
        chmod +w -R /tmp/.config # why isn't it created writable??
        alr settings --set index.auto_update 0
        alr settings --set toolcahin.assisstant false
        alr settings --set warning.old_index false
        alr -vv toolchain --select gnat_external
      '';

      buildPhase = ''
        mkdir -p /tmp/.local/share
        cp -r ${(fetchDeps { inherit pkgs; }) { inherit src pname version index alire; }} \
          /tmp/.local/share/alire
        chmod +w -R /tmp/.local/share/alire

        alr -n -v build
      '';

      installPhase = ''
        mkdir -p $out
        cp -r bin $out/bin
      '';
    };

  # Create a derivation given an index name, source, and version.
  indexDerivation =
    { stdenv
    , idxSrc
    , pname
    , version
    }: stdenv.mkDerivation {
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
