# detect wsl at runtime, more reliable
if [[ $DOTFILES_OS == linux ]] && grep -qi microsoft /proc/version 2>/dev/null; then
  export DOTFILES_OS=wsl
  export BROWSER="/mnt/c/Program Files/Google/Chrome/Application/chrome.exe"
fi

# configure correct oh my posh config
eval "$(oh-my-posh init zsh --config "$HOME/dotfiles/files/omp.json")"

# fzf fullscreen layout, also tmux
export FORGIT_FULLSCREEN="true"
export FORGIT_FZF_DEFAULT_OPTS="--height=100%"

# set vi mode for prompt
bindkey -v
export KEYTIMEOUT=1

# auto-quote URLs on paste
autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic
autoload -Uz bracketed-paste-magic
zle -N bracketed-paste bracketed-paste-magic