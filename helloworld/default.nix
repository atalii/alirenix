{ pkgs, alire, alire-community-index }:
with pkgs; stdenv.mkDerivation {
  pname = "helloworld";
  version = "0.1.0";
  src = ./.;

  nativeBuildInputs = [ pkgs.gprbuild pkgs.gnat alire git ];

  # TODO: is configurePhase correct here?
  configurePhase = ''
    mkdir -p /tmp/.config/alire/indexes/community
    cp -r ${alire-community-index} /tmp/.config/alire/indexes/community/repo
    chmod +w -R /tmp/.config

    # ew gross hack
    echo 'url = "git+https://github.com/alire-project/alire-index#stable-1.3.0"' >> /tmp/.config/alire/indexes/community/index.toml
    echo 'name = "community"' >> /tmp/.config/alire/indexes/community/index.toml
    echo 'priority = 1' >> /tmp/.config/alire/indexes/community/index.toml

    alr settings --set index.auto_update 0
    alr settings --set toolcahin.assisstant false
    alr --force -v toolchain --select gnat_external
  '';

  buildPhase = ''
    alr --force -n build
  '';

  installPhase = ''
    mkdir -p $out
    cp -r bin $out/bin
  '';
}
