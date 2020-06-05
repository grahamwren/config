# Run before other config files

# oh-my-zsh setup
# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="robbyrussell"

COMPLETION_WAITING_DOTS="true"
HIST_STAMPS="yyy-mm-dd"

plugins=(git colored-man-pages zsh-autosuggestions)
source $ZSH/oh-my-zsh.sh

# gpg key setup
# export SSL_CERT_FILE=/etc/ssl/cert.pem
export GPG_TTY=$(tty)
