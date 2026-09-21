{ callPackage, ... }:

# Update by grabbing the new tag's SHA256SUMS:
#   gh release download vX.Y.Z --repo pingdotgg/t3code --pattern SHA256SUMS
callPackage ./generic.nix { } {
  pname = "t3-code";
  tag = "v0.0.42";
  version = "0.0.42";
  hashes = {
    x86_64-linux = "sha256-9QTpMe5EBr/nZ1QUfLDioPMA11xsUFoOF0oeefZc7qM=";
    aarch64-linux = "sha256-feR+Znk8kbAe4/swTZ0tyacBmqqPhcVbU11tjKPhQBM=";
    aarch64-darwin = "sha256-8VuMTEcJKz06SuLCSx4buT0kphjtvIrt/ERVo2t2d0o=";
  };
}
