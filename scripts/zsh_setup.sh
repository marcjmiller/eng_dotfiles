#!/usr/bin/env bash

printf "Checking for ZSH... "
if [[ $(which zsh) == "zsh not found" ]]; then
    printf "ZSH not found, installing... "
    brew install zsh &> /dev/null
    wait
    printf "done! \n"

else
    printf "Found ZSH, skipping. \n"
fi

printf "Checking for Oh-My-ZSH... "
if [[ -d $HOME/.oh-my-zsh ]]; then
    printf "Found Oh-My-ZSH, skipping. \n"

else
    printf "$HOME/.oh-my-zsh Not found, installing... "
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" &> /dev/null
    wait
    printf "done! \n"
    printf "Replacing default Oh-My-ZSH template .zshrc with ours... "
    mv $HOME/.zshrc.pre-oh-my-zsh $HOME/.zshrc &> /dev/null
    printf "done! \n"    
fi

printf "Checking for Powerlevel10K... "
if [[ -d $HOME/.oh-my-zsh/custom/themes/powerlevel10k ]]; then
    printf "Found Powerlevel10K, skipping. \n"

else
    printf "Not found, installing... "
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME/.oh-my-zsh/custom/themes/powerlevel10k &> /dev/null
    wait
    printf "done! \n"
fi

printf "Loading new config w/ ZSH, Oh-My-ZSH, and Powerlevel10K... "
reload
printf "done! \n"