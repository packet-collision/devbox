!# /bin/sh

mkdir -p ssh

# Generates a SSH key pair
ssh-keygen -t rsa -C "devdev@veryspeedy.net" -f ./ssh/dev-ssh-key

# Copies it to your home directory
echo "Copying SSH key to your home directory: ~/.ssh/dev-ssh-key"
cp ./ssh/dev-ssh-key ~/.ssh/dev-ssh-key