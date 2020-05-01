#!/usr/bin/env bash

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

      task "Creating brew group to make homebrew multi-user..."
      sudo dscl . create /Groups/brew Homebrew "Users that can access Homebrew"
      sudo dscl . create /Groups/brew gid 405
      sudo dscl . create /Groups/brew GroupMembership $(whoami)

      task "Creating brew group to make homebrew multi-user... changing brew ownership/permissions... "
      sudo chgrp -R brew $(brew --prefix)/*
      sudo chmod -R g+w brew $(brew --prefix)/*
      sudo mkdir /usr/local/Frameworks
      sudo chgrp -R brew /usr/local/Frameworks
      sudo chmod -R g+w /usr/local/Frameworks

      success "Creating brew group to make homebrew multi-user... changing brew ownership/permissions... done!"
      info "To allow users to run brew commands, use 'sudo dscl . append /Groups/brew GroupMembership <username>'"
    ;;

    *)
      fail "Unable to install Homebrew for $PLATFORM, exiting... "
    ;;
  esac
fi

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