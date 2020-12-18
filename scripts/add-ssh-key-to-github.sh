#!/bin/sh

echo 'Adds the "dev-ssh-key" to your GitHub profile.';
echo 'If you get a "key is already in use" error, try deleting the existing "devbox" ssh key and run this script again.'
echo ""
read -p "Please enter your GitHub username: " github_username
read -s -p "Please enter your GitHub personal access token: " github_access_token
echo ""

dev_public_key=`cat ssh/dev-ssh-key.pub`

echo "Adding dev-ssh-key to your github account..."
curl \
    --request POST \
    -u $github_username:$github_access_token \
    -H "Content-Type: application/json" \
    --data "{\"title\": \"devbox\", \"key\": \"$dev_public_key\"}" \
    https://api.github.com/user/keys