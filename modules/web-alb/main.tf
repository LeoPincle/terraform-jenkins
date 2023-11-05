resource "aws_lb" "web-tier-external-lb" {
  name               = "web-tier-external-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.internet-facing-alb-sg]
  subnets            = [ var.pub_sub_1a_id, var.pub_sub_2b_id]
  enable_deletion_protection = false
  
  tags = {
    Environment = "web-tier-lb"
  }
}

