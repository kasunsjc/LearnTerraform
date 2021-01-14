terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.7"
    }
  }
}

provider "docker" {}

resource "null_resource" "dockervol" {
  provisioner "local-exec" {
    command = "mkdir noderedvol/ || true && sudo chown -R 1000:1000 noderedvol/"
  }
}

resource "random_string" "random" {
  count = local.container_count
  length = 4
  upper = false
  special = false
}

resource "docker_image" "nodered_image" {
  name = "nodered/node-red:latest"
}

resource "docker_container" "nodered_container" {
  count = local.container_count
  image = docker_image.nodered_image.latest
  name = join("-",["nodered", random_string.random[count.index].result])
  ports {
    internal = var.int_port
    external = var.ext_port[count.index]
  }

  volumes {
    container_path = "/data"
    host_path = "/mnt/c/Users/kasun/OneDrive/MCSA/DevOps/Terraform/MorethanCertifiedinTerraform/mtc-terraform/terraform-docker/noderedvol"
  }
}

