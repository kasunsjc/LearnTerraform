variable "ext_port" {
  type = list(number)

  validation {
    condition = max(var.ext_port... )<= 65535 && min(var.ext_port...) > 0
    error_message = "The External port must be in the valid range of 0 - 65535."
  }
}

variable "int_port" {
  type = number
  default = 1880

  validation {
    condition = var.int_port == 1880
    error_message = "Internal Port must be 1880."
  }
}

locals {
  container_count = length(var.ext_port)
}