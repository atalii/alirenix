{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";

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

  outputs = { self, nixpkgs, alire-community-index, alire-src }: {
    packages.x86_64-linux =
      let
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
      in with pkgs; {
        indexes.community = pkgs.callPackage self.lib.indexDerivation {
          idxSrc = alire-community-index;
          pname = "community";
          version = "stable-1.3.0";
        };

        helloworld = import ./helloworld {
          inherit pkgs;
          lib = self.lib;
          alire = self.packages.x86_64-linux.alire;
          index = self.packages.x86_64-linux.indexes.community;
        };

        withdeps = import ./withdeps {
          inherit pkgs;
          lib = self.lib;
          alire = self.packages.x86_64-linux.alire;
          index = self.packages.x86_64-linux.indexes.community;
        };

        alire = pkgs.callPackage ./alire.nix {
          inherit alire-src;
        };
      };

    lib = import ./lib;
  };
}
