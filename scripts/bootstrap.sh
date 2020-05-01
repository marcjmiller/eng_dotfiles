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

skip() {
  printf "\r\033[2K  [ \033[00;32mSKIP\033[0m ] $1\n"
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

task "Requesting root privileges"
sudo -v
while true; do 
  sudo -n true;
  sleep 60;
  kill -0 "$$" || exit;
done 2>/dev/null &
success "Requesting root privileges"

# ===============================================================
#                         Determine OS
# ===============================================================

task "Determining OS... "
PLATFORM="unknown"

case $(uname) in
"Darwin")
  PLATFORM="MacOS"
  success "Determining OS... Found $PLATFORM."
  ;;

"Linux")
  PLATFORM="Linux"
  if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO=$NAME
    success "Found $DISTRO $PLATFORM." 
  else
    info "Determining OS..."
    fail "Unable to determine distro\n /etc/os-release contains: $(cat /etc/os-release)"
  fi
  ;;

"msys")
  PLATFORM="Windows"
  fail "Sorry, these dotfiles don't handle Windows yet, if interested, fork and create a PR."
  ;;

*)
  info "Determining OS..."
  
  fail "Troubleshooting info: uname output $(uname)\n Unable to determine Platform, exiting... "
  ;;
esac

# ===============================================================
#     If they're not already there, grab dotfiles fhe repo
# ===============================================================

task "Checking for dotfiles repo..."
if [ -d $HOME/.dotfiles/ ]; then
  skip "Checking for dotfiles repo... repo found, skipping. "
else
  task "Installing helpers for $PLATFORM..."
  
  if [ $PLATFORM == "MacOS" ]; then
    if xcode-select --install 2>&1 | grep installed; then
      skip "Installing helpers for $PLATFORM... xcode-select found, skipping. "
      
    else
      task "Installing helpers for $PLATFORM... Installing xcode-select... "
      success "Installing helpers for $PLATFORM... Installing xcode-select... done!"
    fi
    
  elif [ $PLATFORM == "Linux" ]; then
    task "Installing helpers for $PLATFORM... Installing git curl rsync file wget zsh... "
    install_pkg git curl rsync file wget zsh
    success "Installing helpers for $PLATFORM... Installing git curl rsync file wget zsh... done!"
  fi
  
  task "Dotfiles not found, cloning repo to `tmpdotfiles` in $HOME... "
  git clone --separate-git-dir=$HOME/.dotfiles https://github.com/marcjmiller/eng_dotfiles.git tmpdotfiles > /dev/null 2>&1 &
  wait_last
  success "Dotfiles not found, cloning repo to `tmpdotfiles` in $HOME... done!"

  task "Copying from tmpdotfiles to $HOME... "
  rsync --recursive --verbose --exclude '.git' tmpdotfiles/ $HOME > /dev/null 2>&1 &
  wait_last
  success "Copying from tmpdotfiles to $HOME... done!"

  task "Cleaning up tmpdotfiles... "
  rm -r tmpdotfiles
  success "Cleaning up tmpdotfiles... done!"
fi

task "Setting local status.showUntrackedFiles no for dotfiles repo... "
git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME config --local status.showUntrackedFiles no
success "Setting local status.showUntrackedFiles no for dotfiles repo... done!"

# ===============================================================
#         Install Homebrew/Linuxbrew if not already present
# ===============================================================

task "Checking for Homebrew... "

if [ $(command -v brew) ]; then
  skip "Checking for Homebrew... Homebrew found, skipping."
else
  task "Checking for Homebrew... Homebrew not found, installing... "
  case $PLATFORM in
    Linux)
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
      echo 'eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)' >> $HOME/.bash_profile
      eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
      success "Checking for Homebrew... Homebrew not found, installing... done!"
    ;;

    MacOS)
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
      success "Checking for Homebrew... Homebrew not found, installing... done!"

      task "Creating brew group and chmod'ing to make homebrew multi-user..."
      sudo dscl . create /Groups/brew Homebrew "Users that can access Homebrew"
      sudo dscl . create /Groups/brew gid 405
      sudo dscl . create /Groups/brew GroupMembership $(whoami)
      sudo chgrp -R brew $(brew --prefix)/*
      sudo chmod -R g+w brew $(brew --prefix)/*
      sudo mkdir /usr/local/Frameworks
      sudo chgrp -R brew /usr/local/Frameworks
      sudo chmod -R g+w /usr/local/Frameworks
      success "Creating brew group and chmod'ing to make homebrew multi-user... done!"
    ;;

    *)
      fail "Unable to install Homebrew for $PLATFORM, exiting... "
    ;;
  esac
fi

# ===============================================================
#             Install Homebrew and run our Brewfile
# ===============================================================

source $HOME/scripts/brew.sh

# ===============================================================
#                   Install ZSH and Oh My ZSH
# ===============================================================

source $HOME/scripts/zsh_setup.sh

# ===============================================================
#                  Set some sane MacOS defaults
# ===============================================================

if [ $PLATFORM == "MacOS" ]; then
  source $HOME/scripts/MacOS/set_macos_defaults.sh
fi

# ===============================================================
#                  Setup SSH key for version control
# ===============================================================

task "Checking for SSH Key..."

if [ -f $HOME/.ssh/id_rsa ]; then
  skip "Checking for SSH Key... found ssh key, skipping."
  
else
  task "Checking for SSH Key... not found, generating... "
  ssh-keygen -t rsa -b 4096 -C "engineer@dgs1sdt.com" -f $HOME/.ssh/id_rsa -q -P ""
  success "Checking for SSH Key... not found, generating... done!"

fi
info "Copying SSH Key to clipboard"
pbcopy < $HOME/.ssh/id_rsa.pub
info "Opening Chromium to input key for Geointservices.io"
chromium https://gitlab.devops.geointservices.io/profile/keys &

info "That's all folks!"