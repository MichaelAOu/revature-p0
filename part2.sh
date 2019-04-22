#!/bin/bash

# verify part1
brew=$(which brew)
node=$(which node)
git=$(which git)
az=$(which az)

# check for brew
if [ -z $brew ]; then
  echo "No brew. Please install before continuing" 1>&2
  exit 1
fi

# check for node
if [ -z $node ]; then
  echo "No node. Please install before continuing" 1>&2
  exit 2
fi

# check for git
if [ -z $git ]; then
  echo "No git. Please install before continuing" 1>&2
  exit 3
fi

# check for azure-cli
if [ -z $az ]; then
  echo "No azure-cli. Please install before continuing" 1>&2
  exit 4
fi

# make the actual directory
mkdir -p ./git-project

# move to in an make it a git and node project
cd ./git-project
git init
npm init -y

# create all directories in the git project repo/this is basically revature(xyz)
mkdir -p \
  .docker \
  .github/ISSUE_TEMPLATE \
  .github/PULL_REQUEST_TEMPLATE \
  client \
  src \
  test

# touch files 
touch \
  .azureup.yaml \
  .dockerignore \
  .editorconfig \
  .gitignore \
  .markdownlint.yaml \
  CHANGELOG.md \
  LICENSE.txt \
  README.md

# touch files in .docker directory
touch \
  .docker/dockerfile \
  .docker/dockerup.yaml

# touch files in .github directory
touch \
  .github/CODE-OF-CONDUCT.md \
  .github/CONTRIBUTING.md \
  .github/ISSUE_TEMPLATE/issue-template.md \
  .github/PULL_REQUEST_TEMPLATE/pull-request-template.md \

# other files
touch \
  client/.gitkeep \
  src/.gitkeep \
  test/.gitkeep

# exit script
echo "part 2 successfull"
exit 0