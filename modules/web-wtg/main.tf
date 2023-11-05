resource "aws_lb_target_group" "WebTierTargetGroup" {
  name     = "WebTierTargetGroup"
  port     = 80
  protocol = "HTTP"
  health_check {
    path = "/health"
    port = 80
    protocol = "HTTP"
    healthy_threshold = 3
    unhealthy_threshold = 3
  }
  vpc_id   = var.aws_vpc
}