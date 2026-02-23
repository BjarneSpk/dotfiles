#!/usr/bin/env zsh

# Set up fzf key bindings and fuzzy completion
export FZF_DEFAULT_COMMAND='fd --hidden --strip-cwd-prefix --exclude "{.git,.DS_Store}"'

export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
# Preview file content using bat (https://github.com/sharkdp/bat)
export FZF_CTRL_T_OPTS="
  --preview '"$XDG_CONFIG_HOME"/zsh/fzf-preview.sh {}'
  --preview-window right:60%
  --height 50%
  --layout reverse
  --border
  --bind 'ctrl-/:change-preview-window(50%|hidden|)'
  --prompt 'Files> '
  --header 'CTRL-T: Switch between Files/Directories'
  --bind 'ctrl-t:transform:
    if [[ ! \$FZF_PROMPT =~ Files ]]; then
      echo change-prompt\(Files\>\ \)+reload\(fd --type file --hidden --strip-cwd-prefix --exclude .git\)
    else
      echo change-prompt\(Directories\>\ \)+reload\(fd --type directory --hidden --strip-cwd-prefix --exclude .git\)
    fi'
  --info inline
"

export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND --type d"
# Print tree structure in the preview window
export FZF_ALT_C_OPTS="--preview 'eza --tree --level=2 --color=always {} | head -200'"

# needed for alt c to work, ugly workaround, fixed by kitty settings to use right option as alt.
# bindkey "ç" fzf-cd-widget
export FZF_CTRL_R_OPTS="
  --bind 'ctrl-y:execute-silent(echo -n {2..} | wl-copy)+abort'
  --color header:italic
  --header 'CTRL-Y: Copy command into clipboard'
  --scheme history
"

# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
    fd --hidden --follow --exclude "{.git,.DS_Store}" . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude "{.git,.DS_Store}" . "$1"
}

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift
  case "$command" in
    cd)           fzf --preview 'eza --tree --level=2 --color=always {} | head -200'   "$@" ;;
    export|unset) fzf --preview "eval 'echo \${}'"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview 'bat -n --color=always {}' "$@" ;;
  esac
}
