variable "path-to-ssh-public-key" {
    description = "Path to the public SSH key to install on the devbox host. Relative to the root of the project. Used by VS Code to remote SSH, and to authenticate with GitHub."
    default = "scripts/ssh/dev-ssh-key.pub"
}

variable "ebs-volume-id" {
    description = "The ID of a manually created EBS volume to mount for the dev box. If this is not provided, no volume will be mounted"
    default = ""
}