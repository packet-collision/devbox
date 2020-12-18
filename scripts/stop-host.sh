#!/bin/bash

devbox_instance_id=$(aws ec2 describe-instances \
    --filters "Name=tag:Name,Values=devbox" \
    --query "Reservations[].Instances[].InstanceId" \
    --output text)

echo "Stopping devbox instance: $devbox_instance_id"
aws ec2 stop-instances --instance-ids "$devbox_instance_id"

echo "Taking EBS snapshot... saving ur files!"
aws ec2 create-snapshot --volume-id 