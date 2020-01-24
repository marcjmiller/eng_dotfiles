#!/usr/bin/env bash

# ===============================================================
#              Ensure Homebrew is newest version
# ===============================================================

printf "Updating Homebrew... " -n
brew update

# ===============================================================
#          Upgrade software already installed by brew
# ===============================================================

printf "Upgrading packages... \n"
brew upgrade

# ===============================================================
#            Install helpers for Homebrew by OS
# ===============================================================


printf "Installing helpers for Homebrew... $PLATFORM. \n"

case $PLATFORM in
    "MacOS") brew install coreutils
    ;;
    "Linux") sudo apt install build-essential curl file git
    ;;
    *) printf "Unable to find helpers for Homebrew for $PLATFORM. \n"
    ;;
esac

# ===============================================================
#                   Install ZSH and Oh My ZSH
# ===============================================================

source $HOME/scripts/zsh_setup.sh

# ===============================================================
#                      Install new software
# ===============================================================

printf "Beginning Homebrew installs... \n"

