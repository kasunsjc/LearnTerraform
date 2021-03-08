# -- database/main.tf --

resource "aws_db_instance" "app_db" {
  allocated_storage      = var.db_storage
  engine                 = "mysql"
  engine_version         = var.db_engine_version
  instance_class         = var.db_instence_class
  name                   = var.db_name
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = var.db_subnetgroup_name
  vpc_security_group_ids = var.vpc_security_group_ids
  identifier             = var.db_identifier
  skip_final_snapshot    = var.skip_db_snapshot

  tags = {
    name = "app-db"
  }
}
