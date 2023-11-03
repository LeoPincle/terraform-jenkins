output "web_ami_id" {
  value = aws_ami_from_instance.web-ami.id
}