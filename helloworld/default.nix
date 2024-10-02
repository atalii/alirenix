{ pkgs, alire }:
with pkgs; stdenv.mkDerivation {
  pname = "helloworld";
  version = "0.1.0";
  src = ./.;

  nativeBuildInputs = [ pkgs.gprbuild pkgs.gnat alire ];

  # TODO: is configurePhase correct here?
  configurePhase = ''
    alr settings --set index.auto_update 0
    alr settings --set index.auto_community false
    alr settings --set toolcahin.assisstant false
    alr --force toolchain --select gnat_external
  '';

  buildPhase = ''
    alr --force -n build
  '';

  installPhase = ''
    cp -r bin $out/bin
  '';
}
