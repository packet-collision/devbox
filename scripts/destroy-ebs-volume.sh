#!/bin/bash

volume_id=$(aws ec2 describe-volumes \
    --filters "Name=tag:Name,Values=devbox" \
    --query "Volumes[*].{ID:VolumeId}" \
    --output text)

echo "Deleting volume: $volume_id"
aws ec2 delete-volume --volume-id "$volume_id"