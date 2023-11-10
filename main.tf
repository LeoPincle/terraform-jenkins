module "vpc" {
    source = "./modules/vpc"
    region = var.region
    project_name = var.project_name
    vpc_cidr         = var.vpc_cidr
    pub_sub_1a_cidr = var.pub_sub_1a_cidr
    pub_sub_2b_cidr = var.pub_sub_2b_cidr
    pri_sub_3a_cidr = var.pri_sub_3a_cidr
    pri_sub_4b_cidr = var.pri_sub_4b_cidr
    pri_sub_5a_cidr = var.pri_sub_5a_cidr
    pri_sub_6b_cidr = var.pri_sub_6b_cidr
}

module "nat" {
  source = "./modules/nat"

  pub_sub_1a_id = module.vpc.pub_sub_1a_id
  igw_id        = module.vpc.igw_id
  pub_sub_2b_id = module.vpc.pub_sub_2b_id
  vpc_id        = module.vpc.vpc_id
  pri_sub_3a_id = module.vpc.pri_sub_3a_id
  pri_sub_4b_id = module.vpc.pri_sub_4b_id
  pri_sub_5a_id = module.vpc.pri_sub_5a_id
  pri_sub_6b_id = module.vpc.pri_sub_6b_id
}

module "security-group" {
  source = "./modules/securitygroup"
  vpc_id = module.vpc.vpc_id
}

module "rds" {
  source         = "./modules/rds"
  db_sg_id       = module.security-group.db-sg
  pri_sub_5a_id = module.vpc.pri_sub_5a_id
  pri_sub_6b_id = module.vpc.pri_sub_6b_id
  db_username    = var.db_username
  db_password    = var.db_password
}

module "app-instance"{
  source = "./modules/app-instance"
  instance_type = var.instance_type
  private-sg = module.security-group.PrivateInstanceSG-sg
  pri_sub_3a_id = module.vpc.pri_sub_3a_id
  db_username    = var.db_username
  db_password    = var.db_password
  endpoint = module.rds.rds_endpoint
  rds_db_instance = module.rds.rds_db_instance
  s3_bucket = module.s3-bucket.s3_bucket_id
}

module "app-atg" {
  source = "./modules/app-atg"
  aws_vpc = module.vpc.vpc_id
  depends_on = [ module.vpc ]
} 

module "app-alb" {
  source = "./modules/app-alb"
  internal-lb-sg = module.security-group.lb-sg
  pri_sub_3a_id = module.vpc.pri_sub_3a_id
  pri_sub_4b_id = module.vpc.pri_sub_4b_id
}

module "app-ami" {
  source = "./modules/app-ami"
  instance_id = module.app-instance.app_instance_id
  app_instance = module.app-instance
}

module "app-ltp" {
  source = "./modules/app-ltp"
  app_ami_id = module.app-ami.app_ami_id
  PrivateInstanceSG = module.security-group.PrivateInstanceSG-sg
  ec2_role = module.app-instance.ec2_role
}

module "app-asg" {
  source = "./modules/app-asg"
  app_launch_template = module.app-ltp.app_launch_template
  pri_sub_3a = module.vpc.pri_sub_3a_id
  pri_sub_4b = module.vpc.pri_sub_4b_id
  AppTierTargetGroup = module.app-atg.AppTierTargetGroup
  depends_on = [ module.app-alb ]
}

module "web-instance" {
  source = "./modules/web-instance"
  web-tier-sg = module.security-group.web-sg
  instance_type = var.instance_type
  pub_sub_1a_id = module.vpc.pub_sub_1a_id
  ec2-role = module.app-instance.ec2_role
  s3_bucket = module.s3-bucket.s3_bucket_id
}

module "web-ami" {
  source = "./modules/web-ami"
  web_instance_id = module.web-instance.web_instance_id
  web_instance = module.web-instance.web_instance
}

module "web-wtg" {
  source = "./modules/web-wtg"
  aws_vpc = module.vpc.vpc_id
}

module "web-alb" {
  source = "./modules/web-alb"
  internet-facing-alb-sg = module.security-group.internet-facing-alb-sg
  pub_sub_1a_id = module.vpc.pub_sub_1a_id
  pub_sub_2b_id = module.vpc.pub_sub_2b_id
}

module "web-alb-listener" {
  source = "./modules/web-alb-listener"
  web_lb_arn = module.web-alb.web_lb_arn
  web_tier_tg_arn = module.web-wtg.web_tier_tg_arn
}

module "web-ltp" {
  source = "./modules/web-ltp"
  web_ami_id = module.web-ami.web_ami_id
  web-tier-sg = module.security-group.web-sg
  ec2_role = module.app-instance.ec2_role
}

module "s3-bucket" {
  source = "./modules/s3-bucket"
}

module "s3-bucket-objects" {
  source = "./modules/s3-bucket-objects"
  s3_bucket = module.s3-bucket.s3_bucket
  s3_bucket_id = module.s3-bucket.s3_bucket_id
}