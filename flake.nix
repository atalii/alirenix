{
  inputs.nixpkgs.url = "github:nixos/nixpkgs";

  outputs = { self, nixpkgs }: {
    packages.x86_64-linux =
      let
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
      in with pkgs; {
        helloworld = import ./helloworld {
          inherit pkgs;
          alire = self.packages.x86_64-linux.alire;
        };

        alire = stdenv.mkDerivation (finalAttrs: {
          pname = "alire";
          version = "2.1.0-dev";

          src = fetchFromGitHub {
            owner = "atalii";
            repo = "alire";
            rev = "d18367d58f24cd11e316f50540cef30b5823bd6a";
            hash = "sha256-46PwpF1/ZWJmGU/GPbTMuuFRLxazlfFWuFh4VioDNJs=";

            fetchSubmodules = true;
          };

          nativeBuildInputs = [ gprbuild gnat ];

          buildPhase = ''
            runHook preBuild
            patchShebangs dev/build.sh scripts/version-patcher.sh

            export ALIRE_BUILD_JOBS="$NIX_BUILD_CORES"
            ./dev/build.sh

            runHook postBuild
          '';

          installPhase = ''
            runHook preInstall

            mkdir -p $out
            cp -r ./bin $out

            runHook postInstall
          '';
        });
      };
  };
}
