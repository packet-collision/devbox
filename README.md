```
@@@@@@@   @@@@@@@@  @@@  @@@  @@@@@@@    @@@@@@   @@@  @@@  
@@@@@@@@  @@@@@@@@  @@@  @@@  @@@@@@@@  @@@@@@@@  @@@  @@@  
@@!  @@@  @@!       @@!  @@@  @@!  @@@  @@!  @@@  @@!  !@@  
!@!  @!@  !@!       !@!  @!@  !@   @!@  !@!  @!@  !@!  @!!  
@!@  !@!  @!!!:!    @!@  !@!  @!@!@!@   @!@  !@!   !@@!@!   
!@!  !!!  !!!!!:    !@!  !!!  !!!@!!!!  !@!  !!!    @!!!    
!!:  !!!  !!:       :!:  !!:  !!:  !!!  !!:  !!!   !: :!!   
:!:  !:!  :!:        ::!!:!   :!:  !:!  :!:  !:!  :!:  !:!  
 :::: ::   :: ::::    ::::     :: ::::  ::::: ::   ::  :::  
:: :  :   : :: ::      :      :: : ::    : :  :    :   ::   
```


Provisions a remote dev envrionment that you can shell into, or integrate with VS Code via Remote-SSH: https://code.visualstudio.com/docs/remote/ssh

## Pre-requisites

Install the following (using HomeBrew if you're running mac os):

* AWS CLI
* Terraform 

## First Time Setup

0. install the AWS CLI and authenticate under the default profile
1. create a new SSH keypair: `make generate-ssh-keypair`
2. deploy EBS storage to keep files around after tearing down the host: `make create-storage`

## Bringing the server up...

Deploy the dev EC2 host: `make deploy-host` (you may need to answer a prompt or two)

## Tearing it all down...

Run `make destroy-host` to just tear down the host + networking resources (VPC, internet gateway, etc).

To remote the EBS volume, `make destroy-storage`.

## Configuring VS Code Remote-SSH

Use VS Code Remote-SSH plugin to connect to the `devbox` host (`command + shift + P` > `Remote-SSH: Connect to host...`)

This will launch a new VS Code window connected to the dev box. You can now open folders, run the terminal and start coding...

## Working with SSH 

Scripts to manage ssh key can be found in the `scripts` directory. The EC2 host is provisioned with the `dev-ssh-key`.

To register the ssh key with local agent: `ssh-add ./scripts/dev-ssh-key`

To ssh into the host: `ssh ubuntu@<host elastic IP address>`

### Connecting to remote services

Just set up SSH port forwarding. e.g. for mongodb: `make ssh-mongodb`

## Authenticating with GitHub

The `add-ssh-key-to-github.sh` script will prompt you for your GitHub credentials: username and personal access token. With these, the script will add the dev-ssh-key public key to your GitHub account. You can now pull code to the devbox using SSH.