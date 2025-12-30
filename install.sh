#!/bin/sh
datenow="$(date +'%Y-%m-%d_%H-%M-%S')"
if [ ! -z "$datenow" ]; then
  cp "$HOME/.zshrc" "$HOME/.zshrc.backup.${datenow}" && echo "Backed up .zshrc to $HOME/.zshrc.backup.${datenow}"
  cp "$HOME/.aliases" "$HOME/.aliases.backup.${datenow}" && echo "Backed up .aliases to $HOME/.aliases.backup.${datenow}"
  cp "$HOME/.exports" "$HOME/.exports.backup.${datenow}" && echo "Backed up .exports to $HOME/.exports.backup.${datenow}"
else
echo "Couldn't properly name backups with their date! they will be like: $HOME/.zshrc-zsimplebkp"
  cp "$HOME/.zshrc" "$HOME/.zshrc-zsimplebkp"
  cp "$HOME/.aliases" "$HOME/.aliases-zsimplebkp"
  cp "$HOME/.exports" "/.exports-zsimplebkp"
fi

cp zshrc.sh "$HOME/.zshrc" && echo "Copied zshrc.sh to $HOME/.zshrc"
cp aliases.sh "$HOME/.aliases" && echo "Copied aliases.sh to $HOME/.aliases"
cp exports.sh "$HOME/.exports" && echo "Copied exports.sh to $HOME/.exports"
chmod +x "$HOME/.zshrc" "$HOME/.aliases" "$HOME/.exports"

if [ "$ZSIMPLE_INSTALL_THEME" -eq 1 ] ; then
  mkdir -p "$HOME/.config" && \
  cp "$HOME/.config/starship.toml" "$HOME/.config/starship.toml.backup.${datenow}" && \
  echo "Backed up starship.toml to $HOME/.config/starship.toml.backup.${datenow}" && \
  cp ".veeship/starship.toml" "$HOME/.config/starship.toml" && \
  echo "Copied starship.toml to $HOME/.config/starship.toml"
fi
