export ZSH_CONFIG_DIR="$HOME/config/zsh"

source $ZSH_CONFIG_DIR/before.sh
source $ZSH_CONFIG_DIR/functions.sh
source $ZSH_CONFIG_DIR/fzf_functions.sh

config_files=$(rg --files $ZSH_CONFIG_DIR | rg -v "after|before|init|zshenv|functions\.sh")

for file in $(echo "$config_files" | cat); do
  source $file
done

source $ZSH_CONFIG_DIR/after.sh

