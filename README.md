# zsimple
Simple, modern, fast zsh environment with no hard dependencies.

## Requirements
- zsh (recommended to use a recent version)

## Optional recommended dependencies
- `git`, for downloading the plugins if not installed via a package manager. If neither plugins nor git are found, they will not be used, and a warning will be shown (can be disabled).
- [starship](https://starship.rs/), for having a nice customizable and powerful prompt. Check out my lightweight configuration: [Blog](https://vipau.dev/posts/my-shell-prompt/) | [GitHub](https://github.com/vipau/veeship)

## Features
- Modern feel with quality of life features while keeping things simple and fast
- Works on Linux, MacOS and some Windows environments
- No plugin manager (tries system paths first, otherwise asks if to git clone)
- Only 3 (very audited) plugins: zsh-autosuggestions, zsh-completions, zsh-syntax-highlighting

## Test in docker 

Slim Debian image including starship and my lightweight config

```bash
docker run --rm -it ghcr.io/vipau/zsimple:debian-latest
```

Extremely minimal Void Linux image without starship

```bash
docker run --rm -it ghcr.io/vipau/zsimple:void-latest
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

## Todo
- (temporarily disabled) ssh-agent: reuse existing agent if found running
