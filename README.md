# Config files for MacOS with nvim and zsh

author: [@grahamwren](https://github.com/grahamwren)

## Setup

```bash
$ bash -c "$(curl https://raw.githubusercontent.com/grahamwren/config/master/setup_config.sh)"
```

## Dependencies

- [brew](https://brew.sh/)
- [zsh](https://github.com/ohmyzsh/ohmyzsh) `brew install zsh`
- nvim `brew install nvim && echo 'export EDITOR="nvim"' >> ~/.zshrc`
- git `brew install git`
- ripgrep(rg) `brew install ripgrep`
- fzf `brew install fzf && $(brew --prefix)/opt/fzf/install`
- fd `brew install fd`
- [scm_breeze](https://github.com/scmbreeze/scm_breeze)
- gnutls: `brew install gnutls`
