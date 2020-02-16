if (test $(uname) = "Darwin"); then
  # running OSX

  if (! xcode-select -p 1>/dev/null); then
    # install xcode cli tools
    echo "Looks like xcode cli tools are missing, installing"
    xcode-select --install
  fi

  if (! type brew &> /dev/null); then
    # install homebrew
    echo "Looks like homebrew is missing, installing"
    /usr/bin/env ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew update && brew doctor
  fi

  if !(type git &> /dev/null) || (git version | grep "\b1\." -q); then
    # if missing git or using version 1, install with homebrew
    echo "Looks like git is missing or out-of-date, installing with brew"
    brew install git || brew upgrade git
  fi

  if [[ -z "$ZSH_NAME"]]; then
    brew install zsh
    # change shell to zsh is not set
    # chsh -s `which zsh`
  fi

  if (! type upgrade_oh_my_zsh &> /dev/null); then
    echo "Looks like oh-my-zsh is missing, installing"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  fi
fi
