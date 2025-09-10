#!/usr/bin/env zsh

link() {
  local target=$1
  local link=$2

  local parent_dir=$(dirname $link)
  if [[ ! -d $parent_dir ]]; then
    mkdir -p $parent_dir
  fi

  if [[ -e $link || -L $link ]]; then
    print -P "%F{yellow}Warning:%f Link target already exists: ${link}"
    print -P "Choose an option:"
    print -P "1) Replace (backup old file to ${link}.bak)"
    print -P "2) Skip this link"
    while true; do
      read -k "choice?Your choice [1/2]: "
      case $choice in
        1)
          print "\nBacking up existing file and creating new link"
          mv "$link" "${link}.bak"
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

source ./zshenv
link "${DOTFILES}/zshenv" "${HOME}/.zshenv"

link "${DOTFILES}/zsh" "${XDG_CONFIG_HOME}/zsh"
link "${DOTFILES}/git" "${XDG_CONFIG_HOME}/git"
link "${DOTFILES}/nvim" "${XDG_CONFIG_HOME}/nvim"
link "${DOTFILES}/tmux" "${XDG_CONFIG_HOME}/tmux"
link "${DOTFILES}/yazi" "${XDG_CONFIG_HOME}/yazi"
link "${DOTFILES}/kitty" "${XDG_CONFIG_HOME}/kitty"
link "${DOTFILES}/bat" "${XDG_CONFIG_HOME}/bat"
link "${DOTFILES}/aerospace" "${XDG_CONFIG_HOME}/aerospace"
link "${DOTFILES}/hypr" "${XDG_CONFIG_HOME}/hypr"
link "${DOTFILES}/waybar" "${XDG_CONFIG_HOME}/waybar"
link "${DOTFILES}/wlogout" "${XDG_CONFIG_HOME}/wlogout"
link "${DOTFILES}/btop" "${XDG_CONFIG_HOME}/btop"
link "${DOTFILES}/rofi" "${XDG_CONFIG_HOME}/rofi"
link "${DOTFILES}/swaync" "${XDG_CONFIG_HOME}/swaync"

SRC_DIR="${DOTFILES}/theme"
for file in "$SRC_DIR"/*; do
    base=$(basename "$file")

    if [[ "$base" == ".gtkrc-2.0" ]]; then
        link "$file" "${HOME}/$base"
    else
        link "$file" "${XDG_CONFIG_HOME}/$base"
    fi
done
