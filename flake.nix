{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-25.05";

    alire-community-index = {
      url = "github:alire-project/alire-index/";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      alire-community-index,
    }:
    let
      systems = nixpkgs.lib.systems.flakeExposed;
      forAllSystems = nixpkgs.lib.genAttrs systems;
      define = f: forAllSystems (system: f nixpkgs.legacyPackages.${system});
    in
    {
      packages = define (pkgs: {
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

        withgnat = import ./withgnat {
          inherit pkgs;
          alirenix = self;
        };

        alire = pkgs.alire;
      });

      formatter = define (pkgs: pkgs.nixfmt-rfc-style);

      lib = import ./lib;
    };
}
