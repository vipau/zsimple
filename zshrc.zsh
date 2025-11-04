# zsimple
# github.com/vipau/zsimple

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
HISTFILE=~/.histfile
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
  if [ -z "$DISABLE_GIT_WARNING" ]; then
    echo "git not installed. You can disable this warning by running:"
    echo "echo 'export DISABLE_GIT_WARNING=1' >> ~/.exports"
  fi
fi

# Helper: clone a GitHub repo (shallow) to $ZSH_PLUGIN_DIR if not present
_clone_if_needed() {
  # $1 = github org/repo ; $2 = local dir name (optional)
  local repo="$1"
  local name="${2:-${repo##*/}}"
  local target="$ZSH_PLUGIN_DIR/$name"
  if [ "$GIT_AVAILABLE" -eq 1 ] && [ ! -d "$target/.git" ]; then
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
  /opt/homebrew/share/zsh-completions/zsh-completions.plugin.zsh \
  /usr/local/share/zsh-completions/zsh-completions.plugin.zsh
then
  _source_first "$(_clone_if_needed zsh-users/zsh-completions)"/*.zsh >/dev/null 2>&1
fi

# --- zsh-autosuggestions ---
if ! _source_first \
  /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh \
  /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh \
  /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh \
  /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
then
  _source_first "$(_clone_if_needed zsh-users/zsh-autosuggestions)"/*.zsh >/dev/null 2>&1
fi

# --- zsh-syntax-highlighting --- (must be last)
if ! _source_first \
  /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
  /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
  /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
then
  _source_first "$(_clone_if_needed zsh-users/zsh-syntax-highlighting)"/*.zsh >/dev/null 2>&1
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
if [ -d /etc/bash_completion.d ] || [ -f /etc/bash_completion ] || [ -d /opt/homebrew/etc/bash_completion.d ]; then
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

###
# Load aliases (at the end, so they override)
###
[ -f "$HOME/.aliases" ] && source "$HOME/.aliases"

###
# Reuse existing SSH agent or start a new one
###
if command -v ssh-agent >/dev/null 2>&1 ; then
  # set SSH_AUTH_SOCK env var to a fixed value
  export SSH_AUTH_SOCK=~/.ssh/ssh-agent.sock

  # test whether $SSH_AUTH_SOCK is valid
  ssh-add -l 2>/dev/null >/dev/null

  # if not valid, then start ssh-agent using $SSH_AUTH_SOCK
  [ $? -ge 2 ] && ssh-agent -a "$SSH_AUTH_SOCK" >/dev/null
fi
#=====
# Start starship if available
#=====

command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"
