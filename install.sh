#!/bin/sh
datenow="$(date +'%Y-%m-%d_%H-%M-%S')"

if [ -n "$datenow" ]; then
  [ -f "$HOME/.zshrc" ] && cp "$HOME/.zshrc" "$HOME/.zshrc.backup.${datenow}" && echo "Backed up .zshrc to $HOME/.zshrc.backup.${datenow}"
  [ -f "$HOME/.aliases" ] && cp "$HOME/.aliases" "$HOME/.aliases.backup.${datenow}" && echo "Backed up .aliases to $HOME/.aliases.backup.${datenow}"
  [ -f "$HOME/.exports" ] && cp "$HOME/.exports" "$HOME/.exports.backup.${datenow}" && echo "Backed up .exports to $HOME/.exports.backup.${datenow}"
else
  echo "Couldn't properly name backups with their date! they will be like: $HOME/.zshrc-zsimplebkp"
  [ -f "$HOME/.zshrc" ] && cp "$HOME/.zshrc" "$HOME/.zshrc-zsimplebkp"
  [ -f "$HOME/.aliases" ] && cp "$HOME/.aliases" "$HOME/.aliases-zsimplebkp"
  [ -f "$HOME/.exports" ] && cp "$HOME/.exports" "$HOME/.exports-zsimplebkp"
fi

[ -f "zshrc.sh" ] && cp zshrc.sh "$HOME/.zshrc" && echo "Copied zshrc.sh to $HOME/.zshrc"
[ -f "aliases.sh" ] && cp aliases.sh "$HOME/.aliases" && echo "Copied aliases.sh to $HOME/.aliases"
[ -f "exports.sh" ] && cp exports.sh "$HOME/.exports" && echo "Copied exports.sh to $HOME/.exports"

# Only attempt to chmod files that actually exist
for f in "$HOME/.zshrc" "$HOME/.aliases" "$HOME/.exports"; do
  [ -f "$f" ] && chmod +x "$f"
done

if [ -n "$ZSIMPLE_INSTALL_THEME" ] ; then
  mkdir -p "$HOME/.config"
  
  [ -f "$HOME/.config/starship.toml" ] && \
    cp "$HOME/.config/starship.toml" "$HOME/.config/starship.toml.backup.${datenow}" && \
    echo "Backed up starship.toml to $HOME/.config/starship.toml.backup.${datenow}"
    
  [ -f ".veeship/starship.toml" ] && \
    cp ".veeship/starship.toml" "$HOME/.config/starship.toml" && \
    echo "Copied starship.toml to $HOME/.config/starship.toml"
fi
