# set browser to Windows's chrome in WSL
[[ $CURRENT_OS == wsl ]] && export BROWSER="/mnt/c/Program Files/Google/Chrome/Application/chrome.exe"

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

# enable brew in macOS
[[ $CURRENT_OS == darwin ]] && eval "$(/opt/homebrew/bin/brew shellenv zsh)"

# bun global installs
export PATH="/Users/loeiks/.bun/bin:$PATH"