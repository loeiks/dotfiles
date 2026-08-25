{
  config,
  pkgs,
  ...
}:

let
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
  dotfilesOS = if isDarwin then "darwin" else "linux"; # see extra.zsh
in

{
  # Home Manager needs a bit of information about you and the paths it should manage.
  home.username = "loeiks";
  home.homeDirectory = if isDarwin then "/Users/loeiks" else "/home/loeiks";
  home.stateVersion = "26.05";

  # The home.packages option allows you to install Nix packages into your environment.
  home.packages = [
    pkgs.zinit
    pkgs.oh-my-posh
    pkgs.neovim
    pkgs.tmux
    pkgs.github-cli
    pkgs.google-cloud-sdk
    pkgs.pnpm
    pkgs.yt-dlp
    pkgs.tree
    pkgs.bun
    pkgs.fzf

    pkgs.opencode
    pkgs.claude-code

    # unsupported in macOS
    pkgs.xclip
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage plain files is through 'home.file'.
  home.file = {
    ".tmux.conf".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/files/.tmux.conf";

    ".config/nvim".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/files/nvim";

    ".scripts/install-docker.sh" = {
      source = ../scripts/install-docker.sh;
      executable = true;
    };

    ".scripts/init.js".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/init.js";
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    DOTFILES_OS = dotfilesOS;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # General zsh settings and configs
  programs.zsh = {
    enable = true;
    enableCompletion = true;

    completionInit = ''
      fpath=(~/.zsh/completions $fpath)
      zstyle ':completion:*' menu select
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
      zstyle ':completion::complete:*' use-cache 1
      zstyle ':completion::complete:*' cache-path $ZSH_CACHE_DIR
    '';

    history = {
      size = 5000;
      save = 5000;
      ignoreDups = true;
      ignoreSpace = true;
      extended = true;
      share = true;
      append = true;
      expireDuplicatesFirst = true;
      ignoreAllDups = true;
      findNoDups = true;
      saveNoDups = true;
    };

    setOptions = [
      "autocd"
      "extendedglob"
      "no_beep"
      "auto_pushd"
      "pushd_ignore_dups"
      "pushd_silent"
      "always_to_end"
      "auto_menu"
      "complete_in_word"
      "path_dirs"
      "auto_param_slash"
      "correct"
    ];

    initContent = ''
      # env variables and zsh extra
      source ~/.nix-profile/etc/profile.d/hm-session-vars.sh
      source ~/dotfiles/files/zsh/extra.zsh

      # zinit and plugins
      source ${pkgs.zinit}/share/zinit/zinit.zsh
      source ~/dotfiles/files/zsh/plugins.zsh

      # aliases and functions
      source ~/dotfiles/files/zsh/aliases.zsh
      source ~/dotfiles/files/zsh/functions.zsh
    '';
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "loeiks";
        email = "loeiks@icloud.com";
      };
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };
}
