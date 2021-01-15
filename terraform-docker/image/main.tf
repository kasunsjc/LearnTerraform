resource "docker_image" "nodered_image" {
  name = var.image[terraform.workspace]
}
