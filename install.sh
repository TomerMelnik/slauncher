#!/usr/bin/env bash

# Set installation directory (default to $HOME/.local/bin if not provided)
INSTALL_DIR="${HOME}/.local/bin"
SLAUNCHER_SOURCE="./slauncher"  # Path to your 'slauncher' script
FZF_REPO="https://github.com/junegunn/fzf.git"
FZF_DIR="${HOME}/.fzf"

# Ensure the installation directory exists
mkdir -p "$INSTALL_DIR"

# Install fzf (if not already installed)
if [ ! -f "$INSTALL_DIR/fzf" ]; then
  # Clone the fzf repository if it's not already present
  if [ ! -d "$FZF_DIR" ]; then
    git clone --depth 1 "$FZF_REPO" "$FZF_DIR"
  fi

  # Run the fzf install script
  "$FZF_DIR/install" --bin

  # Move the fzf binary to the installation directory
  mv "$FZF_DIR/bin/fzf" "$INSTALL_DIR"
fi

# Copy slauncher to the installation directory
cp "$SLAUNCHER_SOURCE" "$INSTALL_DIR/slauncher"

# Ensure slauncher is executable
chmod +x "$INSTALL_DIR/slauncher"

# Notify the user
echo "slauncher has been installed to $INSTALL_DIR."

# Check if ~/.local/bin is in the PATH
if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
  echo "Warning: $INSTALL_DIR is not in your PATH. You may need to manually add it."
fi
