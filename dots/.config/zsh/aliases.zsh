#!/usr/bin/env zsh

alias lg="lazygit"
alias vim="nvim"
alias c="clear"
alias ls="eza --color"
alias tree="eza --tree --color --icons --git"
alias la="ls --sort=time --color -a"
alias l="ls --sort=time --color --icons -la"
alias lt="eza --tree --level=2 --long --color --icons --git -A"
alias cat="bat"
alias top="btop"
# alias pow="upower -i $(upower -e | grep BAT) | grep -oP '(percentage:\s*\K(\d*%)|state:\s*\K(.*))' | sort | tr '\n' ' ' && echo"
alias pac-browse="pacman -Qq | fzf --preview 'pacman -Qil {}' --layout=reverse --bind 'enter:execute(pacman -Qil {} | less)'"
alias open="xdg-open"
alias infvpn="sudo openconnect --protocol=anyconnect vpn.informatik.uni-stuttgart.de --cafile ~/Downloads/infcacert.crt"

mcd() {
    mkdir "${1}" && cd "${1}"
}

# used to reload colors with matugen
TRAPUSR1() {
  source "$DOTFILES/dots/.config/zsh/colors.zsh"
}

# Makes Yazi change into cwd when called with 'ex' and exited with 'q'
function ex() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

alias grep='grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox,.venv,venv}'
alias egrep='grep -E'
alias fgrep='grep -F'

rfv() {
  # Two-phase filtering with Ripgrep and fzf
  #
  # 1. Search for text in files using Ripgrep
  # 2. Interactively restart Ripgrep with reload action
  #   * Switch between Ripgrep mode and fzf filtering mode (CTRL-T)
  # 3. Open the file in Neovim
  rm -f /tmp/rg-fzf-{r,f}
  RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case "
  INITIAL_QUERY="${*:-}"
  fzf --ansi --disabled --query "$INITIAL_QUERY" \
      --bind "start:reload:$RG_PREFIX {q}" \
      --bind "change:reload:sleep 0.1; $RG_PREFIX {q} || true" \
      --bind 'ctrl-t:transform:[[ ! $FZF_PROMPT =~ ripgrep ]] &&
        echo "rebind(change)+change-prompt(1. ripgrep> )+disable-search+transform-query:echo \{q} > /tmp/rg-fzf-f; cat /tmp/rg-fzf-r" ||
        echo "unbind(change)+change-prompt(2. fzf> )+enable-search+transform-query:echo \{q} > /tmp/rg-fzf-r; cat /tmp/rg-fzf-f"' \
      --color "hl:-1:underline,hl+:-1:underline:reverse" \
      --prompt '1. ripgrep> ' \
      --delimiter : \
      --header 'CTRL-T: Switch between ripgrep/fzf' \
      --preview 'bat --color=always {1} --highlight-line {2}' \
      --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
      --bind 'enter:become(vim {1} +{2})'
}

rfi() {
  export TEMP=$(mktemp -u)
  trap 'rm -f "$TEMP"' EXIT

  INITIAL_QUERY="${*:-}"
  TRANSFORMER='
    rg_pat={q:1}      # The first word is passed to ripgrep
    fzf_pat={q:2..}   # The rest are passed to fzf

    if ! [[ -r "$TEMP" ]] || [[ $rg_pat != $(cat "$TEMP") ]]; then
      echo "$rg_pat" > "$TEMP"
      printf "reload:sleep 0.1; rg --column --line-number --no-heading --color=always --smart-case %q || true" "$rg_pat"
    fi
    echo "+search:$fzf_pat"
  '
  fzf --ansi --disabled --query "$INITIAL_QUERY" \
      --with-shell 'bash -c' \
      --bind "start,change:transform:$TRANSFORMER" \
      --color "hl:-1:underline,hl+:-1:underline:reverse" \
      --delimiter : \
      --preview 'bat --color=always {1} --highlight-line {2}' \
      --preview-window 'up,60%,border-line,+{2}+3/3,~3' \
      --bind 'enter:become(vim {1} +{2})'
}

alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'
alias -- -='cd -'
alias 1='cd -1'
alias 2='cd -2'
alias 3='cd -3'
alias 4='cd -4'
alias 5='cd -5'
alias 6='cd -6'
alias 7='cd -7'
alias 8='cd -8'
alias 9='cd -9'

# alias d='dirs -v'
alias d='cd ${~"$(dirs -v | fzf | awk "{print \$2}")"}'
for index ({1..9}) alias "$index"="cd +${index}"; unset index

function uniprint() {
# Set the print location based on the second argument
  if [ "$2" = "oben" ]; then
    standort="duesentrieb"
  else
    standort="zarquon"
  fi

  # Check if the first argument is a directory
  if [ -d "$1" ]; then
    # Loop through all PDF files in the directory
    for elem in "$1"/*.pdf; do
      # Check if any PDF files exist
      if [ -f "$elem" ]; then
        # Copy the file to the remote server and print it
        scp "$elem" "uni:~/Documents/$(basename "$elem")"
        ssh uni "lpr -P $standort ~/Documents/$(basename "$elem")"
      fi
    done
  else
    # If it's a file, copy and print it
    scp "$1" "uni:~/Documents/$(basename "$1")"
    ssh uni "lpr -P $standort ~/Documents/$(basename "$1")"
  fi
}

systemfzf() {
help() {
    cat >&2 <<EOF
Usage: fuzzy-sys [options]
Utility for using systemctl interactively via fzf.
If no options are given fully interactive mode is launched with system service units being used.
    -u          : work with --user services
    --start     : systemctl start <unit>
    --stop      : systemctl stop <unit>
    --restart   : systemctl restart <unit>
    --status    : systemctl status <unit>
    --edit      : systemctl edit --full <unit>
    --enable    : systemctl enable --now <unit>
    --disable   : systemctl disable --now <unit>
    --journal   : systemctl journal <unit>
    --help      : print this message and exit

Examples:
    fuzzy-sys -u --edit    : edit a user service
    fuzzy-sys --start      : start a system service
EOF
}


preview_service() {
    case $1 in
        --system|--user)
            awk '{print $1}' | fzf --multi --ansi --preview="SYSTEMD_COLORS=1 systemctl $1 -n 30 status --no-pager {}" ;;
        *) exit 1
    esac
}

promptmode() {
    case $super in
        system) printf '%s\n' --system ;;
        user) printf '%s\n' --user ;;
        *)
            case $(fzf --reverse --prompt='Select the service type:' <<< $'system\nuser') in
                system) printf '%s\n' --system ;;
                user) printf '%s\n' --user ;;
                *) exit 1
            esac
    esac
}

_sudo() {
    case $mode in
        --system) command sudo "$@" ;;
        --user) "$@"
    esac
}

interactive() {
    mode=$(fzf --reverse --ansi --prompt="Select systemctl mode:" < <(
    printf '\033[0;32m%s\033[0m\n' start
    printf '\033[0;31m%s\033[0m\n' stop
    printf '\033[0;37m%s\033[0m\n' restart
    printf '\033[0;37m%s\033[0m\n' status
    printf '\033[0;37m%s\033[0m\n' edit
    printf '\033[0;32m%s\033[0m\n' enable
    printf '\033[0;31m%s\033[0m\n' disable
    printf '\033[0;36m%s\033[0m\n' journal
    ))

    case $mode in
        start) sysstart ;;
        stop) sysstop ;;
        restart) sysrestart ;;
        status) sysstatus ;;
        edit) sysedit ;;
        enable) sysenable ;;
        journal) journalf ;;
        disable) sysdisable
    esac
}

sysstart() {
    mode=$(promptmode)

    systemctl "$mode" list-unit-files --no-legend --type=service \
        | preview_service "$mode" \
        | while read -r unit && [ "$unit" ]; do
            if _sudo systemctl "$mode" start "$unit"; then
                systemctl "$mode" -n20 status "$unit" --no-pager
            fi
        done
}

sysstop() {
    mode=$(promptmode)

    systemctl "$mode" list-units --no-legend --type=service --state=running \
        | preview_service "$mode" \
        | while read -r unit && [ "$unit" ]; do
            if _sudo systemctl "$mode" stop "$unit"; then
                systemctl "$mode" -n20 status "$unit" --no-pager
            fi
        done
}

sysrestart() {
    mode=$(promptmode)

    systemctl "$mode" list-unit-files --no-legend --type=service \
        | preview_service "$mode" \
        | while read -r unit && [ "$unit" ]; do
            if _sudo systemctl "$mode" restart "$unit"; then
                systemctl "$mode" -n20 status "$unit" --no-pager
            fi
        done
}

sysstatus() {
    mode=$(promptmode)

    systemctl "$mode" list-unit-files --no-legend --type=service \
        | preview_service "$mode" \
        | while read -r unit && [ "$unit" ]; do
            systemctl "$mode" -n20 status "$unit" --no-pager
        done
}

sysedit() {
    mode=$(promptmode)

    units=($(systemctl "$mode" list-unit-files --no-legend --type=service \
        | preview_service "$mode"))
    _sudo systemctl "$mode" edit --full "${units[@]}"
}

sysenable() {
    mode=$(promptmode)

    systemctl "$mode" list-unit-files --no-legend --type=service --state=disabled \
        | preview_service "$mode" \
        | while read -r unit && [ "$unit" ]; do
            if _sudo systemctl "$mode" enable --now "$unit"; then
                systemctl "$mode" -n20 status "$unit" --no-pager
            fi
        done
}

sysdisable() {
    mode=$(promptmode)

    systemctl "$mode" list-unit-files --no-legend --type=service --state=enabled \
        | preview_service "$mode" \
        | while read -r unit && [ "$unit" ]; do
            if _sudo systemctl "$mode" disable --now "$unit"; then
                systemctl "$mode" -n20 status "$unit" --no-pager
            fi
        done
}

journalf() {
    mode=$(promptmode)

    systemctl "$mode" list-units --no-legend --type=service --state=running \
        | preview_service "$mode" \
        | while read -r unit && [ "$unit" ]; do
            if _sudo journalctl "$mode" -u "$unit" -f; then
                journalctl "$mode" -n20 -u "$unit" -f --no-pager
            fi
        done
}

super=system
while :; do
    case $1 in
        --user|-u)
            super=user
            ;;
        start)
         sysstart
         break
         ;;
        stop)
         sysstop
         break
         ;;
        restart)
         sysrestart
         break
         ;;
        status)
         sysstatus
         break
         ;;
        edit)
         sysedit
         break
         ;;
        enable)
         sysenable
         break
         ;;
        disable)
            sysdisable
            break
            ;;
        journal)
            journalf
            break
            ;;
        -h|--help)
            help
            break
            ;;
        *)
            interactive
            break
    esac
    shift
done
}
