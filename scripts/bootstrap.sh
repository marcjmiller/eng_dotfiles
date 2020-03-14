#!/usr/bin/env bash

# ===============================================================
#                Export colornames to colors
# ===============================================================

# define RESET       "\033[0m"
# define BLACK       "\033[30m"
# define RED         "\033[31m"
# define GREEN       "\033[32m"
# define YELLOW      "\033[33m"
# define BLUE        "\033[34m"
# define MAGENTA     "\033[35m"
# define CYAN        "\033[36m"
# define WHITE       "\033[37m"
# 
# printf ( RED "Test" RESET );

# ===============================================================
#                       Determine OS 
# ===============================================================

printf "Determining OS... "
PLATFORM="unknown"

case $OSTYPE in
    darwin*) PLATFORM="MacOS";
    ;;

    linux*) PLATFORM="Linux";
    ;;

    msys*) PLATFORM="Windows";
    ;;

    *) printf "Unable to determine OS, exiting \n"
    ;;
esac

printf "Found $PLATFORM. \n"

# ===============================================================
#     If they're not already there, grab dotfiles from Gitlab
# ===============================================================

if [[ -f $HOME/.dotfiles/README.md ]]; then
    printf "Gitlab repo has already been pulled, skipping. \n"

else
    printf "Dotfiles not found, cloning repo from gitlab to tmpdotfiles in $HOME... "
    git clone --separate-git-dir=$HOME/.dotfiles git@gitlab.devops.geointservices.io:dgs1sdt/engineer-dotfiles.git tmpdotfiles &
    wait
    printf "done! \n"

    printf "Copying from tmpdotfiles to $HOME... "
    rsync --recursive --verbose --exclude '.git' tmpdotfiles/ $HOME/ &
    wait
    printf "done! \n"

    printf "Cleaning up tmpdotfiles... "
    rm -r tmpdotfiles &
    wait
    printf "done! \n"

    printf "Dotfiles downloaded... \n\n"
fi

printf "Setting dotfiles alias for managing dotfiles... \n"
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

printf "Setting local status.showUntrackedFiles no for dotfiles repo... \n"
dotfiles config --local status.showUntrackedFiles no

# ===============================================================
#         Install Homebrew/Linuxbrew if not already present
# ===============================================================

printf "Checking for Homebrew... " -n
BREW_LOC=$(which brew)

if [[ $BREW_LOC == "brew not found" ]]; then
    printf "Homebrew not found. \n"
    printf "Starting Homebrew installation for $PLATFORM... \n";

    if [[ $PLATFORM == "Linux" ]]; then
        if [[ -f /home/linuxbrew/.linuxbrew/bin/brew ]]; then 
            printf "/home/linuxbrew/.linuxbrew/bin/brew found, adding to env & ~/.zprofile... \n"
            eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
            echo 'eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)' >>~/.zprofile

        else
            sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)";
            echo 'eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)'
            echo 'eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)' >>~/.zprofile

        fi
    elif [[ $PLATFORM == "MacOS" ]]; then
        printf "Installing xcode command line tools... "
        xcode-select --install > /dev/null 2>&1 &
        wait
        printf "done! \n"

        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)";
        
        # printf "Making Homebrew multi-admin friendly... "
        # chgrp admin -R /usr/local/* &
        # chmod -R g+w /usr/local/* &
        # wait
        # printf "done! \n"

    else
        printf "Unable to install Homebrew, exiting... \n";

    fi
else 
    printf "Homebrew found at $BREW_LOC. \n"
fi

# ===============================================================
#             Bootstrap complete, time for brew.sh
# ===============================================================

printf "Exiting bootstrap, beginning brew... \n"
source ~/scripts/brew.sh
