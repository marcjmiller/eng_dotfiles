#!/usr/bin/env bash

# ===============================================================
#              Ensure Homebrew is newest version
# ===============================================================

task "Updating Homebrew... "
brew update > /dev/null 2>&1 &
wait_last
success "Updating Homebrew... done!"

# ===============================================================
#            Install helpers for Homebrew by OS
# ===============================================================

task "Checking for helpers for $PLATFORM... "

case $PLATFORM in
"MacOS")
  if [[ ! $(brew ls --versions coreutils) ]]; then
    task "Checking for helpers for $PLATFORM... Coreutils not found, installing... "
    brew install coreutils > /dev/null 2>&1 &
    wait_last
    success "Checking for helpers for $PLATFORM... Coreutils not found, installing... done!"

  else
    skip "Checking for helpers for $PLATFORM... Found coreutils, skipping. "

  fi
  ;;

"Linux")
  skip "Checking for helpers for $PLATFORM... Nothing to do, skipping."
  ;;

*)
  info "Unable to find helpers for Homebrew for $PLATFORM.  Attempting to continue... "
  ;;

esac

# ===============================================================
#                      Install new software
# ===============================================================

task "Tapping homebrew/bundle... "
brew tap homebrew/bundle > /dev/null 2>&1 &
wait_last
success  "Tapping homebrew/bundle... done!"

task "Beginning Homebrew Bundle using ~/scripts/$PLATFORM/Brewfile ... (This may take awhile) "
brew bundle --file=$HOME/scripts/$PLATFORM/Brewfile > /dev/null 2>&1 &
wait_last
success "Beginning Homebrew Bundle using ~/scripts/$PLATFORM/Brewfile ... (This may take awhile)... done!"