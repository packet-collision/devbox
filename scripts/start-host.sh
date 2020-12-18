#!/bin/bash

devbox_instance_id=$(aws ec2 describe-instances \
    --filters "Name=tag:Name,Values=devbox" \
    --query "Reservations[].Instances[].InstanceId" \
    --output text)

echo "Starting devbox instance: $devbox_instance_id"
aws ec2 start-instances --instance-ids "$devbox_instance_id"