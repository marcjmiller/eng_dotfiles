#!/usr/bin/env bash

# ===============================================================
#                       Install ZSH
# ===============================================================
task "Checking for ZSH... "
if [ $(command -v zsh) ]; then
  skip "Checking for ZSH... Found ZSH, skipping. "

else
  task "Checking for ZSH... ZSH not found, installing... "
  install_pkg zsh 
  success  "Checking for ZSH... ZSH not found, installing... done!"
fi

# ===============================================================
#                    Install Oh-My-Zsh
# ===============================================================
task "Checking for Oh-My-ZSH... "
if [[ -d $HOME/.oh-my-zsh ]]; then
  skip "Checking for Oh-My-ZSH... Found Oh-My-ZSH, skipping. "

else
  task "Checking for Oh-My-ZSH... $HOME/.oh-my-zsh Not found, installing... "
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended > /dev/null 2>&1 &
  wait_last
  success "Checking for Oh-My-ZSH... $HOME/.oh-my-zsh Not found, installing... done!"

  task "Overwriting default Oh-My-ZSH template .zshrc with ours... "
  mv $HOME/.zshrc.pre-oh-my-zsh $HOME/.zshrc
  success  "Overwriting default Oh-My-ZSH template .zshrc with ours... done!"
fi

# ===============================================================
#                 Install PowerLevel10K
# ===============================================================
task "Checking for Powerlevel10K... "
if [[ -d $HOME/.oh-my-zsh/custom/themes/powerlevel10k ]]; then
  skip "Checking for Powerlevel10K... Found Powerlevel10K, skipping. "

else
  task "Checking for Powerlevel10K... Powerlevel10K not found, installing... "
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME/.oh-my-zsh/custom/themes/powerlevel10k > /dev/null 2>&1 &
  wait_last
  success "Checking for Powerlevel10K... Powerlevel10K not found, installing... done!"
fi

# ===============================================================
#                 Install ZSH-AutoSuggestions
# ===============================================================
task "Checking for ZSH-Autosuggestions... "
if [[ -d $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions ]]; then
  skip "Checking for ZSH-Autosuggestions... Found ZSH-Autosuggestions, skipping. "

else
  task "Checking for ZSH-Autosuggestions... ZSH-Autosuggestions not found, installing... "
  git clone https://github.com/zsh-users/zsh-autosuggestions $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions > /dev/null 2>&1 &
  wait_last
  success "Checking for ZSH-Autosuggestions... ZSH-Autosuggestions not found, installing... done!"
fi

# ===============================================================
#                 Reload ZSH configuration
# ===============================================================

info "New config with Oh-My-ZSH and Powerlevel10K setup, will load on next start of terminal"
# source ~/.zshrc