clean :

init :
	cd terraform && terraform init

generate-ssh-keypair :
	cd scripts
	./generate-ssh-key.sh

ssh :
	ssh -F ./scripts/ssh/config devbox

ssh-mongodb :
	ssh -L 27017:localhost:27017 -F ./scripts/ssh/config devbox

create-persistent-storage :
	aws ec2 create-volume --availability-zone ca-central-1a --size 15 --volume-type gp2

deploy-host :
	cd terraform && terraform apply
	cd scripts && ./ssh-create-config.sh
	scp -F scripts/ssh/config ./scripts/ssh/dev-ssh-key ubuntu@devbox:/home/ubuntu/.ssh/dev-ssh-key
	scp -F scripts/ssh/config ./scripts/provision-host.sh ubuntu@devbox:/tmp/provision-host.sh
	ssh -F scripts/ssh/config ubuntu@devbox "chmod +x /tmp/provision-host.sh"
	ssh -F scripts/ssh/config ubuntu@devbox "bash -s < /tmp/provision-host.sh"

destroy-host :
	cd terraform && terraform destroy

configure-git :
	echo "Setting git user.name: $GIT_USERNAME" 
	git config --global user.name "$GIT_USERNAME"

