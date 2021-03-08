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
  keepers = {
    key_name = var.key_name
  }
}

resource "aws_key_pair" "app_node_key_pair" {
  key_name = var.key_name
  public_key = file(var.public_key_path)
}

resource "aws_instance" "app_node" {
  count = var.instance_count
  ami = data.aws_ami.server_ami.id
  instance_type = var.instance_type
  tags = {
    Name = "app-node-${random_id.app_node[count.index].dec}"
  }
  key_name = aws_key_pair.app_node_key_pair.id
  user_data = templatefile(var.user_data_path,
  {
    nodename = "app-node-${random_id.app_node[count.index].dec}",
    dbuser = var.db_username
    dbpass = var.db_password
    db_endpoint = var.db_endpoint
    db_name = var.db_name
  }

  )
  vpc_security_group_ids = [var.public_sg]
  subnet_id = var.public_subnet_ids[count.index]
  root_block_device {
    volume_size = var.volume_size #10
  }
}

resource "aws_lb_target_group_attachment" "alb_attachment" {
  target_group_arn = var.alb_target_group_arn
  target_id = aws_instance.app_node[count.index].id
  count =  var.instance_count
  port = 8000
}