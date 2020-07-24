#!/usr/bin/env bash

# ===============================================================
#         Install Homebrew/Linuxbrew if not already present
# ===============================================================

task "Checking for Homebrew... "

if [ $(command -v brew) ]; then
  skip "Checking for Homebrew... Homebrew found, skipping."
else
  task "Checking for Homebrew... Homebrew not found, installing... (This may take awhile)"
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
    ;;

    *)
      fail "Unable to install Homebrew for $PLATFORM, exiting... "
    ;;
  esac
fi

# ===============================================================
#            Ensure Homebrew is multi-user friendly
# ===============================================================
task "Checking Homebrew multi-user friendliness..."

case $PLATFORM in 
  Linux)
    skip "Checking Homebrew multi-user friendliness... Linuxbrew is friendly by default, skipping."
  ;;

  MacOS)
    task "Checking Homebrew multi-user friendliness... MacOS needs some tweaks, checking for them... "
    if [ dscl . read /Groups/brew | grep -q brew ]; then
      success "Checking Homebrew multi-user friendliness... MacOS needs some tweaks, checking for them... found group brew, done!"

      task "Ensuring current user is part of Homebrew group..."
      sudo dscl . append /Groups/brew GroupMembership $(whoami)
      success "Ensuring current user is part of Homebrew group... done!"

      if [ -d /usr/local/var/run/watchman ]; then
        task "Setting Watchman directory permissions..."
        sudo chmod 2777 /usr/local/var/run/watchman
        success "Setting Watchman directory permissions... done!"
      fi

      
    else
      task "Checking Homebrew multi-user friendliness... MacOS needs some tweaks, checking for them... Not found, creating... "
      sudo dscl . create /Groups/brew Homebrew "Users that can access Homebrew"
      sudo dscl . create /Groups/brew gid 405
      sudo dscl . create /Groups/brew GroupMembership $(whoami)
      success "Checking Homebrew multi-user friendliness... MacOS needs some tweaks, checking for them... Not found, creating... done!"

      task "Setting new group as owner of Homebrew files..."
      if [ -d /usr/local/Frameworks ]; then
        skip "Setting new group as owner of Homebrew files... found, skipping."
      else
        sudo mkdir /usr/local/Frameworks
      fi

      sudo chgrp -R brew $(brew --prefix)/*
      success "Setting new group as owner of Homebrew files... done!"

      task "Setting permissions for group on Homebrew files..."
      sudo chmod -R g+w $(brew --prefix)/*
      sudo chmod -R 775 /usr/local/Cellar/

      success "Setting permissions for group on Homebrew files... done!"
  
      info "To allow users to run brew commands, use 'sudo dscl . append /Groups/brew GroupMembership <username>' or just run the bootstrap.sh script again"
    fi
  ;;

  *)
    skip "Checking Homebrew multi-user friendliness... nothing to do, skipping."
    fail "Unable to install Homebrew for $PLATFORM, exiting... "
  ;;
esac

# ===============================================================
#              Ensure Homebrew is newest version
# ===============================================================

task "Updating Homebrew... (This may take awhile)"
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

task "Beginning Homebrew Bundle using ~/scripts/$PLATFORM/Brewfile... (This may take awhile) "
brew bundle --file=$HOME/scripts/$PLATFORM/Brewfile > /dev/null 2>&1 &
wait_last
success "Beginning Homebrew Bundle using ~/scripts/$PLATFORM/Brewfile... done!"