resource "aws_lb_listener" "app_listener" {
  load_balancer_arn = var.app_lb_arn
  port = 80
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = var.app_tier_tg_arn
  }
}