#!/usr/bin/env bash

# Close any System Preferences panes, to ensure settings stick
info "Closing any active System Preferences windows"
osascript -e 'tell application "System Preferences" to quit'

# Request Root privileges
task "Requesting root privileges"
sudo -v

# Keep root privileges while script runs
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
success "Requesting root privileges"

task "Disable menu bar transparency"
defaults write NSGlobalDomain AppleEnableMenuBarTransparency -bool false
success "Disable menu bar transparency"

task "Disable 'Are you sure you want to open this app?' dialogue"
defaults write com.apple.LaunchServices LSQuarantine -bool false
success "Disable 'Are you sure you want to open this app?' dialogue"

task "Disable resume (system-wide)"
defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false
success "Disable resume (system-wide)"

task "Disable smart quotes/dashes (they are annoying)"
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
success "Disable smart quotes/dashes (they are annoying)"

# task "Disable local Time Machine backups"
# sudo tmutil disablelocal
# success "done!"

# task "Remove sleep image file and block its replacement"
# sudo rm /private/var/vm/sleepimage
# sudo touch /private/var/vm/sleepimage
# sudo chflags uchg /private/var/vm/sleepimage
# success "done!"

task "Save to disk by default (vs iCloud)"
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false
success "Save to disk by default (vs iCloud)"

task "Disable press-and-hold for keys in favor of key repeat"
defaults write -g ApplePressAndHoldEnabled -bool false
success "Disable press-and-hold for keys in favor of key repeat"

task "Set a really fast key repeat"
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 10
success "Set a really fast key repeat"

task "Always open everything in Finder's list view"
defaults write com.apple.Finder FXPreferredViewStyle Nlsv
success "Always open everything in Finder's list view"

task "Show the Library and Volumes folders in Finder"
chflags nohidden ~/Library
sudo chflags nohidden /Volumes
success "Show the Library and Volumes folders in Finder"

task "Set the Finder prefs for showing removeable volumes on the Desktop"
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true
success "Set the Finder prefs for showing removeable volumes on the Desktop"

task "Set Finder to always show hidden files"
defaults write com.apple.Finder AppleShowAllFiles -bool true
success "Set Finder to always show hidden files"

task "Set Finder to show all file extensions"
defaults write com.apple.Finder AppleShowAllExtensions -bool true
success "Set Finder to show all file extensions"

task "Set Finder to show Path and Status bars"
defaults write com.apple.Finder ShowStatusBar -bool true
defaults write com.apple.Finder ShowPathBar -bool true
success "Set Finder to show Path and Status bars"

task "Set iterm to use profile"
open "${HOME}/.iterm/com.googlecode.iterm2.plist"
success "Set iterm to use profile"