{ pkgs, lib, alire, index }:

(lib.buildAlireCrate { inherit pkgs; }) {
  inherit alire index;
  pname = "helloworld";
  version = "0.1.0";
  src = ./.;
}
