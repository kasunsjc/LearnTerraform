# -- loadbalancing/output.tf --

output "alb_target_group_arn" {
  value = aws_lb_target_group.app_target_group.arn
}