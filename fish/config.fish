set -gx SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
set -gx GPG_TTY (tty)
gpg-connect-agent updatestartuptty /bye &> /dev/null
# eval (direnv hook fish)
# kitty + complete setup fish | source
