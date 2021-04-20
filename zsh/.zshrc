PROMPT="%% "
RPROMPT="= %?"

# simple example from Arch wiki:
autoload -Uz compinit promptinit
compinit
promptinit

# history
# https://unix.stackexchange.com/questions/48305
setopt histignorespace
setopt histignorealldups
setopt histreduceblanks

# add the local fpath (e.g., for autocompletion)
fpath=($ZDOTDIR/fpath $fpath)

# keybindings for vi mode of ZLE
bindkey -v

# keybindings for delete, home, end, etc.
#autoload zkbd
#[[ ! -f ${ZDOTDIR:-$HOME}/.zkbd/$TERM-$VENDOR-$OSTYPE ]] && zkbd
#source ${ZDOTDIR:-$HOME}/.zkbd/$TERM-$VENDOR-$OSTYPE
#
# Zsh wiki suggest using terminfo solution for special keys
# http://zshwiki.org/home/zle/bindkeys
typeset -A key

key[Home]="$terminfo[khome]"
key[End]="$terminfo[kend]"
key[Insert]="$terminfo[kich1]"
key[Backspace]="$terminfo[kbs]"
key[Delete]="$terminfo[kdch1]"
key[Up]="$terminfo[kcuu1]"
key[Down]="$terminfo[kcud1]"
key[Left]="$terminfo[kcub1]"
key[Right]="$terminfo[kcuf1]"
key[PageUp]="$terminfo[kpp]"
key[PageDown]="$terminfo[knp]"

[[ -n ${key[Up]} ]] && bindkey "${key[Up]}" up-line-or-search
[[ -n ${key[Left]} ]] && bindkey "${key[Left]}" backward-char
[[ -n ${key[Down]} ]] && bindkey "${key[Down]}" down-line-or-search
[[ -n ${key[Right]} ]] && bindkey "${key[Right]}" forward-char
[[ -n ${key[PageUp]} ]] && bindkey "${key[PageUp]}" up-line-or-history
[[ -n ${key[PageDown]} ]] && bindkey "${key[PageDown]}" down-line-or-history
[[ -n ${key[Home]} ]] && bindkey "${key[Home]}" beginning-of-line
[[ -n ${key[End]} ]] && bindkey "${key[End]}" end-of-line
[[ -n ${key[Insert]} ]] && bindkey "${key[Insert]}" overwrite-mode
[[ -n ${key[Delete]} ]] && bindkey "${key[Delete]}" delete-char
[[ -n ${key[Backspace]} ]] && bindkey "${key[Backspace]}" backward-delete-char

# may want this to use alt & meta with CODE TKL and xterm-termite:
# unsetopt MULTIBYTE

# since I'm using /etc/hosts to block ads & malware...
zstyle ':completion:*' hosts off

# update the tty for the GPG agent
gpg-connect-agent updatestartuptty /bye &> /dev/null

# hook direnv
# eval "$(direnv hook zsh)"

# adjust path in zshenv
