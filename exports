# Use terminal for GPG
export GPG_TTY=$(tty)

# Export homebrew prefix for MacOS
export HOMEBREW_PREFIX="/opt/homebrew/"

# Set text editor to vim if installed
command -v vim 2>&1 >/dev/null && export {EDITOR,VISUAL}='vim'

# Force less instead of more if installed
command -v less 2>&1 >/dev/null && export PAGER=less

# Add common directories to path
export PATH="/home/$USER/bin:/home/$USER/bin/*/:/home/$USER/.local/bin:$PATH"
