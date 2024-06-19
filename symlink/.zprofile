# Android
export PATH=$HOME/Library/Android/sdk/platform-tools:$PATH
export PATH=$HOME/Library/Android/sdk/emulator:$PATH

# Set PATH, MANPATH, etc., for Homebrew.
[ $(command -v /opt/homebrew/bin/brew) ] && eval "$(/opt/homebrew/bin/brew shellenv)"
[ $(command -v /home/linuxbrew/.linuxbrew/bin/brew) ] && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# for Linux
if [ uname = "Linux" ]; then
  if [ $(command -v /usr/bin/keychain) ]; then
    /usr/bin/keychain -q --nogui $HOME/.ssh/id_ed25519
    source $HOME/.keychain/$(hostname)-sh
  elif [ $(command -v /usr/bin/apt) ]; then
    sudo apt install keychain
  fi
fi
