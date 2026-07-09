#!/bin/bash

install_packages() {
  sudo apt update
  sudo apt install -y ack \
    git \
    tree \
    htop \
    clang-format \
    cmake-format \
    cmake-curses-gui

  echo "Installed packages."
}

setup_oh_my_zsh() {
  # Install zsh if needed
  if ! command -v zsh >/dev/null 2>&1; then
    sudo apt install -y zsh
  fi

  # Install Oh My Zsh
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  fi

  # Determine repo dir (where this script lives)
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

  # If there is a .zshrc in the repo, use that
  if [ -f "$SCRIPT_DIR/.zshrc" ]; then
    cp "$SCRIPT_DIR/.zshrc" "$HOME/.zshrc"
    echo "Copied repo .zshrc to \$HOME/.zshrc."
  elif [ ! -f "$HOME/.zshrc" ]; then
    # Fallback to Oh My Zsh template
    cp "$HOME/.oh-my-zsh/templates/zshrc.zsh-template" "$HOME/.zshrc"
    echo "Created default ~/.zshrc from Oh My Zsh template."
  fi

  echo "OMZ installed. Start zsh or run: chsh -s /usr/bin/zsh"
}

setup_vimrc() {
  # Assumes script is in the repo root and .vimrc is there
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  REPO_VIMRC="$SCRIPT_DIR/.vimrc"

  if [ ! -f "$REPO_VIMRC" ]; then
    echo "Could not find $REPO_VIMRC"
    return 1
  fi

  cp "$REPO_VIMRC" "$HOME/.vimrc"
  echo "Copied repo .vimrc to \$HOME/.vimrc."
}

echo "1) Install packages (ack, tree)"
echo "2) Setup Oh My Zsh with jonathan theme"
echo "3) Setup .vimrc from this repo"
echo "4) Do everything"
echo "0) Exit"
read -rp "Choose an option: " choice

case "$choice" in
  1)
    install_packages
    ;;
  2)
    setup_oh_my_zsh
    ;;
  3)
    setup_vimrc
    ;;
  4)
    install_packages
    setup_oh_my_zsh
    setup_vimrc
    ;;
  0)
    echo "Bye."
    ;;
  *)
    echo "Invalid option."
    ;;
esac