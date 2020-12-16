module "ec2-host" {
    source ="./ec2-host"

    ebs-volume-id = var.ebs-volume-id
}

output "elastic-ip" {
  value = module.ec2-host.elastic-ip
}