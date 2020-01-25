#!/usr/bin/env bash

# ===============================================================
#              Ensure Homebrew is newest version
# ===============================================================

printf "Updating Homebrew... " 
brew update &> /dev/null
wait
printf "done! \n"

# ===============================================================
#          Upgrade software already installed by brew
# ===============================================================

printf "Upgrading packages... "
#brew upgrade &> /dev/null
#wait
printf "done! \n"

# ===============================================================
#            Install helpers for Homebrew by OS
# ===============================================================

printf "Checking for helpers for $PLATFORM... "
if [[ ! `brew ls --versions coreutils` ]]; then 
    printf "Not found, installing... "

    case $PLATFORM in
        "MacOS") brew install coreutils &> /dev/null; wait; printf "done! \n"
        ;;
        "Linux") sudo apt install build-essential curl file git &> /dev/null; wait; printf "done! \n"
        ;;
        *) printf "Unable to find helpers for Homebrew for $PLATFORM. \n"
        ;;
    esac

else
    printf "Found helpers, skipping. \n"

fi

# ===============================================================
#                   Install NerdFonts Hasklug
# ===============================================================

printf "Checking for Nerfonts Hasklig... "
if [[ ! `brew cask ls --versions font-hasklig` ]]; then
    printf "Not found, installing... "
    brew tap homebrew/cask-fonts &> /dev/null
    wait

    case $PLATFORM in
        "MacOS") brew cask install --fontdir=/Library/Fonts font-hasklig-nerd-font-mono &> /dev/null
        ;;
        "Linux") brew cask install font-hasklig-nerd-font-mono &> /dev/null
        ;;
        *) printf "Unable to find helpers for Homebrew for $PLATFORM. \n"
        ;;
    esac
    
    wait
    printf "done! \n"

else
    printf "Found Hasklig, skipping. \n"
fi

# ===============================================================
#                   Install ZSH and Oh My ZSH
# ===============================================================

source $HOME/scripts/zsh_setup.sh

# ===============================================================
#            Install new software with homebrew bundle
# ===============================================================

printf "Beginning Homebrew installs... \n"
brew tap homebrew/bundle &> /dev/null

brew bundle --file=$HOME/scripts/Brewfile-$PLATFORM