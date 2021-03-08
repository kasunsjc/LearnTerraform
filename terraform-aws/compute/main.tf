# -- compute/main.tf --

data "aws_ami" "server_ami" {
  most_recent = true
  owners = ["099720109477"]

  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
}

resource "random_id" "app_node" {
  byte_length = 3
  count = var.instance_count
}

resource "aws_instance" "app_node" {
  count = var.instance_count
  ami = data.aws_ami.server_ami.id
  instance_type = var.instance_type
  tags = {
    Name = "app-node-${random_id.app_node[count.index].dec}"
  }
  #key_name = ""
  #user_data = ""
  vpc_security_group_ids = [var.public_sg]
  subnet_id = var.public_subnet_ids[count.index]
  root_block_device {
    volume_size = var.volume_size #10
  }
}