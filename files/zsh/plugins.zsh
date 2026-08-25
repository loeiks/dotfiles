# completions
zinit ice lucid wait blockf atload"zicompinit; zicdreplay"
zinit light zsh-users/zsh-completions

# autosuggestions
zinit ice lucid wait
zinit light zsh-users/zsh-autosuggestions

# syntax highlighting (must load last)
zinit light zsh-users/zsh-syntax-highlighting

# history search with up/down arrows
zinit ice lucid wait atload"bindkey '^[[A' history-substring-search-up; bindkey '^[[B' history-substring-search-down"
zinit light zsh-users/zsh-history-substring-search

# fuzzy directory jumping
zinit ice lucid wait
zinit light agkozak/zsh-z

# LS_COLORS - colorized ls output
zinit ice lucid wait
zinit light trapd00r/LS_COLORS

# LS_COLORS for completion menu
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# fzf-based tab completion
zinit ice lucid wait
zinit light Aloxaf/fzf-tab
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -1 --color=always $realpath'
zstyle ':fzf-tab:complete:cd:*' popup-pad 30 0
zstyle ':fzf-tab:complete:ls:*' fzf-preview 'cat $realpath'

# fzf-powered git commands
zinit ice lucid wait
zinit load wfxr/forgit
