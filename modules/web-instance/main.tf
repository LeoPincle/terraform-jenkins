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

resource "aws_instance" "web" {
  instance_type = var.instance_type
  associate_public_ip_address = true
  ami = data.aws_ami.amazon-linux-2.id
  vpc_security_group_ids = [ var.web-tier-sg ]
  subnet_id = var.pub_sub_1a_id
  iam_instance_profile = var.ec2-role
  key_name = "MyKey"
  tags = {
    Name = "Web-instance"
  }
  user_data = <<-EOF
      curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
      source ~/.bashrc
      nvm install 16
      nvm use 16
      cd ~/
      aws s3 cp s3://${var.s3_bucket}/web-tier/ web-tier --recursive
      cd ~/web-tier
      npm install 
      npm run build
      amazon-linux-extras install nginx1 -y
      cd /etc/nginx
      rm nginx.conf
      aws s3 cp s3://${var.s3_bucket}/nginx.conf .
      service nginx restart
      chmod -R 755 /home/ec2-user
      chkconfig nginx on
  EOF
}



