#!/bin/bash

volume_id=$(aws ec2 describe-volumes \
    --filters "Name=tag:Name,Values=devbox" \
    --query "Volumes[*].{ID:VolumeId}" \
    --output text)

echo "Destroying the devbox 😓 😓 😓"
terraform -chdir=./../terraform destroy -var "ebs-volume-id=$volume_id"