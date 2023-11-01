output "app_instance_id" {
  value = aws_instance.app.id
}
output "ec2_role" {
  value = aws_iam_instance_profile.ec2_profile.name
}