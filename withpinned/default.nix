{
  alirenix,
  pkgs ? import <nixpkgs> { },
}:

(alirenix.lib.buildAlireCrate { inherit pkgs; }) {
  alire = alirenix.packages.x86_64-linux.alire;
  index = alirenix.packages.x86_64-linux.community-index;

  pname = "withdeps";
  version = "0.1.0";
  src = ./.;

  depsHash = "sha256-KIhBMSaQFcmBa/JgaR/HHLOQifDU/QtOqmnpZi9LbSw=";
}
