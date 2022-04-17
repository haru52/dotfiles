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

# asdf
. /usr/local/opt/asdf/libexec/asdf.sh

# Incremental history search with peco
# Refs: https://qiita.com/shepabashi/items/f2bc2be37a31df49bca5
function peco-history-selection() {
  BUFFER=`history -n 1 | tail -r | awk '!a[$0]++' | peco`
  CURSOR=$#BUFFER
  zle reset-prompt
}

zle -N peco-history-selection
bindkey '^R' peco-history-selection

# Suppress brew doctor warning caused by asdf python
# Refs: https://zenn.dev/ryuu/scraps/fddefc2ca60f88
alias brew="PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin brew"

# Path
export PATH=$HOME/bin:$PATH
# export PATH="/usr/local/opt/openssl/bin:$PATH"
