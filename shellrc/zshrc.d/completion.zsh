autoload -Uz compinit; compinit 

# +---------+
# | options |
# +---------+

# Add hidden files to completion
_comp_options+=(globdots)
setopt MENU_COMPLETE
setopt AUTO_LIST 

# +---------+
# | zstyles |
# +---------+

# Ztyle pattern
# :completion:<function>:<completer>:<command>:<argument>:<tag>

zstyle ':completion:*' completer _extensions _complete _approximate

# add cache for completions
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"

# add menu 
zstyle ':completion:*' menu select

zstyle ':completion:*' file-sort modification

# colors
export LS_COLORS="$(vivid generate catppuccin-macchiato)"
zstyle ':completion:*:*:*:*:default' list-colors ${(s.:.)LS_COLORS}

# messages
zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'
zstyle ':completion:*:*:*:*:descriptions' format '%F{blue}-- %D %d --%f'
zstyle ':completion:*:*:*:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:*:*:*:warnings' format ' %F{red}-- no matches found --%f'

zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories

# Group commands
zstyle ':completion:*' group-name ''
zstyle ':completion:*:*-command-:*:*' group-order aliases builtins functions commands

zstyle ':completion:*' keep-prefix true
