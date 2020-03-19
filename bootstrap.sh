#!/usr/bin/env bash

# Set bash to exit on error
set -e

# ===============================================================
#                            Functions
# ===============================================================

info() {
  printf "\r  [\033[00;36mINFO\033[0m] $1\n"
}

user() {
  printf "\r  [ \033[0;33m??\033[0m ] $1\n"
}

success() {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

fail() {
  printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
  echo ''
  exit
}

install_pkg() {
  if [ $(command -v "$1") ]; then
    info "$1 already installed..."
  else 
    case $DISTRO in
    void)
      info "Installing $1"
      sudo xbps-install -y "$1" &>/dev/null  
      success "Installed $1"
      ;;

    ubuntu* | debian* | elementary*)
      sudo apt install "$1" &>/dev/null
      success "Installed $1"
      ;;

    *)
      fail "Sorry, don't know how to install packages for $DISTRO"
      ;;
    esac
  fi
}

# ===============================================================
#                     Grab sudo and keep it
# ===============================================================

sudo -v
while true;
do 
  sudo -n true;
  sleep 60;
  kill -0 "$$" || exit;
done 2>/dev/null &

# ===============================================================
#                         Determine OS
# ===============================================================

info "Determining OS... "
PLATFORM="unknown"

case $OSTYPE in
darwin*)
  PLATFORM="MacOS"
  success "Found $PLATFORM."
  ;;

linux*)
  PLATFORM="Linux"
  if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO=$NAME
    success "Found $DISTRO $PLATFORM." 
  else
    fail "Unable to determine distro"
  fi
  ;;

msys*)
  PLATFORM="Windows"
  fail "Sorry, these dotfiles don't handle Windows yet, if interested, fork and create a PR."
  ;;

*)
  fail "Unable to determine distro, exiting"
  ;;
esac

# ===============================================================
#     If they're not already there, grab dotfiles from Gitlab
# ===============================================================

if [[ -f $HOME/.dotfiles/README.md ]]; then
  info "Gitlab repo has already been pulled, skipping. "

else
  if [[ $PLATFORM == "MacOS" ]]; then
    if xcode-select --install 2>&1 | grep installed; then
      info "xcode-select already installed... "
    else
      info "Installing MacOS command-line tools... "
    fi
    success "done!"

  elif [[ $PLATFORM == "Linux" ]]; then
    install_pkg git
    install_pkg curl
    install_pkg rsync
    install_pkg gcc
    install_pkg file
    install_pkg wget
    install_pkg zsh
  fi

  info "Dotfiles not found, cloning repo from gitlab to tmpdotfiles in $HOME... "
  # git clone --separate-git-dir=$HOME/.dotfiles git@gitlab.devops.geointservices.io:dgs1sdt/engineer-dotfiles.git tmpdotfiles &
  git clone --separate-git-dir=$HOME/.dotfiles https://github.com/marcjmiller/eng_dotfiles.git tmpdotfiles &
  #wait
  success "done!"

  info "Copying from tmpdotfiles to $HOME... "
  rsync --recursive --verbose --exclude '.git' tmpdotfiles/ $HOME/ &
  #wait
  success "done!"

  info "Cleaning up tmpdotfiles... "
  rm -r tmpdotfiles &
  #wait
  success "done!"

  success "Dotfiles downloaded... "
fi

info "Setting local status.showUntrackedFiles no for dotfiles repo... "
git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME config --local status.showUntrackedFiles no
success "done!"

# ===============================================================
#         Install Homebrew/Linuxbrew if not already present
# ===============================================================

info "Checking for Homebrew... "

if [ $(command -v brew) ]; then
  info "Homebrew found, skipping install"
else
  info "Homebrew not found. "
  info "Starting Homebrew installation for $PLATFORM... "

  if [[ $PLATFORM == "Linux" ]]; then
    if [ !$(command -v brew) ]; then
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
      echo 'eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)' >> $HOME/.bash_profile
      eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
    fi

  elif [[ $PLATFORM == "MacOS" ]]; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

  else
    fail "Unable to install Homebrew, exiting... "

  fi
fi

# ===============================================================
#             Install Homebrew and run our Brewfile
# ===============================================================

info "Exiting bootstrap, beginning brew... "
source $HOME/scripts/brew.sh

# ===============================================================
#                   Install ZSH and Oh My ZSH
# ===============================================================

source $HOME/scripts/zsh_setup.sh

# ===============================================================
#                  Set some sane MacOS defaults
# ===============================================================

if [[ $PLATFORM == "MacOS" ]]; then
  info "Setting defaults for MacOS... "
  source $HOME/scripts/set_macos_defaults.sh
  success "done!"
fi
