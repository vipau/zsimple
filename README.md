# zsimple
Simple, modern, fast zsh environment with no hard dependencies.

## Optional dependencies
- git, for downloading the plugins if not installed via a package manager. If neither plugins nor git are found, they will not be used with a warning that can be disabled.
- starship, for having a nice customizable and powerful prompt. Check out [my configuration here](https://vipau.dev/posts/my-shell-prompt/)
- (temporarily disabled) ssh-agent: will be used if found

## Features
- Modern feel with quality of life features while keeping things simple and fast
- Works on Linux, MacOS and some Windows environments
- No plugin manager (tries system paths first, otherwise asks if to git clone)
- Only 3 (very audited) plugins: zsh-autosuggestions, zsh-completions, zsh-syntax-highlighting

## Test in docker 

Note: The prompt will look more minimal than a regular setup due to busybox and extremely minimal setup

```bash
git clone https://github.com/vipau/zsimple.git
cd zsimple
docker build -t zsimple:latest .
docker run -it zsimple:latest
```

## Install

This will backup any existing files called `.zshrc`, `.exports` and `.aliases`.  
Please also always keep your own backups of dotfiles.

```bash
git clone https://github.com/vipau/zsimple.git
cd zsimple

# Also copy my starship theme (does not install starship itself)
ZSIMPLE_INSTALL_THEME=1 sh install.sh
# if you don't want starship or have your own config:
# sh install.sh

zsh
```

Make sure to review the contents of ~/.aliases and ~/.exports afterwards, and customize to your liking.  
