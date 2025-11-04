# Use terminal for GPG
export GPG_TTY=$(tty)

# Export homebrew prefix for MacOS
export HOMEBREW_PREFIX="/opt/homebrew/"

# Set text editor to vim if installed
command -v vim >/dev/null 2>&1  && export {EDITOR,VISUAL}='vim'

# Force less instead of more if installed
command -v less >/dev/null 2>&1 && export PAGER=less

# Add common directories to path
export PATH="$HOME/bin:$HOME/bin/*/:$HOME/.local/bin:$PATH"
