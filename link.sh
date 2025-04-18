#!/bin/zsh

backup_and_link() {
  local target=$1
  local link=$2

  # local parent_dir=$(dirname $link)
  # if [[ ! -d $parent_dir ]]; then
  #   echo "Creating directory $parent_dir"
  #   mkdir -p $parent_dir
  # fi

  if [[ -e $link || -L $link ]]; then
    echo "Backing up existing $link to ${link}.bak"
    mv $link ${link}.bak
  fi

  echo "Creating symbolic link for $target at $link"
  ln -s "$target" "$link"
}

# Associative array of source to destination mappings
declare -A files=(
  ["~/dotfiles/zsh/.zshrc"]="~/.zshrc"
  ["~/dotfiles/zsh/.zshenv"]="~/.zshenv"
  ["~/dotfiles/zsh/.zprofile"]="~/.zprofile"
  ["~/dotfiles/.gitconfig"]="~/.gitconfig"
  ["~/dotfiles/nvim"]="~/.config/nvim"
  ["~/dotfiles/.tmux.conf"]="~/.tmux.conf"
  ["~/dotfiles/yazi"]="~/.config/yazi"
  ["~/dotfiles/kitty"]="~/.config/kitty"
  ["~/dotfiles/bat"]="~/.config/bat"
  ["~/dotfiles/aerospace"]="~/.config/aerospace"
)

# Iterate through the array and create symlinks
for target link in "${(@kv)files}"; do
  backup_and_link $~target $~link
done
