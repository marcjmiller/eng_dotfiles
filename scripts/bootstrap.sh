#!/usr/bin/env bash

# Set bash to exit on error
set -e

# ===============================================================
#                            Functions
# ===============================================================

info() {
  printf "\r  [\033[00;34mINFO\033[0m] $1\n"
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
  for pkg in "$@"; do
    if [ $(command -v "$pkg") ]; then
      case $DISTRO in
      void)
        sudo xbps-install -y $pkg &>/dev/null &
        wait
        success "Installed $pkg"
        ;;

      ubuntu* | debian* | elementary*)
        sudo apt install $pkg &>/dev/null
        success "Installed $pkg"
        ;;

      *)
        fail "Sorry, don't know how to install packages for $DISTRO"
        ;;
      esac
    fi
  done
}

# ===============================================================
#                       Determine OS/DISTRO
# ===============================================================

info "Determining OS... "
PLATFORM="unknown"

case $OSTYPE in
darwin*)
  PLATFORM="MacOS"
  ;;

linux*)
  PLATFORM="Linux"
  ;;

msys*)
  PLATFORM="Windows"
  ;;

*)
  fail "Unable to determine DISTRO, exiting"
  ;;
esac

info "Found $PLATFORM. "

# ===============================================================
#     Determine how we will install packages prior to brew
# ===============================================================

if [ $PLATFORM == "Linux" ]; then
  info "Determining Linux distro... "
  if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO=$NAME
    success "Found $DISTRO."
  fi
fi

info "Determininig package management binary... "
if [ $DISTRO == "void" ]; then
  info "Found Void Linux, using xbps-install"
fi

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
    install_pkg git curl rsync 
    # install_pkg curl
    # install_pkg rsync
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

  success "Dotfiles downloaded... "
fi

info "Setting local status.showUntrackedFiles no for dotfiles repo... "
git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME config --local status.showUntrackedFiles no
success "done!"

# ===============================================================
#         Install Homebrew/Linuxbrew if not already present
# ===============================================================

info "Checking for Homebrew... " -n

which -s brew
if [[ $? != 0 ]]; then
  info "Homebrew not found. "
  info "Starting Homebrew installation for $PLATFORM... "

  if [[ $PLATFORM == "Linux" ]]; then
    if [[ -f /home/linuxbrew/.linuxbrew/bin/brew ]]; then
      info "/home/linuxbrew/.linuxbrew/bin/brew found, adding to env & ~/.zprofile... "
      eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
      echo 'eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)' >>~/.zprofile

    else
      sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
      echo 'eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)'
      echo 'eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)' >>~/.zprofile

    fi
  elif [[ $PLATFORM == "MacOS" ]]; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

  else
    fail "Unable to install Homebrew, exiting... "

  fi
else
  info "Homebrew found at $BREW_LOC. "
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
