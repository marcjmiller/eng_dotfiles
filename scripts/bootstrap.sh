#!/usr/bin/env bash

PLATFORM='unknown'

# Install Homebrew
echo "Determining OS..."
case $OSTYPE in
    darwin*) PLATFORM='MacOS';
    ;;
    linux*) PLATFORM='Linux';
    ;;
    msys*) PLATFORM='Windows';
    ;;
    *) echo "Unable to determine OS, exiting"
    ;;
esac
echo "Found $PLATFORM."


echo "Checking for Homebrew install..."
BREW_LOC=$(which brew)
if [[ $BREW_LOC == "brew not found" ]]; then
    echo "Starting Homebrew installation for $PLATFORM";
    if [[ $PLATFORM == "Linux" ]]; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)";
    elif [[ $PLATFORM == "MacOS" ]]; then
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)";
    else
        echo "Unable to install Homebrew, exiting...";
    fi
else 
    echo "Homebrew found at $BREW_LOC"
fi
