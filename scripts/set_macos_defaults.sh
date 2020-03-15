#!/usr/bin/env bash

task () {
  printf "\r  [ \033[00;34mTASK\033[0m ] $1\n"
}

success () {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

# Close any System Preferences panes, to ensure settings stick
task "Closing any active System Preferences windows"
osascript -e 'tell application "System Preferences" to quit'

# Request Root privileges
task "Requesting root privileges"
sudo -v

task "Disable press-and-hold for keys in favor of key repeat"
defaults write -g ApplePressAndHoldEnabled -bool false
success "done!"

task "Set a really fast key repeat"
defaults write NSGlobalDomain KeyRepeat -int 1
success "done!"

task "Always open everything in Finder's list view"
defaults write com.apple.Finder FXPreferredViewStyle Nlsv
success "done!"

task "Show the ~/Library folder in Finder"
chflags nohidden ~/Library
success "done!"

task "Set the Finder prefs for showing removeable volumes on the Desktop"
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true
success "done!"

