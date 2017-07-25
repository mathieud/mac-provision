#!/bin/bash

set -e

SRC_DIRECTORY="$HOME/dev/provision"
ANSIBLE_DIRECTORY="$SRC_DIRECTORY/ansible"
ANSIBLE_CONFIGURATION_DIRECTORY="$HOME/.ansible.d"

# Download and install Command Line Tools
if [[ ! -x /usr/bin/gcc ]]; then
    echo "Info   | Install   | xcode"
    xcode-select --install
fi

# Download and install Homebrew
if [[ ! -x /usr/local/bin/brew ]]; then
    echo "Info   | Install   | homebrew"
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Modify the PATH
# export PATH=/usr/local/bin:$PATH

# Download and install git
if [[ ! -x /usr/local/bin/git ]]; then
    echo "Info   | Install   | git"
    brew install git
fi

# Download and install python
if [[ ! -x /usr/local/bin/python ]]; then
    echo "Info   | Install   | python"
    brew install python --framework --with-brewed-openssl
fi

# Download and install Ansible
if [[ ! -x /usr/local/bin/ansible ]]; then
    brew install ansible
fi

# Clone repository
if [[ ! -d SRC_DIRECTORY ]]; then
    mkdir -p $SRC_DIRECTORY
    git clone git@github.com:mathieud/mac-provision.git $SRC_DIRECTORY
else
    cd $SRC_DIRECTORY
    git pull
    cd -
fi

# Provision the box
# ansible-playbook -i $ANSIBLE_DIRECTORY/inventories/osx.ini $ANSIBLE_DIRECTORY/playbook.yml --connection=local
ansible-playbook --ask-sudo-pass -i $ANSIBLE_DIRECTORY/inventories/osx.ini $ANSIBLE_DIRECTORY/playbook.yml --connection=local
