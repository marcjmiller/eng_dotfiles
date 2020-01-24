#!/usr/bin/env bash

# ===============================================================
#     If they're not already there, grab dotfiles from Gitlab
# ===============================================================
DOTFILES=$HOME/.dotfiles/config
if [[ test -f "$DOTFILES" ]]; then
    echo "Gitlab repo has already been pulled, skipping."
else
    echo "Dotfiles not found, cloning repo from gitlab to $HOME/tmpdotfiles..."
    git clone --separate-git-dir=$HOME/.dotfiles git@gitlab.devops.geointservices.io:dgs1sdt/engineer-dotfiles.git tmpdotfiles

    echo "Copying from tmpdotfiles to $HOME..."
    rsync --recursive --verbose --exclude '.git' tmpdotfiles/ $HOME/

    echo "Cleaning up tmpdotfiles..."
    rm -r tmpdotfiles

    echo "Setting dotfiles alias for managing dotfiles"
    alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
    dotfiles config --local status.showUntrackedFiles no
    echo "Dotfiles downloaded... \n\n"
fi

# ===============================================================
#                       Determine OS 
# ===============================================================
echo "Determining OS..."
PLATFORM='unknown'
case $OSTYPE in
    darwin*) PLATFORM='MacOS';
    ;;
    linux*) PLATFORM='Linux';
    ;;
    msys*) PLATFORM='Windows';
    ;;
    *) echo "Unable to determine OS, exiting"
    ;;
esac
echo "Found $PLATFORM."

# ===============================================================
#         Install Homebrew/Linuxbrew if not already present
# ===============================================================

echo "Checking for Homebrew install..."
BREW_LOC=$(which brew)
if [[ $BREW_LOC == "brew not found" ]]; then
    echo "Starting Homebrew installation for $PLATFORM";
    if [[ $PLATFORM == "Linux" ]]; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)";
        echo 'eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)' 
    elif [[ $PLATFORM == "MacOS" ]]; then
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)";
    else
        echo "Unable to install Homebrew, exiting...";
    fi
else 
    echo "Homebrew found at $BREW_LOC"
fi
echo "Exiting bootstrap, beginning installs."
source ~/scripts/brew.sh