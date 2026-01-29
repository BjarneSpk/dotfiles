# Dotfile Repo


## Installation


```sh
git clone https://github.com/BjarneSpk/dotfiles.git ${HOME}

cd ~/dotfiles

sudo pacman -S --needed - < pkglist.txt

./link.sh
```

## Bundle packages

```sh
pacman -Qqe > pkglist.txt
```
