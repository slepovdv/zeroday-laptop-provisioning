#!/bin/bash

# Install ssh
echo -e "\n\n\n" | ssh-keygen -t rsa -b 4096 -C "tmnkun@gmail.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
getidrsapub=$(cat "$HOME"/.ssh/id_rsa.pub)


# Install prerequisit
sudo apt update
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common \
    fonts-firacode \
    shellcheck \
    git

git config --global user.name "Denis Slepov"
git config --global user.email "tmnkun@gmail.com"

git clone https://github.com/magicmonty/bash-git-prompt.git .bash-git-prompt --depth=1
mv .bash-git-prompt "${HOME}"

curl -L https://raw.githubusercontent.com/yyuu/pyenv-installer/master/bin/pyenv-installer | bash


# Install Ansible
getansibleversion=$(ansible --version)
if [ "ansible" == "${getansibleversion:0:7}" ]; then
    echo "${getansibleversion:0:13} is install"
else
    sudo apt-add-repository --yes --update ppa:ansible/ansible && sudo apt install -y ansible
fi


# Install Docker
getdockerversion=$(docker -v)
dockerrelease="stable"
if [ "Docker" == "${getdockerversion:0:6}" ]; then
    echo "${getansibleversion:0} is install"
else
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    ${dockerrelease}"
    sudo apt-get update && sudo apt-get install -y docker-ce docker-ce-cli containerd.io
    sudo usermod -aG docker "${USER}"
fi


# Install Google Chrome
sudo apt-get install libxss1 libappindicator1 libindicator7
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install ./google-chrome*.deb


# Install software using snap
sudo snap install code --classic
sudo snap install telegram-desktop
sudo snap install micro --classic


# Run ansible playbook
sudo ansible-playbook -K install.yml


# Postinstall tasks
source "${HOME}"/.bashrc
echo "Enter public key to you github $getidrsapub"
rm -f google-chrome*.deb 
su "${USER}"