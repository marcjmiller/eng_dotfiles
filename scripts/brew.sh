#!/usr/bin/env bash

# ===============================================================
#              Ensure Homebrew is newest version
# ===============================================================

info "Updating Homebrew... "
brew update
success "done!"

# ===============================================================
#            Install helpers for Homebrew by OS
# ===============================================================

info "Checking for helpers for $PLATFORM... "

case $PLATFORM in
"MacOS")
  if [[ ! $(brew ls --versions coreutils) ]]; then
    info "Not found, installing... "
    brew install coreutils &>/dev/null
    wait
    success "done!"

  else
    info "Found coreutils, skipping. "

  fi
  ;;

"Linux")
  install_pkg file
  #wait
  success "done!"
  ;;

*)
  info "Unable to find helpers for Homebrew for $PLATFORM. "
  ;;

esac

# ===============================================================
#                      Install new software
# ===============================================================

info "Beginning Homebrew installs... "
info "Tapping homebrew/bundle... "
brew tap homebrew/bundle &>/dev/null
success "done!"

info "Beginning Homebrew Bundle using ~/scripts/$PLATFORM/Brewfile ... "
brew bundle --file=$HOME/scripts/$PLATFORM/Brewfile
