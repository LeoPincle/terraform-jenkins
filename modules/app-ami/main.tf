resource "aws_ami_from_instance" "app-ami" {
  name = "app-ami"
  source_instance_id = var.instance_id
  depends_on = [ var.app_instance ]
}