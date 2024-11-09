{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";

    alire-community-index = {
      url = "github:alire-project/alire-index/";
      flake = false;
    };

    alire-src = {
      url = "https://github.com/atalii/alire";
      type = "git";
      ref = "nix";
      submodules = true;
      flake = false;
    };
  };

  outputs =
    { self
    , nixpkgs
    , flake-utils
    , alire-community-index
    , alire-src
    }: (flake-utils.lib.eachDefaultSystem (system: {
      packages =
        let pkgs = nixpkgs.legacyPackages.${system};
        in {
          community-index = pkgs.callPackage self.lib.indexDerivation {
            idxSrc = alire-community-index;
            pname = "community";
            version = "stable-1.3.0";
          };

          helloworld = import ./helloworld {
            inherit pkgs;
            alirenix = self;
          };

          withdeps = import ./withdeps {
            inherit pkgs;
            alirenix = self;
          };

          withpinned = import ./withpinned {
            inherit pkgs;
            alirenix = self;
          };

          alire = pkgs.callPackage ./alire.nix {
            inherit alire-src;
          };
        };
    }) // {
      lib = import ./lib;
    });
}
