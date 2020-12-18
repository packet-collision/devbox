data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_vpc" "dev" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Name = "devbox"
  }
}

resource "aws_internet_gateway" "dev" {
  vpc_id = aws_vpc.dev.id

  tags = {
    Name = "devbox"
  }
}

resource "aws_route_table" "dev" {
  vpc_id = aws_vpc.dev.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dev.id
  }
  
  tags = {
    Name = "devbox"
  }
}

resource "aws_subnet" "dev" {
  vpc_id = aws_vpc.dev.id
  cidr_block = "172.16.10.0/24"
  availability_zone = "ca-central-1a"

  tags = {
    Name = "devbox"
  }
}

resource "aws_route_table_association" "subnet-association" {
  subnet_id = aws_subnet.dev.id
  route_table_id = aws_route_table.dev.id
}

resource "aws_security_group" "devbox" {
  name = "devbox"
  vpc_id = aws_vpc.dev.id

  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 22
    to_port = 22
    protocol = "tcp"
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  tags = {
    Name = "devbox"
  }
}

resource "aws_network_interface" "primary" {
  subnet_id = aws_subnet.dev.id
  private_ips = [ "172.16.10.100" ]
  security_groups = [ aws_security_group.devbox.id ]
  
  tags = {
    Name = "primary_network_interface"
  }
}

resource "aws_eip" "dev" {
  instance = aws_instance.devbox.id
  vpc = true

  tags = {
    Name = "devbox"
  }
}

resource "aws_volume_attachment" "devbox-volume" {
  count = var.ebs-volume-id == "" ? 0 : 1
  device_name = "/dev/xvdh"
  volume_id = var.ebs-volume-id
  instance_id = aws_instance.devbox.id
}

resource "aws_key_pair" "vscode" {
  key_name = "dev-ssh-key"
  public_key = file("${path.module}/../../${var.path-to-ssh-public-key}")
}

resource "aws_instance" "devbox" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.small"
  key_name = aws_key_pair.vscode.key_name

  network_interface {
    network_interface_id = aws_network_interface.primary.id
    device_index = 0
  }

  tags = {
    Name = "devbox"
  }
}

output "elastic-ip" {
  value = aws_eip.dev.public_ip
}