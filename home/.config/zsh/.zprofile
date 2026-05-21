export DOTFILES="$HOME/dotfiles"
export PATH="$DOTFILES/scripts:$PATH"

# Add cargo to PATH
if [[ -f "$HOME/.cargo/env" ]]; then
  source "$HOME/.cargo/env"
fi

export GOPATH="$HOME/.go"

export EDITOR="nvim"
export VISUAL="$EDITOR"
