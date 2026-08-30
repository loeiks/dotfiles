{
  pkgs,
  ...
}:

let
isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
in

{
  imports = [
    ../modules/packages.nix
    ../modules/files.nix
    ../modules/shell.nix
    ../modules/languages.nix
  ];

  # Home Manager needs a bit of information about you and the paths it should manage.
  home.username = "loeiks";
  home.homeDirectory = if isDarwin then "/Users/loeiks" else "/home/loeiks";
  home.stateVersion = "26.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "loeiks";
        email = "90484193+loeiks@users.noreply.github.com";
        signingKey = "~/.ssh/id_ed25519.pub";
      };

      gpg.format = "ssh";
      commit.gpgSign = true;
      tag.gpgSign = true;
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };
}
