#!/usr/bin/env bash

# ===============================================================
#                       Install ZSH
# ===============================================================
info "Checking for ZSH... "
if [ $(command -v zsh) ]; then
  info "Found ZSH, skipping. "
else
  info "ZSH not found, installing... "
  install_pkg zsh 
  success "done!"
fi

# ===============================================================
#                    Install Oh-My-Zsh
# ===============================================================
info "Checking for Oh-My-ZSH... "
if [[ -d $HOME/.oh-my-zsh ]]; then
  info "Found Oh-My-ZSH, skipping. "

else
  info "$HOME/.oh-my-zsh Not found, installing... "
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended 
  success "done!"

  info "Overwriting default Oh-My-ZSH template .zshrc with ours... "
  mv $HOME/.zshrc.pre-oh-my-zsh $HOME/.zshrc
  success "done!"
fi

# ===============================================================
#                 Install PowerLevel10K
# ===============================================================
info "Checking for Powerlevel10K... "
if [[ -d $ZSH_CUSTOM/themes/powerlevel10k ]]; then
  info "Found Powerlevel10K, skipping. "

else
  info "Not found, installing... "
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME/.oh-my-zsh/custom/themes/powerlevel10k
  success "done!"
fi

# ===============================================================
#                 Install ZSH-AutoSuggestions
# ===============================================================
info "Checking for ZSH-Autosuggestions... "
if [[ -d $ZSH_CUSTOM/plugins/zsh-autosuggestions ]]; then
  info "Found ZSH-Autosuggestions, skipping. "

else
  info "Not found, installing... "
  git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
  success "done!"
fi
# ===============================================================
#                 Reload ZSH configuration
# ===============================================================
info "Loading new config w/ ZSH, Oh-My-ZSH, and Powerlevel10K.  Hold on to your butts..."
source ~/.zshrc
success "done!"
