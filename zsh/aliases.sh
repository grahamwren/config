# Setup aliases

alias e=$EDITOR
alias cat=bat
alias mine="open -a \"IntelliJ IDEA\""
alias b="brew"

alias todo="$EDITOR ~/.todo.sch"
alias zrc="$EDITOR ~/.zshrc && source ~/.zshrc"
alias zshrc="$EDITOR ~/.zshrc && source ~/.zshrc"
alias source_aliases="source $ZSH_CONFIG_DIR/aliases.sh"
alias delete_trailing_ws="rg --files . | xargs gsed -E -i 's/[[:space:]]+$//g'"

# SSH
alias ccs="ssh pwren@login.ccs.neu.edu"

# Git
alias glog="command git log --graph"
alias gds="command git diff --staged"
alias gplrm="command git pull --rebase=i origin master"
alias current_repo="current_repository | awk -F'.' '{ print \$1 }'"
alias gforce='git push --force-with-lease origin $(current_branch)'
alias opr="open https://github.com/\$(current_repo)/compare/\$(current_branch)"

# Rails
alias be="bundle exec"
alias ber="bundle exec rake"

# Utils
alias dash_timestamp='date +"%Y-%m-%d-%H-%M-%S"'
alias k=kubectl
