# Run after other config files

. /usr/local/opt/asdf/asdf.sh
. /usr/local/opt/asdf/etc/bash_completion.d/asdf.bash

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -s "/Users/paulwren/.scm_breeze/scm_breeze.sh" ] && source "/Users/paulwren/.scm_breeze/scm_breeze.sh"

