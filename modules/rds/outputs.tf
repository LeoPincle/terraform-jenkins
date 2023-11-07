output "rds_endpoint" {
  value = aws_db_instance.db.address
}
output "rds_db_instance" {
  value = aws_db_instance.db
}