#!/usr/bin/env bash

# Close any System Preferences panes, to ensure settings stick
info "Closing any active System Preferences windows"
osascript -e 'tell application "System Preferences" to quit'


task "Disable menu bar transparency..."
defaults write NSGlobalDomain AppleEnableMenuBarTransparency -bool false
success "Disable menu bar transparency... done!"

task "Disable 'Are you sure you want to open this app?' dialogue..."
defaults write com.apple.LaunchServices LSQuarantine -bool false
success "Disable 'Are you sure you want to open this app?' dialogue... done!"

task "Disable resume (system-wide)..."
defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false
success "Disable resume (system-wide)... done!"

task "Disable smart quotes/dashes (they are annoying)..."
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
success "Disable smart quotes/dashes (they are annoying)... done!"

task "Save to disk by default (vs iCloud)..."
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false
success "Save to disk by default (vs iCloud)... done!"

task "Disable press-and-hold for keys in favor of key repeat..."
defaults write -g ApplePressAndHoldEnabled -bool false
success "Disable press-and-hold for keys in favor of key repeat... done!"

task "Set a really fast key repeat..."
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 10
success "Set a really fast key repeat... done!"

task "Always open everything in Finder's list view..."
defaults write com.apple.Finder FXPreferredViewStyle Nlsv
success "Always open everything in Finder's list view... done!"

task "Show the Library and Volumes folders in Finder..."
chflags nohidden ~/Library
sudo chflags nohidden /Volumes
success "Show the Library and Volumes folders in Finder... done!"

task "Set the Finder prefs for showing removeable volumes on the Desktop..."
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true
success "Set the Finder prefs for showing removeable volumes on the Desktop... done!"

task "Set Finder to always show hidden files..."
defaults write com.apple.Finder AppleShowAllFiles -bool true
success "Set Finder to always show hidden files... done!"

task "Set Finder to show all file extensions..."
defaults write com.apple.Finder AppleShowAllExtensions -bool true
success "Set Finder to show all file extensions... done!"

task "Set Finder to show Path and Status bars..."
defaults write com.apple.Finder ShowStatusBar -bool true
defaults write com.apple.Finder ShowPathBar -bool true
success "Set Finder to show Path and Status bars... done!"

task "Set Dock show recent items to false..."
defaults write com.apple.dock show-recents -bool FALSE
success "Set Dock show recent items to false... done!"

task "Clean up MacOS dock items..."
dockutil --no-restart --remove all

task "Clean up MacOS dock items... cleaned! Adding items... "
dockutil --no-restart --add "/Applications/Google Chrome.app"
dockutil --no-restart --add "/Applications/Firefox.app"
dockutil --no-restart --add "/Applications/iTerm.app"
dockutil --no-restart --add "/Applications/VSCodium.app"
dockutil --no-restart --add "/Applications/IntelliJ IDEA.app"
dockutil --no-restart --add "/Applications/kitty.app"
dockutil --no-restart --add "/Applications/Slack.app"
task "Clean up MacOS dock items... cleaned! Adding items... restarting dock..."

killall Dock
success "Clean up MacOS dock items... cleaned! Adding items... restarting dock... done!"
