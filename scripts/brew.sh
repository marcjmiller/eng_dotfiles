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

# Ideally, there should be nothing installed at this point...
# printf "Upgrading packages... "
# brew upgrade &> /dev/null
# wait
# printf "done! \n"

# ===============================================================
#            Install helpers for Homebrew by OS
# ===============================================================

printf "Checking for helpers for $PLATFORM... "

case $PLATFORM in
    "MacOS") 
        if [[ ! `brew ls --versions coreutils` ]]; then 
            printf "Not found, installing... ";
            brew install coreutils &> /dev/null;
            wait;
            printf "done! \n"

        else
            printf "Found coreutils, skipping. \n"

        fi
    ;;
    "Linux") 
        sudo apt install build-essential curl file git &> /dev/null
        wait
        printf "done! \n"
    ;;
    *) printf "Unable to find helpers for Homebrew for $PLATFORM. \n"
    ;;
esac


# ===============================================================
#                   Install NerdFonts Hasklug
# ===============================================================

# printf "Checking for Nerdfonts Hasklug ... "
# 
#     case $PLATFORM in
#         "MacOS")
#             if [[ ! `brew cask ls --versions font-hasklig` ]]; then
#                 printf "Not found, installing... ";
#                 brew tap homebrew/cask-fonts &> /dev/null &> /dev/null; 
#                 wait; 
#                 brew cask install --fontdir=/Library/Fonts font-hasklig-nerd-font-mono &> /dev/null;
#                 wait;
#                 printf "done! \n"
# 
#             else
#                 printf "Found Hasklug, skipping. \n"
# 
#             fi
#         ;;
#         "Linux") 
#             if [[ ! -f ~/.local/share/fonts/Hasklug_Nerd_Font_Complete.otf ]]; then
#                 printf "Not found, installing... "
#                 mkdir -p ~/.local/share/fonts; 
#                 curl -fLo ~/.local/share/fonts/Hasklug_Nerd_Font_Complete.otf https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/Hasklig/Regular/complete/Hasklug%20Nerd%20Font%20Complete.otf &> /dev/null;
#                 wait;
#                 printf "done! \n"
# 
#             else
#                 printf "Found Hasklug, skipping. \n"
# 
#             fi
#         ;;
#         *) 
#             printf "Don't know how to install for $PLATFORM, exiting."
#             exit 1
#         ;;
#     esac   

# ===============================================================
#                   Install ZSH and Oh My ZSH
# ===============================================================

source $HOME/scripts/zsh_setup.sh

# ===============================================================
#                      Install new software
# ===============================================================

printf "Beginning Homebrew installs... \n"
printf "Tapping homebrew/bundle... \n"
brew tap homebrew/bundle &> /dev/null;
wait;
printf "done! \n"

printf "Beginning Homebrew Bundle using ~/scripts/Brewfile-$PLATFORM... \n"
brew bundle --file=$HOME/scripts/Brewfile-$PLATFORM
