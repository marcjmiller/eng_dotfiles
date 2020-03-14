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

# Set bash to exit on error
set -e

info () {
  printf "\r  [ \033[00;34m..\033[0m ] $1"
}

user () {
  printf "\r  [ \033[0;33m??\033[0m ] $1\n"
}

success () {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

fail () {
  printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
  echo ''
  exit
}

info "Determining OS... "
PLATFORM="unknown"

case $OSTYPE in
    darwin*) PLATFORM="MacOS";
    ;;

    linux*) PLATFORM="Linux";
    ;;

    msys*) PLATFORM="Windows";
    ;;

    *) fail "Unable to determine OS, exiting" 
    ;;
esac

info "Found $PLATFORM. \n"

# ===============================================================
#     If they're not already there, grab dotfiles from Gitlab
# ===============================================================

if [[ -f $HOME/.dotfiles/README.md ]]; then
    info "Gitlab repo has already been pulled, skipping. \n"

else
    if [[ $PLATFORM == "MacOS" ]]; then
        if xcode-select --install 2>&1 | grep installed; then
		info "xcode-select already installed... \n"
	else
		info "Installing MacOS command-line tools... "
	fi
	success "done!"
    fi
    
    info "Dotfiles not found, cloning repo from gitlab to tmpdotfiles in $HOME... "
    # git clone --separate-git-dir=$HOME/.dotfiles git@gitlab.devops.geointservices.io:dgs1sdt/engineer-dotfiles.git tmpdotfiles &
    git clone --separate-git-dir=$HOME/.dotfiles https://github.com/marcjmiller/eng_dotfiles.git tmpdotfiles &
    wait
    success "done!"

    info "Copying from tmpdotfiles to $HOME... "
    rsync --recursive --verbose --exclude '.git' tmpdotfiles/ $HOME/ &
    wait
    success "done!"

    info "Cleaning up tmpdotfiles... "
    rm -r tmpdotfiles &
    wait
    success "done!"

    success "Dotfiles downloaded... \n"
fi

info "Setting local status.showUntrackedFiles no for dotfiles repo... \n"
/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME config --local status.showUntrackedFiles no
success "done!"

# ===============================================================
#         Install Homebrew/Linuxbrew if not already present
# ===============================================================

info "Checking for Homebrew... " -n

which -s brew
if [[ $? != 0 ]]; then
    info "Homebrew not found. \n"
    info "Starting Homebrew installation for $PLATFORM... \n";

    if [[ $PLATFORM == "Linux" ]]; then
        if [[ -f /home/linuxbrew/.linuxbrew/bin/brew ]]; then 
            info "/home/linuxbrew/.linuxbrew/bin/brew found, adding to env & ~/.zprofile... \n"
            eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
            echo 'eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)' >>~/.zprofile

        else
            sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)";
            echo 'eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)'
            echo 'eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)' >>~/.zprofile

        fi
    elif [[ $PLATFORM == "MacOS" ]]; then
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)";

    else
        fail "Unable to install Homebrew, exiting... \n";

    fi
else 
    info "Homebrew found at $BREW_LOC. \n"
fi

# ===============================================================
#             Install Homebrew and run our Brewfile 
# ===============================================================

info "Exiting bootstrap, beginning brew... \n"
source $HOME/scripts/brew.sh

# ===============================================================
#                   Install ZSH and Oh My ZSH
# ===============================================================

source $HOME/scripts/zsh_setup.sh

# ===============================================================
#                  Set some sane MacOS defaults
# ===============================================================

if [[ $PLATFORM == "MacOS" ]]; then
	info "Setting defaults for MacOS... \n"
	source $HOME/scripts/set_macos_defaults.sh
	success "done!"
fi
