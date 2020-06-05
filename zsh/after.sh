# Run after other config files

. $HOME/.asdf/asdf.sh

# append completions to fpath
fpath=(${ASDF_DIR}/completions $fpath)
# initialise completions with ZSH's compinit
autoload -Uz compinit
compinit

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -s "$HOME/applications/scm_breeze/scm_breeze.sh" ] && source "$HOME/applications/scm_breeze/scm_breeze.sh"

# source some aliases last
source $ZSH_CONFIG_DIR/after_aliases.sh
