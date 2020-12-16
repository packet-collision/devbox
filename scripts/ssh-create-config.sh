#!/bin/sh

DEVBOX_ELASTIC_IP=$(terraform -chdir=./../terraform output elastic-ip | tr -d '"')
echo "Creating SSH config for remote host with IP: ${DEVBOX_ELASTIC_IP}"

rm -f ssh/config
echo "Host devbox
    HostName ${DEVBOX_ELASTIC_IP}
    User ubuntu
    IdentityFile ~/.ssh/dev-ssh-key
    StrictHostKeyChecking no" >> ssh/config

cp ssh/config ~/.ssh/config
