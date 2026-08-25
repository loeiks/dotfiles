{
  pkgs,
  ...
}:

let
isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
currentOS = if isDarwin then "darwin" else "linux";
in

{
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    CURRENT_OS = currentOS;
  };

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

    # update OS if its WSL
    if [[ $CURRENT_OS == linux ]] && grep -qi microsoft /proc/version 2>/dev/null; then
    export CURRENT_OS=wsl
    fi

    # zsh extra
    source ~/dotfiles/files/zsh/extra.zsh

    # zinit and plugins
    source ${pkgs.zinit}/share/zinit/zinit.zsh
    source ~/dotfiles/files/zsh/plugins.zsh

    # aliases and functions
    source ~/dotfiles/files/zsh/aliases.zsh
    source ~/dotfiles/files/zsh/functions.zsh
    '';
  };
}
