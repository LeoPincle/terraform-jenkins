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

resource "aws_instance" "app" {
  instance_type = var.instance_type
  ami = data.aws_ami.amazon-linux-2.id
  security_groups =  [ var.private-sg ]
  subnet_id = var.pri_sub_3a_id
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  user_data = <<-EOF
		#!/bin/bash
    yum install mysql -y
    yum install git -y
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
    source ~/.bashrc
    nvm install 16
    nvm use 16
    npm install -g pm2
	EOF
  key_name = "MyKey"
  tags = {
    Name = "App-instance"
  }
}



