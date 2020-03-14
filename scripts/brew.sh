#!/usr/bin/env bash

# ===============================================================
#              Ensure Homebrew is newest version
# ===============================================================

info "Updating Homebrew... " 
brew update &> /dev/null
wait
success "done!"

# ===============================================================
#            Install helpers for Homebrew by OS
# ===============================================================

info "Checking for helpers for $PLATFORM... "

case $PLATFORM in
    "MacOS") 
        if [[ ! `brew ls --versions coreutils` ]]; then 
            info "Not found, installing... ";
            brew install coreutils &> /dev/null;
            wait;
            success "done!"

        else
            info "Found coreutils, skipping. \n"

        fi
    ;;
    "Linux") 
        sudo apt install build-essential curl file git &> /dev/null
        wait
        success "done!"
    ;;
    *) info "Unable to find helpers for Homebrew for $PLATFORM. \n"
    ;;
esac

# ===============================================================
#                      Install new software
# ===============================================================

info "Beginning Homebrew installs... \n"
info "Tapping homebrew/bundle... \n"
brew tap homebrew/bundle &> /dev/null;
wait;
success "done!"

info "Beginning Homebrew Bundle using ~/scripts/Brewfile-$PLATFORM... \n"
brew bundle --file=$HOME/scripts/Brewfile-$PLATFORM
