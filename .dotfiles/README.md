To setup a new machine:
`git clone --separate-git-dir=$HOME/.dotfiles git@gitlab.devops.geointservices.io:dgs1sdt/engineer-dotfiles.git tmpdotfiles`
`rsync --recursive --verbose --exclude '.git' tmpdotfiles/ $HOME/`
`rm -r tmpdotfiles`  

Then set untracked files doesn't show the directory as 'dirty':
`dotfiles config --local status.showUntrackedFiles no`  

Source ~/scripts/bootstrap.sh to setup:  
`source $HOME/scripts/bootstrap.sh`