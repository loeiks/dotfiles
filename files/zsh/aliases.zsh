# some aliases requires to be handled differently based on OS
# so in those case handle them below in OS if/then blocks

alias gg='$BROWSER'

alias rr='source ~/.zshrc'
alias rrl='exec su -l "$USER"'

# Linux specific
if [[ $CURRENT_OS == linux ]]; then
  alias ls='ls --color=auto'
  alias see='xdg-open'
  alias clip='xclip -selection clipboard'
fi

# macOS specific
if [[ $CURRENT_OS == darwin ]]; then
  alias ls='ls -G'
  alias see='open'
  alias clip='pbcopy'
fi

# WSL specific
if [[ $CURRENT_OS == wsl ]]; then
  alias ls='ls --color=auto'
  alias see='explorer.exe'
  alias clip='clip.exe'
fi