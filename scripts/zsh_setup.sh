#!/usr/bin/env bash

# ===============================================================
#                       Install ZSH
# ===============================================================
info "Checking for ZSH... "
if [ $(command -v zsh) ]; then
  info "Found ZSH, skipping. "

else
  task "ZSH not found, installing... "
  install_pkg zsh 
  success  "ZSH not found, installing... "
fi

# ===============================================================
#                    Install Oh-My-Zsh
# ===============================================================
info "Checking for Oh-My-ZSH... "
if [[ -d $HOME/.oh-my-zsh ]]; then
  info "Found Oh-My-ZSH, skipping. "

else
  task "$HOME/.oh-my-zsh Not found, installing... "
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended > /dev/null 2>&1 &
  wait_last
  success "$HOME/.oh-my-zsh Not found, installing... "

  task "Overwriting default Oh-My-ZSH template .zshrc with ours... "
  mv $HOME/.zshrc.pre-oh-my-zsh $HOME/.zshrc
  success  "Overwriting default Oh-My-ZSH template .zshrc with ours... "
fi

# ===============================================================
#                 Install PowerLevel10K
# ===============================================================
info "Checking for Powerlevel10K... "
if [ -d $ZSH_CUSTOM/themes/powerlevel10k ]; then
  info "Found Powerlevel10K, skipping. "

else
  task "Powerlevel10K not found, installing... "
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME/.oh-my-zsh/custom/themes/powerlevel10k > /dev/null 2>&1 &
  wait_last
  success  "Powerlevel10K not found, installing... "
fi

# ===============================================================
#                 Install ZSH-AutoSuggestions
# ===============================================================
info "Checking for ZSH-Autosuggestions... "
if [ -d $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions ]; then
  info "Found ZSH-Autosuggestions, skipping. "

else
  task "ZSH-Autosuggestions not found, installing... "
  git clone https://github.com/zsh-users/zsh-autosuggestions $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions > /dev/null 2>&1 &
  wait_last
  success "ZSH-Autosuggestions not found, installing... "
fi

# ===============================================================
#                 Reload ZSH configuration
# ===============================================================

info "New config with Oh-My-ZSH and Powerlevel10K setup, will load on next start of terminal"
# source ~/.zshrc
# success "done!"