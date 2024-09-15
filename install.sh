#!/usr/bin/env bash

# Set installation directory (default to $HOME/.local/bin if not provided)
INSTALL_DIR="${HOME}/.local/bin"
FZF_REPO="https://github.com/junegunn/fzf.git"
FZF_DIR="${HOME}/.fzf"

# Ensure the installation directory exists
mkdir -p "$INSTALL_DIR"

# Clone the fzf repository if it's not already present
if [ ! -d "$FZF_DIR" ]; then
  git clone --depth 1 "$FZF_REPO" "$FZF_DIR"
fi

# Run the fzf install script
"$FZF_DIR/install" --bin

# Move the fzf binary to the installation directory
mv "$FZF_DIR/bin/fzf" "$INSTALL_DIR"

# Update .bashrc or .zshrc to include fzf in the PATH
if [[ "$SHELL" == */zsh ]]; then
  RC_FILE="${HOME}/.zshrc"
else
  RC_FILE="${HOME}/.bashrc"
fi

if ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' "$RC_FILE"; then
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$RC_FILE"
  echo "Added fzf to your PATH. Please restart your shell or run 'source $RC_FILE'."
fi

echo "fzf has been installed to $INSTALL_DIR."

