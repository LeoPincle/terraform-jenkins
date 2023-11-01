resource "aws_launch_template" "app_launch_template" {
  name_prefix   = "app_launch_template"
  image_id      = var.app_ami_id
  instance_type = "t2.micro"
  security_group_names = [ var.PrivateInstanceSG ]
  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }
}