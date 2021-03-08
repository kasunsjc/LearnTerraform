#---root/main.tf

module "networking" {
  source           = "./networking"
  vpc_cidr         = "10.10.0.0/16"
  private_sn_count = 3
  public_sn_count  = 2
  max_subnets      = 20
  security_groups  = local.security_groups
  access_ip        = var.access_ip
  public_cidrs     = [for i in range(2, 255, 2) : cidrsubnet(local.vpc_cidr, 8, i)]
  private_cidrs    = [for i in range(1, 255, 2) : cidrsubnet(local.vpc_cidr, 8, i)]
  db_subnetgroup   = true
}

module "database" {
  source                 = "./database"
  db_storage             = 10
  db_engine_version      = "5.7.22"
  db_instence_class      = "db.t2.micro"
  db_name                = var.db_name
  db_username            = var.db_username
  db_password            = var.db_password
  db_identifier          = "app-db"
  db_subnetgroup_name    = module.networking.db_subnetgroup_name[0]
  vpc_security_group_ids = module.networking.db_security_group_ids
  skip_db_snapshot       = true
}

module "loadbalancing" {
  source                  = "./loadbalancing"
  public_sg               = module.networking.public_sg_ids
  public_subnets          = module.networking.public_subnet_ids
  vpc_id                  = module.networking.vpc_id
  alb_healthy_threshold   = 2
  alb_unhealthy_threshold = 3
  target_group_port       = 8000
  alb_interval            = 30
  alb_timeout             = 5
  target_group_protocol   = "HTTP"
  listener_port = 80
  listener_protocol = "HTTP"
}

module "compute" {
  source = "./compute"
  instance_count = var.instance_count
  instance_type = var.instance_type
  public_sg = module. networking.public_sg_ids
  public_subnet_ids = module.networking.public_subnet_ids
  volume_size = 10
  public_key_path = var.public_key_path
  key_name = var.key_name
  user_data_path = "${path.root}/userdata.tpl"
  db_endpoint = module.database.db_endpoint
  db_name = var.db_name
  db_password = var.db_password
  db_username = var.db_username
  alb_target_group_arn = module.loadbalancing.alb_target_group_arn
}