resource "aws_autoscaling_group" "web-asg" {
  
  vpc_zone_identifier = [ var.pub_sub_1a_id, var.pub_sub_2b_id ]
  desired_capacity   = 2
  max_size           = 2
  min_size           = 2
  load_balancers = [ var.WebTierTargetGroup ]
  
  launch_template {
    id      = var.web_launch_template
    version = "$Latest"
  }
}