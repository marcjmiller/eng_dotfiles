#!/usr/bin/env bash

# Set bash to exit on error
set -e

# ===============================================================
#                            Functions
# ===============================================================

info() {
  printf "\r  [ \033[00;36mINFO\033[0m ] $1\n"
}

success() {
  printf "\r\033[2K  [ \033[00;32mDONE\033[0m ] $1\n"
}

task() {
  printf "\r  [ \033[00;34mTASK\033[0m ] $1\r"
}

user() {
  printf "\r  [  \033[0;33m??\033[0m  ] $1\n"
}

fail() {
  printf "\r\033[2K  [ \033[0;31mFAIL\033[0m ] $1\n"
  echo ''
  exit
}

wait_last() {
  BACKPID=$!
  wait $BACKPID
}

install_pkg() {
  while [ -n "$pkg" ]; do
    if [ $(command -v "$pkg") ]; then
      info "$pkg already installed..."

    else 
      case $DISTRO in
      void)
        task "Installing $pkg"
        sudo xbps-install -y "$pkg" > /dev/null 2>&1 &
        wait_last  
        success "Installing $pkg"
        ;;

      ubuntu*|debian*|elementary*|Pop*)
        task "Installing $pkg"
        sudo apt install -y "$pkg" > /dev/null 2>&1 &
        wait_last
        success "Installing $pkg"
        ;;

      *)
        fail "Sorry, don't know how to install packages for $DISTRO"
        ;;
      esac
    fi
    shift
  done
}

# ===============================================================
#                     Grab sudo and keep it
# ===============================================================

sudo -v
while true; do 
  sudo -n true;
  sleep 60;
  kill -0 "$$" || exit;
done 2>/dev/null &

# ===============================================================
#                         Determine OS
# ===============================================================

info "Determining OS... "
PLATFORM="unknown"

case $(uname) in
"Darwin")
  PLATFORM="MacOS"
  success "Found $PLATFORM."
  ;;

"Linux")
  PLATFORM="Linux"
  if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO=$NAME
    success "Found $DISTRO $PLATFORM." 
  else
    info "/etc/os-release contains: $(cat /etc/os-release)"
    fail "Unable to determine distro"
  fi
  ;;

"msys")
  PLATFORM="Windows"
  fail "Sorry, these dotfiles don't handle Windows yet, if interested, fork and create a PR."
  ;;

*)
  info "Troubleshooting info: uname output $(uname)"
  fail "Unable to determine Platform, exiting... "
  ;;
esac

# ===============================================================
#     If they're not already there, grab dotfiles fhe repo
# ===============================================================

if [ -d $HOME/.dotfiles/ ]; then
  info "dotfiles repo has already been pulled, skipping. "
else
  info "Installing helpers for $PLATFORM"
  
  if [ $PLATFORM == "MacOS" ]; then
    if xcode-select --install 2>&1 | grep installed; then
      info "xcode-select already installed... "
      
    else
      task "Installing MacOS command-line tools... "
      
    fi
    success "done!"
    
  elif [ $PLATFORM == "Linux" ]; then
    install_pkg git curl rsync file wget zsh
  fi
  success "done!"
  
  task "Dotfiles not found, cloning repo to `tmpdotfiles` in $HOME... "
  git clone --separate-git-dir=$HOME/.dotfiles https://github.com/marcjmiller/eng_dotfiles.git tmpdotfiles > /dev/null 2>&1 &
  wait_last
  success "Dotfiles not found, cloning repo to `tmpdotfiles` in $HOME... "

  task "Copying from tmpdotfiles to $HOME... "
  rsync --recursive --verbose --exclude '.git' tmpdotfiles/ $HOME > /dev/null 2>&1 &
  wait_last
  success "Copying from tmpdotfiles to $HOME... "

  task "Cleaning up tmpdotfiles... "
  rm -r tmpdotfiles
  success "Cleaning up tmpdotfiles... "

  success "Dotfiles downloaded... "
fi

task "Setting local status.showUntrackedFiles no for dotfiles repo... "
git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME config --local status.showUntrackedFiles no
success "Setting local status.showUntrackedFiles no for dotfiles repo... "

# ===============================================================
#         Install Homebrew/Linuxbrew if not already present
# ===============================================================

info "Checking for Homebrew... "

if [ $(command -v brew) ]; then
  info "Homebrew found, skipping install"
else
  info "Homebrew not found. "
  task "Starting Homebrew installation for $PLATFORM..."
  case $PLATFORM in
    Linux)
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
      echo 'eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)' >> $HOME/.bash_profile
      eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
      success "Starting Homebrew installation for $PLATFORM..."
    ;;

    MacOS)
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
      success "Starting Homebrew installation for $PLATFORM..."

      task "Creating brew group and chmod'ing to make homebrew multi-user..."
      sudo dscl . create /Groups/brew Homebrew "Users that can access Homebrew"
      sudo dscl . create /Groups/brew gid 405
      sudo dscl . create /Groups/brew GroupMembership $(whoami)
      sudo chgrp -R brew $(brew --prefix)/*
      sudo chmod -R g+w brew $(brew --prefix)/*
      sudo mkdir /usr/local/Frameworks
      sudo chgrp -R brew /usr/local/Frameworks
      sudo chmod -R g+w /usr/local/Frameworks
      success "Creating brew group and chmod'ing to make homebrew multi-user..."
    ;;

    *)
      fail "Unable to install Homebrew for $PLATFORM, exiting... "
    ;;
  esac
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

if [ $PLATFORM == "MacOS" ]; then
  task "Setting defaults for MacOS... "
  source $HOME/scripts/MacOS/set_macos_defaults.sh
  success "Setting defaults for MacOS... "
fi
