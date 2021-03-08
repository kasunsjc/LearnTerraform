locals {
  vpc_cidr = "10.10.0.0/16"
}

locals {
  security_groups = {
    public = {
      name        = "public_sg"
      description = "Public Security Group"
      ingress = {
        ssh = {
          from        = 22
          to          = 22
          protocol    = "tcp"
          cidr_blocks = [var.access_ip]
        },
        http = {
          from        = 0
          to          = 80
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        },
        nginx = {
          from = 8000
          to = 8000
          protocol ="tcp"
          cidr_blocks = ["0.0.0.0/0"]
        }
      }
    },
    rds = {
      name        = "rds-sg"
      description = "RDS DB access to the VPC resources"
      ingress = {
        mysql = {
          from        = 3306
          to          = 3306
          protocol    = "tcp"
          cidr_blocks = [local.vpc_cidr]
        }
      }
    }

  }
}
