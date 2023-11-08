resource "aws_autoscaling_group" "app-asg" {
  
  vpc_zone_identifier = [ var.pri_sub_3a, var.pri_sub_4b ]
  desired_capacity   = 2
  max_size           = 2
  min_size           = 2
  load_balancers = [ var.AppTierTargetGroup ]
  
  launch_template {
    id = var.app_launch_template
    version = "$Latest"
  }
  depends_on = [ var.app_launch_template ]
}