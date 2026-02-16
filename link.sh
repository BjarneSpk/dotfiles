#!/usr/bin/env zsh

link() {
  local target=$1
  local link=$2

  local parent_dir=$(dirname $link)
  if [[ ! -d $parent_dir ]]; then
    mkdir -p $parent_dir
  fi

  if [[ -e $link || -L $link ]]; then
    print -P "%F{yellow}Warning:%f Link target already exists: $link"
    print -P "Choose an option:"
    print -P "1) Replace (backup old file to $link.bak)"
    print -P "2) Skip this link"
    while true; do
      read -k "choice?Your choice [1/2]: "
      case $choice in
        1)
          print "\nBacking up existing file and creating new link"
          mv "$link" "$link.bak"
          ln -sf "$target" "$link"
          return 0
          ;;
        2)
          print "\nSkipping this link"
          return 0
          ;;
        *)
          print "\nInvalid choice, please try again"
          ;;
      esac
    done
  else
    ln -s "$target" "$link"
  fi
}

install_config() {
  link "$DOTFILES/dots/.zshenv" "$HOME/.zshenv"
  link "$DOTFILES/dots/.gtkrc-2.0" "$HOME/.gtkrc-2.0"

  SRC_DIR="$DOTFILES/dots/.config"
  for file in "$SRC_DIR"/*; do
      base=$(basename "$file")

      link "$file" "$XDG_CONFIG_HOME/$base"
  done
}

source ./dots/.zshenv

install_config
