PROMPT=' %F{#f6c177}%n%f %F{#ebbcba}%1~%f %F{#524f67}%#%f '

export LS_COLORS="di=38;2;235;188;186:fi=38;2;49;116;143:ln=38;2;235;111;146:*.=38;2;156;207;216"
export XDG_CONFIG_HOME="$HOME/.config"

# Set up fzf key bindings and fuzzy completion
# disable ctrl t
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
export FZF_ALT_C_OPTS="
  --preview 'eza --tree --level=2 --color=always {} | head -200'"
# needed for alt c to work
bindkey "ç" fzf-cd-widget
# CTRL-Y to copy the command into clipboard using pbcopy
#
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
    export|unset) fzf --preview "eval 'echo \$'{}"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview 'bat -n --color=always {}' "$@" ;;
  esac
}

export MANPAGER="sh -c 'col -bx | bat -l man -p'"

DISABLE_LS_COLORS="false"

HIST_STAMPS="mm/dd/yyyy"

# Makes Yazi change into cwd when called with 'y' and exited with 'q'
function ex() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# export MANPATH="/usr/local/man:$MANPATH"

setopt HIST_IGNORE_SPACE
# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi
#
source ~/dotfiles/zsh/aliases.zsh

# Some homebrew stuff 
autoload -Uz compinit
compinit

# Destroys the fzf **<tab> feature
# bindkey -v

source <(fzf --zsh)

eval "$(zoxide init zsh)"
