resource "aws_lb_listener" "web_listener" {
  load_balancer_arn = var.web_lb_arn
  port = 80
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = var.web_tier_tg_arn
  }
}