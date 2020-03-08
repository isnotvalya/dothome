# ~/.zshrc
#
# Depends:
#   - https://github.com/robbyrussell/oh-my-zsh.git
#

alias ttl65="sudo sysctl -w net.inet.ip.ttl=65"

alias code="/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code"
alias subl="/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl"
alias smerge="/Applications/Sublime\ Merge.app/Contents/SharedSupport/bin/smerge"

alias dns_flush='sudo killall -HUP mDNSResponder'
alias ram_purge='sudo purge'

export BREW=$HOME/brew
export PKG_CONFIG_PATH=$BREW/lib/pkgconfig:$PKG_CONFIG_PATH

if [[ -d $BREW/opt/go ]] ; then
  export GOROOT=$BREW/opt/go/libexec
fi

export PATH=$HOME/bin:$GOROOT/bin:$BREW/bin:$PATH
export ZSH=$HOME/.oh-my-zsh

export MINIKUBE_VM_DRIVER=vmware

test -f $ZSH/oh-my-zsh.sh || {
  git clone \
    --recursive \
    --branch=master https://github.com/robbyrussell/oh-my-zsh.git $ZSH
}

test -f $ZSH/oh-my-zsh.sh && {
  DISABLE_AUTO_UPDATE=true
  DISABLE_UPDATE_PROMPT=false

  # ZSH_THEME="nanotech"
  ZSH_THEME="minimal"

  plugins=(git)
  [ "$(uname -s)" = "Darwin" ] && plugins=(git osx kubectl)

  source $ZSH/oh-my-zsh.sh
}

export HOMEBREW_AUTO_UPDATE_SECS=3
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_AUTO_UPDATE=1
# export HOMEBREW_NO_EMOJI=1

export PYTHONDONTWRITEBYTECODE=1
export PYTHONUNBUFFERED=1
export PYTHONOPTIMIZE=
