To setup a new machine:
`git clone --separate-git-dir=$HOME/.dotfiles git@gitlab.devops.geointservices.io:dgs1sdt/engineer-dotfiles.git ~`

Source your shiny new .zshrc to pull in ZSH aliases/config/exports
`source $HOME/.zshrc`

Then set untracked files doesn't show the directory as 'dirty':
`dotfiles config --local status.showUntrackedFiles no`

May error due to default config file being created, in which case use the following 3 commands:
`git clone --separate-git-dir=$HOME/.dotfiles git@gitlab.devops.geointservices.io:dgs1sdt/engineer-dotfiles.git tmpdotfiles`
`rsync --recursive --verbose --exclude '.git' tmpdotfiles/ $HOME/`
`rm -r tmpdotfiles`