resource "aws_ami_from_instance" "web-ami" {
  name = "web-ami"
  source_instance_id = var.web_instance_id
  depends_on = [ var.web_instance ]
}