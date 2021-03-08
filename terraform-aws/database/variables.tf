# -- database/variables.tf --
variable "db_storage" {
  type = number
}

variable "db_engine_version" {
  type = string
}

variable "db_instence_class" {
  type = string
}

variable "db_name" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_password" {}

variable "db_subnetgroup_name" {}

variable "vpc_security_group_ids" {}

variable "skip_db_snapshot" {}

variable "db_identifier" {}