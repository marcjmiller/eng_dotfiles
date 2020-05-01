#!/usr/bin/env bash

# ===============================================================
#              Ensure Homebrew is newest version
# ===============================================================

task "Updating Homebrew... "
brew update > /dev/null 2>&1 &
wait_last
success  "Updating Homebrew... "

# ===============================================================
#            Install helpers for Homebrew by OS
# ===============================================================

info "Checking for helpers for $PLATFORM... "

case $PLATFORM in
"MacOS")
  if [[ ! $(brew ls --versions coreutils) ]]; then
    task "Coreutils not found, installing... "
    brew install coreutils > /dev/null 2>&1 &
    wait_last
    success  "Coreutils not found, installing... "

  else
    info "Found coreutils, skipping. "

  fi
  ;;

"Linux")
  success "Nothing to do on $PLATFORM"
  ;;

*)
  info "Unable to find helpers for Homebrew for $PLATFORM.  Attempting to continue... "
  ;;

esac

# ===============================================================
#                      Install new software
# ===============================================================

info "Beginning Homebrew installs... "
info "Tapping homebrew/bundle... "
brew tap homebrew/bundle > /dev/null 2>&1 &
wait_last
success  "Tapping homebrew/bundle... "

task "Beginning Homebrew Bundle using ~/scripts/$PLATFORM/Brewfile ... (This may take awhile) "
brew bundle --file=$HOME/scripts/$PLATFORM/Brewfile > /dev/null 2>&1 &
wait_last
success "Beginning Homebrew Bundle using ~/scripts/$PLATFORM/Brewfile ... (This may take awhile) "