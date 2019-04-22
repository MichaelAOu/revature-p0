#!/bin/bash

## script automates the process of setting up a new virutal machine

## update apt
sudo apt update
sudo apt upgrade -y

## set up brew - installation instructions from https://docs.brew.sh/Homebrew-on-Linux
# added -y flag to answer yes to confirmations
sudo apt install -y build-essential curl file git
echo "/n" | sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
sudo apt install -y linuxbrew-wrapper
echo 'export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"' >> ~/.profile
export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
source ~/.profile

## install gcc
brew install gcc

## install git
brew install git

## install azure-cli
brew install azure-cli

## install node
#  installing python3-distutils because of issues with icu4c
#  https://github.com/Homebrew/linuxbrew-core/issues/12680
sudo apt install -y python3-distutils
brew install node

## exit script
echo "installation completed"
exit 0