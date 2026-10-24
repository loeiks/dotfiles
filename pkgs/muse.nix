{
  lib,
  stdenv,
  fetchurl,
}:

let
  # Bump with `scripts/update-muse.sh`; it rewrites the version and hashes
  # below from Meta's public channel manifest.
  version = "1.4.13-R6996.1";

  sources = {
    x86_64-linux = {
      file = "muse-x86-linux";
      hash = "sha256-Uel/jeCqF1CA5ldsvAVVEKld/g7e3xdcf2s0/I479SQ=";
    };
    aarch64-linux = {
      file = "muse-aarch64-linux";
      hash = "sha256-x/J4tfEoYvVyHHNDOXYlaqKoq9QzoS2g5ITTCwjAJP8=";
    };
    x86_64-darwin = {
      file = "muse-x86-macos";
      hash = "sha256-WKngBqqwKTTz0g9INUmZu63GYf9/vjqoP9DcSL7VIP0=";
    };
    aarch64-darwin = {
      file = "muse-aarch64-macos";
      hash = "sha256-n9QK6cbfuEfj71i2FAXABNDrvxnOsCl76Wb3ULO4SqA=";
    };
  };

  source =
    sources.${stdenv.hostPlatform.system}
      or (throw "muse: unsupported system ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation {
  pname = "muse";
  inherit version;

  src = fetchurl {
    name = "${source.file}-${version}";
    url = "https://lookaside.facebook.com/lookaside/muse/download/?channel=muse&version=${version}&file=${source.file}";
    inherit (source) hash;
  };

  # The release artifact is a single statically linked executable.
  dontUnpack = true;
  dontBuild = true;
  # Strip/patchelf would break the upstream signature (and is unnecessary for
  # a static binary), so leave the artifact untouched.
  dontFixup = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 "$src" "$out/bin/muse"
    runHook postInstall
  '';

  meta = {
    description = "Muse Code, Meta's terminal coding agent";
    homepage = "https://dev.meta.ai";
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = "muse";
    platforms = builtins.attrNames sources;
  };
}
