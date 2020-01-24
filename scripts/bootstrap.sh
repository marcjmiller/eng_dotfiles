#!/usr/bin/env bash

# ===============================================================
#     If they're not already there, grab dotfiles from Gitlab
# ===============================================================

DOTFILES=$HOME/.dotfiles/description
if [[ -f $DOTFILES ]]; then
    printf "Gitlab repo has already been pulled, skipping."
else
    printf "Dotfiles not found, cloning repo from gitlab to $HOME/tmpdotfiles..."
    git clone --separate-git-dir=$HOME/.dotfiles git@gitlab.devops.geointservices.io:dgs1sdt/engineer-dotfiles.git tmpdotfiles

    printf "Copying from tmpdotfiles to $HOME..."
    rsync --recursive --verbose --exclude '.git' tmpdotfiles/ $HOME/

    printf "Cleaning up tmpdotfiles..."
    rm -r tmpdotfiles

    printf "Setting dotfiles alias for managing dotfiles"
    alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
    dotfiles config --local status.showUntrackedFiles no
    printf "Dotfiles downloaded... \n\n"
fi

# ===============================================================
#                       Determine OS 
# ===============================================================

printf "Determining OS..." -n
PLATFORM='unknown'
case $OSTYPE in
    darwin*) PLATFORM='MacOS';
    ;;
    linux*) PLATFORM='Linux';
    ;;
    msys*) PLATFORM='Windows';
    ;;
    *) printf "Unable to determine OS, exiting"
    ;;
esac
printf "Found $PLATFORM."

# ===============================================================
#         Install Homebrew/Linuxbrew if not already present
# ===============================================================

printf "Checking for Homebrew..." -n
BREW_LOC=$(which brew)
if [[ $BREW_LOC == "brew not found" ]]; then
    printf "Homebrew not found"
    printf "Starting Homebrew installation for $PLATFORM";
    if [[ $PLATFORM == "Linux" ]]; then
        if [[ -f /home/linuxbrew/.linuxbrew/bin/brew ]]; then 
            printf "/home/linuxbrew/.linuxbrew/bin/brew found, adding to env & ~/.zprofile"
            eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
            echo 'eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)' >>~/.zprofile
        else
            sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)";
            printf 'eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)'
        fi
    elif [[ $PLATFORM == "MacOS" ]]; then
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)";
    else
        printf "Unable to install Homebrew, exiting...";
    fi
else 
    printf "Homebrew found at $BREW_LOC"
fi

# ===============================================================
#             Bootstrap complete, time for brew.sh
# ===============================================================

printf "Exiting bootstrap, beginning installs."
source ~/scripts/brew.sh