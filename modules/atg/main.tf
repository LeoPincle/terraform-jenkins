resource "aws_lb_target_group" "AppTierTargetGroup" {
  name     = "AppTierTargetGroup"
  port     = 4000
  protocol = "HTTP"
  health_check {
    path = "/health"
    port = 4000
    protocol = "HTTP"
    healthy_threshold = 3
    unhealthy_threshold = 3
  }
  vpc_id   = var.aws_vpc
}