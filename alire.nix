{ stdenv
, gprbuild
, gnat
, alire-src
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "alire";
  version = "2.1.0-dev";

  src = alire-src;

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
})
