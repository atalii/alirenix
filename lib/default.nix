{
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
        alr -n -v build
      '';

      installPhase = ''
        mkdir -p $out
        cp -r bin $out/bin
      '';
    };

  # Create a derivation given an index name, source, and version.
  indexDerivation = { pkgs, idxSrc, pname, version }: with pkgs;
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
