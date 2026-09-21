{
  lib,
  stdenv,
  fetchurl,
  patchelf,
}:

# Shared builder for the T3 Code CLI (https://t3.codes), used by both the
# stable and nightly package definitions. `tag` is the full GitHub release
# tag (e.g. "v0.0.42" or "v0.0.43-nightly.20260921.2058"); `version` is what
# Nix reports for the derivation; `hashes` map each Nix system to the
# release archive's sha256 from that tag's SHA256SUMS — the same file
# https://t3.codes/install.sh downloads and verifies against.
{
  pname,
  tag,
  version,
  hashes,
}:

let
  isLinux = stdenv.hostPlatform.isLinux;

  assetNames = {
    x86_64-linux = "linux-x64";
    aarch64-linux = "linux-arm64";
    aarch64-darwin = "darwin-arm64";
  };

  asset =
    assetNames.${stdenv.hostPlatform.system}
      or (throw "${pname}: unsupported platform ${stdenv.hostPlatform.system}");

  hash =
    hashes.${stdenv.hostPlatform.system}
      or (throw "${pname}: no hash pinned for ${stdenv.hostPlatform.system}");
in

stdenv.mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://github.com/pingdotgg/t3code/releases/download/${tag}/t3-${
      lib.removePrefix "v" tag
    }-${asset}.tar.gz";
    inherit hash;
  };

  nativeBuildInputs = lib.optionals isLinux [ patchelf ];
  buildInputs = lib.optionals isLinux [ stdenv.cc.cc.lib ];

  # `t3` (and the resource-monitor helper) are Node.js single-executable
  # apps with a self-referential embedded blob; patchelf rewriting them
  # (RPATH shrink, strip, interpreter) corrupts that blob (SIGILL at
  # startup). Only the native addons under node_modules need/are safe to
  # patch for their libstdc++/libgcc deps — do that by hand below and
  # skip every generic-fixup ELF pass that would otherwise touch `t3`.
  dontPatchELF = isLinux;
  dontStrip = isLinux;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/libexec/t3
    cp -r . $out/libexec/t3/
    ln -s $out/libexec/t3/t3 $out/bin/t3
    chmod +x $out/libexec/t3/t3
    runHook postInstall
  '';

  postInstall = lib.optionalString isLinux ''
    while IFS= read -r -d "" f; do
      patchelf --set-rpath "${stdenv.cc.cc.lib}/lib" "$f" || true
    done < <(find $out/libexec/t3/node_modules -type f \( -name '*.node' -o -name '*.so' \) -print0)
  '';

  meta = {
    description = "T3 Code CLI — Theo/pingdotgg's browser GUI bridge for AI coding agents";
    homepage = "https://t3.codes";
    license = lib.licenses.mit;
    mainProgram = "t3";
    platforms = builtins.attrNames assetNames;
  };
}
