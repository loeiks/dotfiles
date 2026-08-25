alias gg='$BROWSER'

alias rr='unset __HM_SESS_VARS_SOURCED; exec zsh'
alias rrl='unset __HM_SESS_VARS_SOURCED; exec su -l "$USER"'

source ~/dotfiles/files/zsh/os/aliases-${DOTFILES_OS:-linux}.zsh
