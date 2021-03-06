# Run before other config files

# ZSH configuration
export OPENSSL_CONF=~/Applications/openssl/apps/openssl.cnf
export OPENSSLDIR=~/Applications/openssl
export PATH=~/bin:/usr/local/sbin:$PATH

# oh-my-zsh setup
# Path to your oh-my-zsh installation.
export ZSH=/Users/paulwren/.oh-my-zsh
ZSH_THEME="robbyrussell"

COMPLETION_WAITING_DOTS="true"
HIST_STAMPS="yyy-mm-dd"

plugins=(git colored-man-pages zsh-autosuggestions)
source $ZSH/oh-my-zsh.sh

# gpg key setup
export SSL_CERT_FILE=/etc/ssl/cert.pem
export GPG_TTY=$(tty)

# setup cargo
source $HOME/.cargo/env

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# setup direnv
eval "$(direnv hook zsh)"

# setup jruby
export JAVA_HOME=$(/usr/libexec/java_home)
export JRUBY_HOME=$HOME/bin/jruby/bin/jruby
export PATH=$HOME/bin/jruby/bin:$PATH
