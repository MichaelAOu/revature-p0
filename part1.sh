#!/bin/bash

sudo apt update
sudo apt upgrade -y
sudo apt-get install -y build-essential curl file git

echo "updated and upgraded"

# install brew
sudo apt install linuxbrew-wrapper
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
# test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
# test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
# test -r ~/.bash_profile && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.bash_profile
# echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.profile

echo "brew installed"

# install azure-cli
brew install azure-cli

# install git
brew install git 

# install node
brew install node