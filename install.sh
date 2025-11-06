#!/bin/sh
datenow="$(date +'%Y-%m-%d_%H-%M-%S')"
if [ ! -z "$datenow" ]; then
  cp "$HOME/.zshrc" "$HOME/.zshrc.backup.${datenow}"
  cp "$HOME/.aliases" "$HOME/.aliases.backup.${datenow}"
  cp "$HOME/.exports" "$HOME/.exports.backup.${datenow}"
else
echo "Couldn't properly name backups with their date! they will be like: $HOME/.zshrc-zsimplebkp"
  cp "$HOME/.zshrc" "$HOME/.zshrc-zsimplebkp"
  cp "$HOME/.aliases" "$HOME/.aliases-zsimplebkp"
  cp "$HOME/.exports" "/.exports-zsimplebkp"
fi

cp zshrc.sh "$HOME/.zshrc"
cp aliases.sh "$HOME/.aliases"
cp exports.sh "$HOME/.exports"
chmod +x "$HOME/.zshrc" "$HOME/.aliases" "$HOME/.exports"

[ "$ZSIMPLE_INSTALL_THEME" -eq 1 ] && mkdir -p "$HOME/.config" && cp starship.toml "$HOME/.config/starship.toml"
