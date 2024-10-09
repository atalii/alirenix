{ pkgs, alire, index }:
with pkgs; stdenv.mkDerivation {
  pname = "helloworld";
  version = "0.1.0";
  src = ./.;

  nativeBuildInputs = [ pkgs.gprbuild pkgs.gnat alire git ];

  # TODO: is configurePhase correct here?
  configurePhase = ''
    mkdir -p /tmp/.config/

    cp -r ${index} /tmp/.config/alire/
    chmod +w -R /tmp/.config # why isn't it created writable??
    alr settings --set index.auto_update 0
    alr settings --set toolcahin.assisstant false
    alr toolchain --select gnat_external
  '';

  buildPhase = ''
    alr -n build
  '';

  installPhase = ''
    mkdir -p $out
    cp -r bin $out/bin
  '';
}
