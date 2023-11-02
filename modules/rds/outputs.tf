output "rds_endpoint" {
  value = aws_db_instance.db.endpoint
}
output "rds_db_instance" {
  value = aws_db_instance.db
}