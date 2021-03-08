#----networking/output

output "vpc_id" {
  value = aws_vpc.app_vpc.id
}

output "db_subnetgroup_name" {
  value = aws_db_subnet_group.app_rds_subnetgroup.*.name
}

output "db_security_group_ids" {
  value = [aws_security_group.app_sg["rds"].id]
}

output "public_sg_ids" {
  value = aws_security_group.app_sg["public"].id
}

output "public_subnet_ids" {
  value = aws_subnet.app_public_subnet.*.id
}