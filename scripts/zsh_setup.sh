#!/usr/bin/env bash

info "Checking for ZSH... "
if [[ $(which zsh) == "zsh not found" ]]; then
    info "ZSH not found, installing... "
    brew install zsh &> /dev/null
    wait
    success "done!"

else
    info "Found ZSH, skipping. \n"
fi

info "Checking for Oh-My-ZSH... "
if [[ -d $HOME/.oh-my-zsh ]]; then
    info "Found Oh-My-ZSH, skipping. \n"

else
    info "$HOME/.oh-my-zsh Not found, installing... "
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" &> /dev/null
    wait
    success "done!"
    info "Replacing default Oh-My-ZSH template .zshrc with ours... "
    mv $HOME/.zshrc.pre-oh-my-zsh $HOME/.zshrc &> /dev/null
    success "done!"    
fi

info "Checking for Powerlevel10K... "
if [[ -d $HOME/.oh-my-zsh/custom/themes/powerlevel10k ]]; then
    info "Found Powerlevel10K, skipping. \n"

else
    info "Not found, installing... "
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME/.oh-my-zsh/custom/themes/powerlevel10k &> /dev/null
    wait
    success "done!"
fi

info "Loading new config w/ ZSH, Oh-My-ZSH, and Powerlevel10K... "
source ~/.zshrc
success "done!"
