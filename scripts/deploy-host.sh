#!/bin/bash

volume_id=$(aws ec2 describe-volumes \
    --filters "Name=tag:Name,Values=devbox" \
    --query "Volumes[*].{ID:VolumeId}" \
    --output text)

terraform -chdir=./../terraform apply -var "ebs-volume-id=$volume_id"
./ssh-create-config.sh
scp -F ssh/config ./ssh/dev-ssh-key ubuntu@devbox:/home/ubuntu/.ssh/dev-ssh-key
scp -F ssh/config ./provision-host.sh ubuntu@devbox:/tmp/provision-host.sh
ssh -F ssh/config ubuntu@devbox "chmod +x /tmp/provision-host.sh"
ssh -F ssh/config ubuntu@devbox "bash -s < /tmp/provision-host.sh"