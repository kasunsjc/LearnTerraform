variable "image" {
  type = map(string)
  description = "Image for the containers"
  default = {
    dev = "nodered/node-red:latest"
    prod = "nodered/node-red:latest-minimal"
  }
}
