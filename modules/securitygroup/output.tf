output "alb-sg" {
  value = aws_security_group.internet-facing-alb-sg.id
}

output "web-sg" {
  value = aws_security_group.web-tier-sg.id
}

output "lb-sg" {
  value = aws_security_group.internal-lb-sg.id
}

output "PrivateInstanceSG-sg" {
  value = aws_security_group.PrivateInstanceSG.id
}

output "db-sg" {
  value = aws_security_group.db-sg.id
}