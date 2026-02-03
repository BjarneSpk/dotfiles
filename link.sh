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

source ./dots/.zshenv
link "${DOTFILES}/dots/.zshenv" "${HOME}/.zshenv"

link "${DOTFILES}/dots/.config/zsh" "${XDG_CONFIG_HOME}/zsh"
link "${DOTFILES}/dots/.config/git" "${XDG_CONFIG_HOME}/git"
link "${DOTFILES}/dots/.config/nvim" "${XDG_CONFIG_HOME}/nvim"
link "${DOTFILES}/dots/.config/tmux" "${XDG_CONFIG_HOME}/tmux"
link "${DOTFILES}/dots/.config/yazi" "${XDG_CONFIG_HOME}/yazi"
link "${DOTFILES}/dots/.config/kitty" "${XDG_CONFIG_HOME}/kitty"
link "${DOTFILES}/dots/.config/bat" "${XDG_CONFIG_HOME}/bat"
# link "${DOTFILES}/dots/.config/aerospace" "${XDG_CONFIG_HOME}/aerospace"
link "${DOTFILES}/dots/.config/hypr" "${XDG_CONFIG_HOME}/hypr"
link "${DOTFILES}/dots/.config/waybar" "${XDG_CONFIG_HOME}/waybar"
link "${DOTFILES}/dots/.config/wlogout" "${XDG_CONFIG_HOME}/wlogout"
link "${DOTFILES}/dots/.config/btop" "${XDG_CONFIG_HOME}/btop"
link "${DOTFILES}/dots/.config/rofi" "${XDG_CONFIG_HOME}/rofi"
link "${DOTFILES}/dots/.config/swaync" "${XDG_CONFIG_HOME}/swaync"
link "${DOTFILES}/dots/.config/xdg-desktop-portal" "${XDG_CONFIG_HOME}/xdg-desktop-portal"
link "${DOTFILES}/dots/.config/fontconfig" "${XDG_CONFIG_HOME}/fontconfig"
link "${DOTFILES}/dots/.config/qt5ct" "${XDG_CONFIG_HOME}/qt5ct"
link "${DOTFILES}/dots/.config/qt6ct" "${XDG_CONFIG_HOME}/qt6ct"
link "${DOTFILES}/dots/.config/kdeglobals" "${XDG_CONFIG_HOME}/kdeglobals"
link "${DOTFILES}/dots/.config/code-flags.conf" "${XDG_CONFIG_HOME}/code-flags.conf"
link "${DOTFILES}/dots/.config/matugen" "${XDG_CONFIG_HOME}/matugen"
link "${DOTFILES}/dots/.config/cliphist" "${XDG_CONFIG_HOME}/cliphist"
link "${DOTFILES}/dots/.config/scripts" "${XDG_CONFIG_HOME}/scripts"

SRC_DIR="${DOTFILES}/dots/.config/theme"
for file in "$SRC_DIR"/*; do
    base=$(basename "$file")

    if [[ "$base" == ".gtkrc-2.0" ]]; then
        link "$file" "${HOME}/$base"
    else
        link "$file" "${XDG_CONFIG_HOME}/$base"
    fi
done

matugen image "${DOTFILES}/dots/.config/hypr/wall.jpg" --mode dark
