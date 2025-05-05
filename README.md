# Dotfile Repo

## Prerequisites

- Install [Homebrew](https://brew.sh)

## Installation

1.

```sh
git clone https://github.com/BjarneSpk/dotfiles.git ${HOME}
```

2.

```sh
./link.sh
```

3.

```sh
brew bundle --file "${DOTFILES}/Brewfile"
```

## Bundle packages

```sh
brew bundle dump --force
```
