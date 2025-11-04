# zsimple
Simple, modern, fast zsh environment.

## Features
- Modern feel with quality of life features while keeping things simple and fast
- Works on Linux, MacOS and some Windows environments
- No plugin manager (tries system paths first, otherwise asks if to git clone)
- Only 3 (very audited) plugins: zsh-autosuggestions, zsh-autosuggestions, zsh-syntax-highlighting

## Install

This will backup any existing files called `.zshrc`, `.exports` and `.aliases`.  
Please also always keep your own backups of dotfiles.

```bash
git clone https://github.com/vipau/zsimple.git
cd zsimple
sh install.sh
```

Make sure to review the contents of ~/.aliases and ~/.exports afterwards, and customize to your liking.  
