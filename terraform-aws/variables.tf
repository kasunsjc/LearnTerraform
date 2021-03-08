#--root/variables.tf

variable "aws_region" {
  default = "us-east-1"
}

variable "access_ip" {
}

# -- db variables --
variable "db_name" {}

variable "db_username" {
  sensitive = true
}

variable "db_password" {
  sensitive = true
}

# -- compute variables --

variable "instance_count" {}

variable "instance_type" {}