{
  description = "Home Manager configuration of loeiks";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
  {
    nixpkgs,
    home-manager,
    ...
  }:
  let
  mkHome =
  system:
  home-manager.lib.homeManagerConfiguration {
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfreePredicate =
      pkg:
      builtins.elem (nixpkgs.lib.getName pkg) [
        "claude-code"
        "ookla-speedtest"
      ];
    };
    modules = [ ./profiles/loeiks.nix ];
  };
  in

  {
    homeConfigurations = {
      loeiks = mkHome "x86_64-linux"; # Linux / WSL
      loeiks-m = mkHome "aarch64-darwin"; # macOS (Apple Silicon)
    };
  };
}
