# -- loadbalancing/variables.tf --

variable "public_subnets" {}

variable "public_sg" {}

variable "alb_healthy_threshold" {}

variable "target_group_port" {}

variable "target_group_protocol" {}

variable "vpc_id" {}

variable "alb_unhealthy_threshold" {}

variable "alb_timeout" {}

variable "alb_interval" {}

variable "listener_port" {}

variable "listener_protocol" {}