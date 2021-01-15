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

module "image" {
  source = "./image"
  image_in = var.image[terraform.workspace]
}
resource "docker_container" "nodered_container" {
  count = local.container_count
  image = module.image.image_out
  name = join("-",["nodered", terraform.workspace,random_string.random[count.index].result])
  ports {
    internal = var.int_port
    external = var.ext_port[terraform.workspace][count.index]
  }

  volumes {
    container_path = "/data"
    host_path = "${path.cwd}/noderedvol/"
  }
}

