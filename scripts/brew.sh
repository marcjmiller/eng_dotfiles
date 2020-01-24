#!/usr/bin/env bash

# ===============================================================
#              Ensure Homebrew is newest version
# ===============================================================

printf "Updating Homebrew... " 
brew update > /dev/null 2>&1 &
wait
printf "done! \n"

# ===============================================================
#          Upgrade software already installed by brew
# ===============================================================

printf "Upgrading packages... "
#brew upgrade > /dev/null 2>&1 &
#wait
printf "done! \n"

# ===============================================================
#            Install helpers for Homebrew by OS
# ===============================================================


printf "Installing $PLATFORM helpers for Homebrew... "

case $PLATFORM in
    "MacOS") brew install coreutils > /dev/null 2>&1 &
    ;;
    "Linux") sudo apt install build-essential curl file git > /dev/null 2>&1 &
    ;;
    *) printf "Unable to find helpers for Homebrew for $PLATFORM. \n"
    ;;
esac

printf "done! \n"

# ===============================================================
#                   Install NerdFonts Hasklug
# ===============================================================

printf "Installing Nerdfonts Hasklug... "
brew tap homebrew/cask-fonts > /dev/null 2>&1 &
wait

case $PLATFORM in
    "MacOS") brew cask install --fontdir=/Library/Fonts font-hasklig-nerd-font-mono > /dev/null 2>&1 &
    ;;
    "Linux") brew cask install font-hasklig-nerd-font-mono > /dev/null 2>&1 &
    ;;
    *) printf "Unable to find helpers for Homebrew for $PLATFORM. \n"
    ;;
esac
wait
printf "done! \n"

# ===============================================================
#                   Install ZSH and Oh My ZSH
# ===============================================================

source $HOME/scripts/zsh_setup.sh

# ===============================================================
#                      Install new software
# ===============================================================

printf "Beginning Homebrew installs... \n"


