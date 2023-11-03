data "aws_ami" "amazon-linux-2" {
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}

locals {
  endpoint = replace(var.endpoint, ":3306", "")
}

resource "aws_instance" "app" {
  instance_type = var.instance_type
  ami = data.aws_ami.amazon-linux-2.id
  #security_groups =  [ var.private-sg ]
  vpc_security_group_ids = [ var.private-sg ]
  subnet_id = var.pri_sub_3a_id
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  user_data = <<-EOF
		#!/bin/bash
    yum install mysql -y
    echo ${var.db_password} > /root/.mysqlpw
    mysql -h ${local.endpoint} -u ${var.db_username} -p`cat /root/.mysqlpw `
    CREATE DATABASE webappdb; 
    USE webappdb; 
    CREATE TABLE IF NOT EXISTS transactions(id INT NOT NULL AUTO_INCREMENT, amount DECIMAL(10,2), description VARCHAR(100), PRIMARY KEY(id));   
    INSERT INTO transactions (amount,description) VALUES ('400','groceries'); 
    exit; 

    yum install git -y
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
    source ~/.bashrc
    nvm install 16
    nvm use 16
    npm install -g pm2
    cd ~/
    aws s3 cp s3://project-ci-web-data/app-tier/ app-tier --recursive
    cd ~/app-tier
    npm install
    pm2 start index.js
    pm2 startup
    pm2 save
	EOF
  key_name = "MyKey"
  tags = {
    Name = "App-instance"
  }
  depends_on = [ var.rds_db_instance ]
}



