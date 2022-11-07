setopt extended_glob # 高機能なワイルドカード展開を使用する
setopt auto_list # 補完候補を一覧表示
setopt auto_menu # TAB で順に補完候補を切り替え
setopt list_packed # 候補が多い場合は詰めて表示
setopt list_types # 補完候補一覧でファイルの種別を識別マーク表示(ls -F の記号)
setopt hist_ignore_dups # 重複する履歴は無視
setopt share_history # 履歴を共有
setopt hist_reduce_blanks # ヒストリに保存するときに余分なスペースを削除する
setopt extended_history # 履歴ファイルにzsh の開始・終了時刻を記録する
setopt hist_ignore_all_dups # 重複するコマンドは古い方を削除する
setopt interactive_comments # コメントを使えるようにする
setopt no_flow_control # フロー制御を無効にする
setopt ignore_eof # Ctrl+d無効
setopt no_beep # ビープ音を無効にする
setopt no_hist_beep # ビープ音を無効にする
setopt no_list_beep  # ビープ音を無効にする
setopt auto_param_keys #変数名を補完する
setopt auto_resume # サスペンド中のプロセスと同じコマンド名を実行した場合はリジュームする
setopt brace_ccl # echo {a-z}などを使えるようにする

unsetopt glob_dots #"*" にドットファイルをマッチ

# ヒストリーの設定
export LANG=ja_JP.UTF-8
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

# 補完の有効化
autoload -Uz compinit && compinit -u

# 補完候補を一覧表示したとき、Tabや矢印で選択できるように
zstyle ':completion:*:default' menu select=1

# 補完候補の色づけ
export LSCOLORS=gxfxcxdxbxegedabagacag # for mac
export LS_COLORS='di=36:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30' # for linux:
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# 大文字小文字を区別しない
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# emacsキーバインド
bindkey -e

# 失敗したコマンドを履歴に残らないようにする
zshaddhistory() {
    whence ${${(z)1}[1]} >| /dev/null || return 1
}

is_arm_mac() {
    if [[ `uname -sm` == "Darwin arm64" ]]; then
        return 0
    else
        return 1
    fi
}

is_intel_mac() {
    if [[ `uname -sm` == "Darwin x86_64" ]]; then
        return 0
    else
        return 1
    fi
}

grep-vim() {
    ret=$(grep -rn --exclude-dir=kernel $1 * | fzf | tr ':' ' ' | awk '{print $1,$2}')
    if [ -n "$ret" ]; then
        eval "arr=($ret)"
        vim "+"$arr[2] $arr[1]
    fi
}

vim-modified() {
    local FILE=$(git status --porcelain | awk '{print $2}' | fzf +m)
    if [ -n "$FILE" ]; then
        ${EDITOR:-vim} $FILE
    fi
}

fzf-select-history() {
    BUFFER=$(history -n -r 1 | fzf --no-sort +m --query "$LBUFFER" --prompt="History > ")
    CURSOR=${#BUFFER}
    zle reset-prompt
}
zle -N fzf-select-history
bindkey '^r' fzf-select-history

(is_arm_mac || is_intel_mac) && alias ls='ls -G -F' || alias ls='ls --color=auto -F'
alias ll='ls -l'
alias lla='ls -la'
alias sl='ls'
alias h='hostname'
alias git='noglob git'
alias g='git'
alias gb='git branch'
alias gs='git status'
alias gl="git log --pretty='format:%C(yellow)%h %C(cyan)%an %C(green)%cd %C(reset)%s %C(red)%d' --date=short"
alias gll='glo' # forgit plugin alias
alias gd='git diff'
alias gdd='git diff --cached'
alias groot='cd-gitroot'
alias ssh='ssh -A'
alias rezsh='source ~/.zshrc'
alias ..='cd ..'
alias ...='cd ../..'
alias sudo-vim='sudo -E vim'
alias psa="ps aux"
alias psg="ps aux | grep "
alias df='df -h'
alias d="docker"
alias k="kubectl"
alias colordiff="colordiff -u"
alias url-encode='python3 -c "import sys, urllib.parse as parse; print(parse.quote(sys.argv[1]));"'
alias url-decode='python3 -c "import sys, urllib.parse as parse; print(parse.unquote(sys.argv[1]));"'
alias base64-urlsafe-encode='python3 -c "import sys,base64; print(base64.urlsafe_b64encode(sys.argv[1].encode()).decode());"'
alias base64-urlsafe-decode='python3 -c "import sys,base64; print(base64.urlsafe_b64decode(sys.argv[1].encode()).decode());"'
alias random-generate='python3 -c "import sys,random,string; print(\"\".join([random.choice(string.ascii_letters + string.digits) for n in range(int(sys.argv[1]))]));"'
alias asdf-add-to-global='(){asdf plugin add $1; asdf install $1 latest; asdf global $1 latest}'

ASDF="$(brew --prefix asdf)/libexec/asdf.sh"
[ -e $ASDF ] && source $ASDF

# install plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -e $ZINIT_HOME ]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone --depth 1 https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

fzf_binary_regex="*"
is_arm_mac && fzf_binary_regex="*darwin*arm64*"
is_intel_mac && fzf_binary_regex="*darwin*amd64*"
zi ice from"gh-r" as"program" bpick"$fzf_binary_regex"
zi light junegunn/fzf
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border"

export ENHANCD_COMMAND=enhancd
# [ -n "$(alias cd)" ] && unalias cd # 以前のaliasの設定を削除しておく
zi ice src"init.sh"
zi light b4b4r07/enhancd
enhancd-select-directory() {
    enhancd
    zle reset-prompt
}
zle -N enhancd-select-directory
bindkey '^d' enhancd-select-directory

zi ice wait lucid
zi light zdharma-continuum/fast-syntax-highlighting

zi ice wait lucid
zi light zsh-users/zsh-completions

export ZSH_AUTOSUGGEST_USE_ASYNC=true
zi ice src"zsh-autosuggestions.zsh" wait lucid
zi light zsh-users/zsh-autosuggestions

zi light chrissicool/zsh-256color

zi light mollifier/cd-gitroot

zi light wfxr/forgit

# Note: need to execute at last
eval "$(starship init zsh)"

