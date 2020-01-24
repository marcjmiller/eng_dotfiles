#!/bin/sh

# ===============================================================
#              Ensure Homebrew is newest version
# ===============================================================

printf "Updating Homebrew... \n"
brew update

# ===============================================================
#          Upgrade software already installed by brew
# ===============================================================

printf "Upgrading packages... \n"
brew upgrade

# ===============================================================
#                 If MacOS, install coreutils
# ===============================================================

if [[ $OSTYPE == "darwin*" ]]; then
    printf "Installing updated coreutils for MacOS"
    brew install coreutils
fi

# ===============================================================
#                      Install new software
# ===============================================================

printf "Beginning Homebrew installs... \n"