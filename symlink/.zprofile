# Android
export PATH=$HOME/Library/Android/sdk/platform-tools:$PATH
export PATH=$HOME/Library/Android/sdk/emulator:$PATH

# Set PATH, MANPATH, etc., for Homebrew.
[ $(command -v /opt/homebrew/bin/brew) ] && eval "$(/opt/homebrew/bin/brew shellenv)"
[ $(command -v /home/linuxbrew/.linuxbrew/bin/brew) ] && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# for WSL
if [ $(command -v /usr/bin/keychain) ]; then
    /usr/bin/keychain --nogui ~/.ssh/id_rsa
    source $HOME/.keychain/$(hostname)-sh
fi
