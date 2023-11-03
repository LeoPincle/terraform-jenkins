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
  associate_public_ip_address = true
  ami = data.aws_ami.amazon-linux-2.id
  security_groups =  [ var.web-tier-sg ]
  subnet_id = var.pub_sub_1a_id
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  key_name = "MyKey"
  tags = {
    Name = "Web-instance"
  }
}



