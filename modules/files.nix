{
  config,
  lib,
  pkgs,
  ...
}:

let
isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
in

{
  home.file = {
    ".tmux.conf".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/files/.tmux.conf";

    ".config/nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/files/nvim";

    ".ssh/id_ed25519.pub".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/files/general/id_ed25519.pub";
  } // lib.optionalAttrs isDarwin {
    "Library/Application Support/com.mitchellh.ghostty/config.ghostty".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/files/macos/config.ghostty";

    ".aerospace.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/files/macos/.aerospace.toml";
  };
}
