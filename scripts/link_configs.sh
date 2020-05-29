# VSCodium
# $HOME/configs/vscodium/settings.json ->
#   MacOS: $HOME/Library/Application Support/VSCodium/User/settings.json 
#   Linux: $HOME/.config/VSCodium/User/settings.json
#   Windows: %APPDATA%\VSCodium\User\settings.json

if [ $PLATFORM == "MacOS" ]; then
  ln -s $HOME/configs/vscodium/settings.json $HOME/Library/Application\ Support/VSCodium/User/settings.json
elif [ $PLATFORM == "Linux" ]; then
  ln -s $HOME/configs/vscodium/settings.json $HOME/.config/VSCodium/User/settings.json
fi