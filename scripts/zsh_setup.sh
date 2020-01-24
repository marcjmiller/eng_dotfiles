#!/usr/bin/env bash

printf "Checking for zsh... \n"
ZSH_LOC=$(which zsh)
if [[ ZSH_LOC == "zsh not found" ]]; then
    printf "ZSH not found, installing... \n"
    brew install zsh
else
    printf "ZSH found, skipping install. \n"
fi

printf "Checking for Oh-My-ZSH... \n"
if [[ ! -d '$HOME/.oh-my-zsh' ]]; then
    printf "Adding Oh My ZSH... \n"
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    printf "Oh-My-ZSH found, skipping install. \n"
fi

printf "Checking for Powerlevel10K... \n"
if [[ ! -d '$HOME/.oh-my-zsh/custom/themes/powerlevel10k' ]]; then
    printf "Adding Powerlevel10K... \n"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME/.oh-my-zsh/custom/themes/powerlevel10k
else
    printf "Powerlevel10K found, skipping install. \n"
fi