#!/usr/bin/env zsh

# Set up fzf key bindings and fuzzy completion
export FZF_DEFAULT_OPTS="
	--color=fg:#908caa,bg:#191724,hl:#ebbcba
	--color=fg+:#e0def4,bg+:#26233a,hl+:#ebbcba
	--color=border:#403d52,header:#31748f,gutter:#191724
	--color=spinner:#f6c177,info:#9ccfd8
	--color=pointer:#c4a7e7,marker:#eb6f92,prompt:#908caa"
export FZF_DEFAULT_COMMAND='fd --hidden --strip-cwd-prefix --exclude "{.git,.DS_Store}"'

export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
# Preview file content using bat (https://github.com/sharkdp/bat)
export FZF_CTRL_T_OPTS="
  --preview 'bat -n --color=always {}'"

export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND --type d"
# Print tree structure in the preview window
export FZF_ALT_C_OPTS="--preview 'eza --tree --level=2 --color=always {} | head -200'"

# needed for alt c to work, ugly workaround, fixed by kitty settings to use right option as alt.
# bindkey "ç" fzf-cd-widget
export FZF_CTRL_R_OPTS="
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --color header:italic
  --header 'Press CTRL-Y to copy command into clipboard'"

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
