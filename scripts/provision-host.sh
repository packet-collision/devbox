#!/bin/bash
set -e

echo "########################################"
echo " Provisioning dev box..."
echo "########################################"

# GENERAL
sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade
sudo apt-get -y -qq install \
    curl \
    wget \
    git \
    vim \
    apt-transport-https \
    ca-certificates \
    gnupg-agent \
    software-properties-common

# DOCKER
# install docker engine
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get -y -qq install \
    docker-ce \
    docker-ce-cli \
    containerd.io

# create docker group so you don't have to run docker with root privileges
sudo groupadd -f docker
sudo usermod -aG docker $USER
newgrp docker

# install docker compose
sudo apt install -y docker-compose

# print versions
echo ""
docker -v
docker-compose -v

# NODE.JS

#install nodejs
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt-get install -y nodejs

# install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash

# GITHUB
echo ""
echo "Add keys to agent (the dev-ssh-key key is used to authenticate with GitHub)"
echo "This is a bit of a hack... ;("
echo '# make sure ssh agent is running - so as to authenticate with GitHub...' >> ~/.bashrc
echo 'eval "$(ssh-agent -s)"' >> ~/.bashrc
echo 'ssh-add ~/.ssh/dev-ssh-key' >> ~/.bashrc

# EBS volume
echo "Checking to see if the EBS volume has already been formatted..."
ebs_volume_info="$(sudo file -s /dev/nvme1n1)"

if [[ $ebs_volume_info != *"XFS"* ]]; then
    echo "EBS volume hasn't been formatted yet.. so I'm doing that now..."
    sudo mkfs -t xfs /dev/nvme1n1
else
    echo "EBS volume has already been formatted.. moving along: $ebs_volume_info"
fi

echo "Creating mount point for the volume... /code"
sudo mkdir /code
sudo mount /dev/nvme1n1 /code
sudo chown -R $USER /code

echo ""
echo "Done!"
