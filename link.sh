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

DOT_CONFIG_HOME="${DOTFILES}/dots/.config"

link "$DOT_CONFIG_HOME/zsh" "${XDG_CONFIG_HOME}/zsh"
link "$DOT_CONFIG_HOME/git" "${XDG_CONFIG_HOME}/git"
link "$DOT_CONFIG_HOME/nvim" "${XDG_CONFIG_HOME}/nvim"
link "$DOT_CONFIG_HOME/tmux" "${XDG_CONFIG_HOME}/tmux"
link "$DOT_CONFIG_HOME/yazi" "${XDG_CONFIG_HOME}/yazi"
link "$DOT_CONFIG_HOME/kitty" "${XDG_CONFIG_HOME}/kitty"
link "$DOT_CONFIG_HOME/bat" "${XDG_CONFIG_HOME}/bat"
# link "$DOT_CONFIG_HOME/aerospace" "${XDG_CONFIG_HOME}/aerospace"
link "$DOT_CONFIG_HOME/hypr" "${XDG_CONFIG_HOME}/hypr"
link "$DOT_CONFIG_HOME/waybar" "${XDG_CONFIG_HOME}/waybar"
link "$DOT_CONFIG_HOME/wlogout" "${XDG_CONFIG_HOME}/wlogout"
link "$DOT_CONFIG_HOME/btop" "${XDG_CONFIG_HOME}/btop"
link "$DOT_CONFIG_HOME/rofi" "${XDG_CONFIG_HOME}/rofi"
link "$DOT_CONFIG_HOME/swaync" "${XDG_CONFIG_HOME}/swaync"
link "$DOT_CONFIG_HOME/xdg-desktop-portal" "${XDG_CONFIG_HOME}/xdg-desktop-portal"
link "$DOT_CONFIG_HOME/fontconfig" "${XDG_CONFIG_HOME}/fontconfig"
link "$DOT_CONFIG_HOME/qt5ct" "${XDG_CONFIG_HOME}/qt5ct"
link "$DOT_CONFIG_HOME/qt6ct" "${XDG_CONFIG_HOME}/qt6ct"
link "$DOT_CONFIG_HOME/kdeglobals" "${XDG_CONFIG_HOME}/kdeglobals"
link "$DOT_CONFIG_HOME/code-flags.conf" "${XDG_CONFIG_HOME}/code-flags.conf"
link "$DOT_CONFIG_HOME/matugen" "${XDG_CONFIG_HOME}/matugen"
link "$DOT_CONFIG_HOME/cliphist" "${XDG_CONFIG_HOME}/cliphist"
link "$DOT_CONFIG_HOME/scripts" "${XDG_CONFIG_HOME}/scripts"
link "$DOT_CONFIG_HOME/quickshell" "${XDG_CONFIG_HOME}/quickshell"

SRC_DIR="$DOT_CONFIG_HOME/theme"
for file in "$SRC_DIR"/*; do
    base=$(basename "$file")

    if [[ "$base" == ".gtkrc-2.0" ]]; then
        link "$file" "${HOME}/$base"
    else
        link "$file" "${XDG_CONFIG_HOME}/$base"
    fi
done

matugen image "${DOTFILES}/dots/.config/hypr/wall.jpg" --mode dark
