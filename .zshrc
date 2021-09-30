#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...

# Prezto prompt theme
autoload -Uz promptinit
promptinit
prompt powerline

# anyenv
eval "$(anyenv init -)"

# incremental history search with peco
# ref. https://qiita.com/shepabashi/items/f2bc2be37a31df49bca5
function peco-history-selection() {
  BUFFER=`history -n 1 | tail -r | awk '!a[$0]++' | peco`
  CURSOR=$#BUFFER
  zle reset-prompt
}

zle -N peco-history-selection
bindkey '^R' peco-history-selection

# Suppress brew doctor warning caused by pyenv
# https://zenn.dev/ryuu/scraps/fddefc2ca60f88
alias brew="PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin brew"

# Path
export PATH=$HOME/bin:$PATH
