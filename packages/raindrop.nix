{
  stdenv,
  fetchurl,
  autoPatchelfHook,
  gcc-unwrapped,
}:

stdenv.mkDerivation rec {
  pname = "raindrop";
  version = "0.1.7";

  src = fetchurl {
    url = "https://github.com/raindrop-ai/workshop/releases/download/v${version}/raindrop-bun-linux-x64";
    hash = "sha256-xy/zUQ47tnFhprPIKd9/Pj9j4+Cqrep5uWkL17GOaoI=";
  };

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [
    gcc-unwrapped.lib
  ];

  dontUnpack = true;
  dontBuild = true;
  dontStrip = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 $src $out/bin/raindrop

    runHook postInstall
  '';

  meta = {
    description = "Raindrop CLI";
    homepage = "https://github.com/raindrop-ai/workshop";
    platforms = [ "x86_64-linux" ];
    mainProgram = "raindrop";
  };
}
