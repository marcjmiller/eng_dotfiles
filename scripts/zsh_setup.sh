#!/usr/bin/env bash

printf "Checking for zsh... "
ZSH_LOC=$(which zsh)
if [[ ZSH_LOC == "zsh not found" ]]; then
    printf "ZSH not found, installing... "
    brew install zsh &
    wait
    printf "done! \n"
else
    printf "$ZSH_LOC found, skipping install. \n"
fi

printf "Checking for Oh-My-ZSH... "
if [[ ! -d '$HOME/.oh-my-zsh' ]]; then
    printf "Adding Oh My ZSH... "
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" > $HOME/dotfiles.log &
    wait
    printf "done! \n"
    printf "Replacing default Oh-My-ZSH template .zshrc with ours ..."

else
    printf "Oh-My-ZSH found, skipping install. \n"
fi

printf "Checking for Powerlevel10K... "
if [[ ! -d '$HOME/.oh-my-zsh/custom/themes/powerlevel10k' ]]; then
    printf "Adding Powerlevel10K... "
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME/.oh-my-zsh/custom/themes/powerlevel10k > $HOME/dotfiles.log &
    wait
    printf "done! \n"
else
    printf "Powerlevel10K found, skipping install. \n"
fi