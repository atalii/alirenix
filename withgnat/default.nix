{
  alirenix,
  pkgs ? import <nixpkgs> { },
}:

(alirenix.lib.buildAlireCrate { inherit pkgs; }) {
  alire = alirenix.packages.x86_64-linux.alire;
  index = alirenix.packages.x86_64-linux.community-index;

  gnat = pkgs.gnat15;
  gprbuild = pkgs.gnat15Packages.gprbuild;

  pname = "withdeps";
  version = "0.1.0";
  src = ./.;
}
