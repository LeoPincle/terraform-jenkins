resource "aws_db_subnet_group" "db-subnet" {
  name       = var.db_sub_name
  subnet_ids = [var.pri_sub_5a_id, var.pri_sub_6b_id] 
}

resource "aws_db_instance" "db" {
  identifier              = "db-instance"
  engine                  = "mysql"
  engine_version          = "5.7"
  instance_class          = "db.t2.micro"
  allocated_storage       = 20
  username                = var.db_username
  password                = var.db_password
  db_name                 = var.db_name
  multi_az                = true
  storage_type            = "gp2"
  storage_encrypted       = false
  publicly_accessible     = false
  skip_final_snapshot     = true
  backup_retention_period = 0

  vpc_security_group_ids = [var.db_sg_id] # Replace with your desired security group ID

  db_subnet_group_name = aws_db_subnet_group.db-subnet.name

  tags = {
    Name = "project-db"
  }
}

locals {
  db_config = <<-EOT
    module.exports = Object.freeze({
    DB_HOST : '${aws_db_instance.db.address}',
    DB_USER : '${var.db_username}',
    DB_PWD : '${var.db_password}',
    DB_DATABASE : '${var.db_name}'
    });
  EOT
  depends_on = [ aws_db_instance.db ]
}

resource "local_file" "db_configuration" {
  filename = "./application-code/app-tier/DbConfig.js"
  content = local.db_config
}