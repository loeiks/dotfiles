{ callPackage, ... }:

# Nightlies cut every few hours, so this is a frozen snapshot, not a
# tracking channel — bump it manually when you want a newer one:
#   gh release list --repo pingdotgg/t3code -L 5 | grep nightly
#   gh release download <tag> --repo pingdotgg/t3code --pattern SHA256SUMS
callPackage ./generic.nix { } {
  pname = "t3-code-nightly";
  tag = "v0.0.43-nightly.20260921.2058";
  version = "0.0.43-nightly.20260921.2058";
  hashes = {
    x86_64-linux = "sha256-0m2SAYbKHY7ipYA/e5gysV1HkSQUcWF6QOUPbIj/dpE=";
    aarch64-linux = "sha256-1APi3IRo2rL8Nk4iDbnglp1/+GNY+vfPo5dxGadbVJs=";
    aarch64-darwin = "sha256-/5129wkIXN0xR2F1Zaqzi5JumFtfhmSBFxz848oVe64=";
  };
}
