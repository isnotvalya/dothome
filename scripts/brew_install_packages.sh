#!/bin/zsh

BREW_PATH="$HOME/brew"
BREW_REPO_URL=https://github.com/Homebrew/brew.git

_brew() {
    $BREW_PATH/bin/brew $* || exit 1
}

install_brew() {
  test -d "$BREW_PATH" || {
    git clone --recursive --branch master $BREW_REPO_URL $BREW_PATH || exit 1
    _brew update
  }
}

install_brew

# Go packages
_brew install go golangci/tap/golangci-lint

# Docker packages
_brew install docker docker-machine docker-machine-driver-vmware  # docker-compose

# Kubernetes packages
_brew install kubernetes-cli helm@2 minikube derailed/k9s/k9s

# gRPC
_brew install grpc

# etc
_brew install https://ludocode.github.io/msgpack-tools.rb htop nasm cmake
