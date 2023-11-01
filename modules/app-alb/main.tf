resource "aws_lb" "app-tier-internal-lb" {
  name               = "app-tier-internal-lb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [var.internal-lb-sg]
  subnets            = [ var.pri_sub_3a_cidr, var.pri_sub_4b_cidr]

  enable_deletion_protection = false

  tags = {
    Environment = "app-tier-lb"
  }
}