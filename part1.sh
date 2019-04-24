#!/bin/bash

# update
sudo apt update
sudo apt upgrade -y
echo "updated and upgraded"

# install brew
sudo apt-get install -y build-essential curl file git
sudo apt install -y build-essential curl file git
echo "/n" | sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
sudo apt install -y linuxbrew-wrapper
echo 'export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"' >> ~/.profile
export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
source ~/.profile
echo "brew installed"

# install gcc 
brew install gcc
echo "gcc installed"

# install azure-cli
brew install azure-cli
echo "azure-cli installed"

# install git
brew install git 
echo "git installed"

# install node
# need to get python beforehand
sudo apt install -y python3-distutils
brew install node
echo "node installed and python3"

# exit
echo "installation completed"
exit 0