# -- loadbalancing/main.tf --

resource "aws_lb" "app-alb" {
  name               = "app-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.public_subnets
  security_groups    = [var.public_sg]
  idle_timeout       = 400
}

resource "aws_lb_target_group" "app_target_group" {
  name     = "app-lb-tg-${substr(uuid(), 0, 3)}"
  port     = var.target_group_port     #80
  protocol = var.target_group_protocol #http
  vpc_id   = var.vpc_id
  lifecycle {
    ignore_changes = [name]
    create_before_destroy = true
  }
  health_check {
    healthy_threshold   = var.alb_healthy_threshold   #2
    unhealthy_threshold = var.alb_unhealthy_threshold #3
    timeout             = var.alb_timeout             #5
    interval            = var.alb_interval            #30
  }
}

resource "aws_lb_listener" "alb_http_listener" {
  load_balancer_arn = aws_lb.app-alb.arn
  port              = var.listener_port
  protocol          = var.listener_protocol
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_target_group.arn
  }
}