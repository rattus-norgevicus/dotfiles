autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

setopt share_history
setopt HIST_SAVE_NO_DUPS

bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search
