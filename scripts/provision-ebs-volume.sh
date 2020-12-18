#!/bin/bash

echo "Creating EBS volume for devbox..."
aws ec2 create-volume \
    --availability-zone ca-central-1a \
    --size 15 \
    --volume-type gp2 \
    --tag-specifications 'ResourceType=volume,Tags=[{Key=Name,Value=devbox}]'