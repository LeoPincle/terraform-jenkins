resource "aws_launch_template" "web_launch_template" {
  name_prefix   = "web_launch_template"
  image_id      = var.web_ami_id
  instance_type = "t2.micro"
  security_group_names = [ var.web-tier-sg ]
  iam_instance_profile {
    name = var.ec2_role
  }
}