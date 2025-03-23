# Android
export PATH=$HOME/Library/Android/sdk/platform-tools:$PATH
export PATH=$HOME/Library/Android/sdk/emulator:$PATH

# Homebrew
[ $(command -v /opt/homebrew/bin/brew) ] && eval "$(/opt/homebrew/bin/brew shellenv)"
[ $(command -v /home/linuxbrew/.linuxbrew/bin/brew) ] && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Devbox
[ $(command -v devbox) ] && eval "$(devbox global shellenv)"

# golang
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

# fzf
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border"

# enhancd
export ENHANCD_COMMAND=enhancd

# zsh-autosuggestions
export ZSH_AUTOSUGGEST_USE_ASYNC=true

# keychain for Linux
if [ uname = "Linux" ]; then
  if [ $(command -v /usr/bin/keychain) ]; then
    /usr/bin/keychain -q --nogui $HOME/.ssh/id_ed25519
    source $HOME/.keychain/$(hostname)-sh
  elif [ $(command -v /usr/bin/apt) ]; then
    sudo apt install keychain
  fi
fi

