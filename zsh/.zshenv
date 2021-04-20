
# XDG standards clean up dotfiles a bit
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"

export GNUPGHOME="$XDG_CONFIG_HOME/gnupg"
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
export GPG_TTY=$(tty)

export LCM_DEFAULT_URL=udpm://239.255.76.67:7667?ttl=1

export EDITOR=nvim
export VISUAL=nvim

typeset -U path
path=(~/bin ~/.local/bin /$path[@])

export PASSWORD_STORE_DIR="$XDG_CONFIG_HOME/pass"
export PASSWORD_STORE_CHARACTER_SET="[:alnum:] %&_?#=-"

alias mbsync='mbsync -c "$XDG_CONFIG_HOME"/isync/mbsyncrc'

