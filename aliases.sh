#=====
# Zsh config management
#=====

# edit zshrc
alias zshrc="$EDITOR ~/.zshrc"

# reload without entering a nested zsh
alias reload="exec zsh"

#=====
# Overrides to various existing commands
#=====

# convenient sudo with "S" + pass SSH variables through when using sudo
alias S='sudo'

# fix SSH when terminfo is missing
alias ssh='TERM=xterm-256color ssh'

# don't break compatibility with ls but make it colored
alias ls='ls --color=auto'

# good defaults for dd
alias dd='dd bs=4M status=progress'

#=====
# internet services
#=====

alias weather='curl wttr.in'
alias myip='curl icanhazip.com'
