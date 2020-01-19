if (! ls $HOME/config); then
  git clone https://github.com/grahamwren/config.git $HOME/config
else
  printf "$HOME/config already exists, skipping clone"
fi


# ensure ~/.config
mkdir $HOME/.config &>/dev/null

ln -s $HOME/config/zsh $HOME/.config/zsh
ln -s $HOME/config/nvim $HOME/.config/nvim
ln -s $HOME/config/git $HOME/.config/git

touch $HOME/.zshrc
echo "source $HOME/.config/zsh/init.sh" >> $HOME/.zshrc

if [[ -z "$ZSH_NAME" ]]; then
  printf <<MESSAGE
Looks like you're not running zsh.
Install it and oh-my-zsh to use this config.
  $ brew install zsh
  $ sh -c \"\$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)\"
  $ sudo chsh -s \`which zsh\`
MESSAGE
fi

if (! type nvim &>/dev/null); then
  printf <<MESSAGE
Looks like you aren't running nvim.
Install it with brew to use this config
  $ brew install nvim
  $ echo 'export EDITOR="nvim"' >> ~/.zshrc
MESSAGE
fi

if (! type update_scm_breeze &>/dev/null); then
  printf <<MESSAGE
Looks like you aren't running scm_breeze.
Install it like this to use this config
  $ git clone git://github.com/scmbreeze/scm_breeze.git ~/.scm_breeze
  $ ~/.scm_breeze/install.sh
  $ source ~/.zshrc
MESSAGE
fi

if (! type fzf &>/dev/null); then
  printf <<MESSAGE
Looks like you aren't running fzf.
Install it like this to use this config
  $ brew install fzf
  $ \$(brew --prefix)/opt/fzf/install
MESSAGE
fi

if (! type rg &>/dev/null); then
  printf <<MESSAGE
Looks like you aren't running ripgrep.
Install it like this to use this config
  $ brew install ripgrep
MESSAGE
fi

