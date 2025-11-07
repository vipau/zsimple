# zsimple
# github.com/vipau/zsimple

# Disable shellcheck checks meant for bash
# shellcheck disable=SC2034 # SAVEHIST,HISTDUP,WORDCHARS are only for zsh
# shellcheck disable=SC1090 # "source first readable file from list" is not possible without non-constant source

#=====
# Shell settings
#=====

# emacs mode (should already be the default)
bindkey -e

# Misc settings (check 'man zfsoptions')
setopt correct autocd appendhistory sharehistory histignorespace histignoredups
unsetopt beep extendedglob

# History settings (check 'man zfsoptions')
HISTSIZE=1000
SAVEHIST=1000
HISTFILE="$HOME/.histfile"
HISTDUP=erase
set +H # turn off history expansion (more secure)

# Reduce zsh wait for esc key to remove delay in editors
export KEYTIMEOUT=1

#=====
# Load exports (we do this first as they contain important variables)
#=====

[ -f "$HOME/.exports" ] && source "$HOME/.exports"

#=====
# plugin/bootstrap (no manager; package-first, git fallback)
#=====

# Where to place lightweight clones if distro packages are missing
: "${ZSH_PLUGIN_DIR:=$HOME/.zsh/plugins}"
mkdir -p "$ZSH_PLUGIN_DIR" "$HOME/.cache/zsh"

# If homebrew root is not defined in ~/.exports , initialize it
: "${HOMEBREW_PREFIX:=/opt/homebrew}"

# Helper: source the first readable file from a list
_source_first() {
  for f in "$@"; do
    [ -r "$f" ] && . "$f" && return 0
  done
  return 1
}

# Check if git is installed
if command -v git >/dev/null 2>&1; then
  GIT_AVAILABLE=1
else
  GIT_AVAILABLE=0
  if [ -z "$ZSIMPLE_DISABLE_GIT" ]; then
    echo "git not installed. You can disable this warning by running:"
    echo "echo 'export ZSIMPLE_DISABLE_GIT=1' >> ~/.exports"
  fi
fi

# Helper: clone a GitHub repo (shallow) to $ZSH_PLUGIN_DIR if not present
_clone_if_needed() {
  # $1 = github org/repo ; $2 = local dir name (optional)
  local repo="$1"
  local name="${2:-${repo##*/}}"
  local target="$ZSH_PLUGIN_DIR/$name"
  if [ "$GIT_AVAILABLE" -eq 1 ] && [ -z "$ZSIMPLE_DISABLE_GIT" ] && [ ! -d "$target/.git" ]; then
    git clone --depth=1 "https://github.com/$repo" "$target" >/dev/null 2>&1  || { echo "git clone failed: $repo" >&2; return 1; }
    # normal output needs to go to stderr or the function will not print the path correctly
  fi
  printf '%s' "$target"
}

# --- zsh-completions ---
# Prefer distro/homebrew paths; else shallow-clone.
if ! _source_first \
  /usr/share/zsh/plugins/zsh-completions/zsh-completions.plugin.zsh \
  /usr/share/zsh-completions/zsh-completions.plugin.zsh \
  ${HOMEBREW_PREFIX}/share/zsh-completions/zsh-completions.plugin.zsh \
  /usr/local/share/zsh-completions/zsh-completions.plugin.zsh
then
  [ -z "$ZSIMPLE_DISABLE_GIT" ] && _source_first "$(_clone_if_needed zsh-users/zsh-completions)"/*.zsh >/dev/null 2>&1
fi

# --- zsh-autosuggestions ---
if ! _source_first \
  /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh \
  /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh \
  ${HOMEBREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh \
  /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
then
  [ -z "$ZSIMPLE_DISABLE_GIT" ] && _source_first "$(_clone_if_needed zsh-users/zsh-autosuggestions)"/*.zsh >/dev/null 2>&1
fi

# --- zsh-syntax-highlighting --- (must be last)
if ! _source_first \
  /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
  ${HOMEBREW_PREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
  /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
then
  [ -z "$ZSIMPLE_DISABLE_GIT" ] && _source_first "$(_clone_if_needed zsh-users/zsh-syntax-highlighting)"/*.zsh >/dev/null 2>&1
fi

# Tweak behaviour for speed
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# Set color for the autosuggestion hint (change this if your commands aren't autocompleted from history)
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=3'

# Cross-platform word jumps (Linux, macOS, most terminals)
bindkey '^[f' forward-word          # Alt/Meta+f
bindkey '^[b' backward-word         # Alt/Meta+b
bindkey '^[[1;3C' forward-word      # Alt+Right (xterm/gnome-terminal/iTerm2)
bindkey '^[[1;3D' backward-word     # Alt+Left  (xterm/gnome-terminal/iTerm2)
bindkey '^[^[[C' forward-word 2>/dev/null || true  # some terminals send ESC then Right
bindkey '^[^[[D' backward-word 2>/dev/null || true

# stop word-jumps at / and .
WORDCHARS='*?_-[]~=&;!#$%^(){}<>'

# Up/Down that move to end of line after history search
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search

zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search

# get nice completion menu
zstyle ':completion:*' menu select

# lowercase also completes uppercase commands
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# shift tab goes backward in completion
bindkey '^[[Z' reverse-menu-complete 

# fix del button
bindkey "\e[3~" delete-char

# expand history commands after pressing space (example: !1 )
bindkey ' ' magic-space

# complete from middle of word
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

#=====
## Autocompletion (goes at the end, before prompt)
#=====

# Optional bash-style completions (enable only if you need them)
if [ -d /etc/bash_completion.d ] || [ -f /etc/bash_completion ] || [ -d ${HOMEBREW_PREFIX}/etc/bash_completion.d ]; then
  autoload -U +X bashcompinit && bashcompinit
fi

autoload -Uz compinit
# Faster, safer compinit with versioned dump
_compdump="$HOME/.cache/zsh/.zcompdump-$HOST-${ZSH_VERSION%%-*}"
if [ ! -e "$_compdump" ]; then
  compinit -i -d "$_compdump"
else
  compinit -C -i -d "$_compdump"
fi

#=====
# Load aliases (at the end, so they override)
#=====

[ -f "$HOME/.aliases" ] && source "$HOME/.aliases"

#=====
# Start starship if available
#=====

command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"
