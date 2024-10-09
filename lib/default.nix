{
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
