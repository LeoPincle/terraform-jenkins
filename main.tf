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

module "app"{
  source = "./modules/app-instance"
  instance_type = var.instance_type
  private-sg = module.security-group.PrivateInstanceSG-sg
  pri_sub_3a_id = module.vpc.pri_sub_3a_id
}

module "app-atg" {
  source = "./modules/app-atg"
  aws_vpc = module.vpc.vpc_id
} 

module "app-alb" {
  source = "./modules/app-alb"
  internal-lb-sg = module.securitygroup.internal-lb-sg
  pri_sub_3a_cidr = module.vpc.pri_sub_3a_id
  pri_sub_4b_cidr = module.vpc.pri_sub_4b_id
}

module "app-ami" {
  source = "./modules/app-ami"
  instance_id = module.app-instance.app.id
  app_instance = module.app-instance
}

module "app-ltp" {
  source = "./modules/app-ltp"
  app_ami_id = module.app-ami.app-ami.id
  PrivateInstanceSG = module.security-group.PrivateInstanceSG-sg
}

module "app-asg" {
  source = "./modules/app-asg"
  app_launch_template = module.app-ltp.app_launch_template
  pri_sub_3a = module.vpc.pri_sub_3a_id
  pri_sub_4b = module.vpc.pri_sub_4b_id
  AppTierTargetGroup = module.app-atg.AppTierTargetGroup
}