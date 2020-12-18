clean :

# shuts down the remote ec2 instance and ebs volume
stop-host :
	

# turns on the ec2 instance and restores the ebs volume
start-host :


init :
	cd terraform && terraform init

generate-ssh-keypair :
	cd scripts && ./generate-ssh-key.sh

ssh :
	ssh -F ./scripts/ssh/config devbox

ssh-mongodb :
	ssh -L 27017:localhost:27017 -F ./scripts/ssh/config devbox

# deploy the EBS volume used to keep files around when the host is shut down
deploy-storage :
	cd scripts && ./provision-ebs-volume.sh

destroy-storage :
	cd scripts && ./destroy-ebs-volume.sh

deploy-host :
	cd scripts && ./deploy-host.sh

destroy-host :
	cd scripts && ./destroy-host.sh

configure-git :
	echo "Setting git user.name: $GIT_USERNAME" 
	git config --global user.name "$GIT_USERNAME"

