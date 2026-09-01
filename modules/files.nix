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
    # tmux config
    ".tmux.conf".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/files/.tmux.conf";

    # neovim config as folder
    ".config/nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/files/nvim";

    # public ssh key
    ".ssh/id_ed25519.pub".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/files/general/id_ed25519.pub";

    # Claude and OpenCode skills.
    ".claude/skills".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.claude/skills";
    ".agents/skills".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.agents/skills";

    # OpenCode and Claude settings (plugins, mcps etc.)
    ".config/opencode/opencode.jsonc".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/files/ai/opencode.jsonc";
    ".claude/settings.json".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/files/ai/claude-settings.json";
  } // lib.optionalAttrs (!isDarwin) {
    # ollama automatic start config (systemd is Linux/WSL only)
    ".config/systemd/user/ollama.service".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/files/ollama.service";
  } // lib.optionalAttrs isDarwin {
    # ghostty config
    "Library/Application Support/com.mitchellh.ghostty/config.ghostty".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/files/macos/config.ghostty";

    # aerospace config
    ".aerospace.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/files/macos/.aerospace.toml";
  };

  # ollama automatic start on macOS via launchd (systemd equivalent)
  launchd.agents.ollama = lib.mkIf isDarwin {
    enable = true;
    config = {
      ProgramArguments = [ (lib.getExe pkgs.ollama) "serve" ];
      RunAtLoad = true;
      KeepAlive = {
        SuccessfulExit = false;
        Crashed = true;
      };
      ProcessType = "Interactive";
    };
  };
}
