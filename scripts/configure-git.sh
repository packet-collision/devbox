#!/bin/sh

echo 'Updates your git profile on the remote server';
echo ""
read -p "Please enter your git username: " git_username
echo ""

ssh -F ssh/config ubuntu@devbox "git config --global user.name \"$git_username\""