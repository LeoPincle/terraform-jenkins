output "app_ami_id" {
  value = aws_ami_from_instance.app-ami.id
}