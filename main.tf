provider "aws" {
  region = "eu-central-1"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name = "my-vpc"
  cidr = var.vpc_cidr_blocks
  azs = [var.availability_zone]
  public_subnets = [var.subnet_cidr_block]
  public_subnet_tags = {
    Name = "${var.env_prefix}-subnet-1"
  }
  tags = {
    Name = "${var.env_prefix}-vpc"
  }
}

module "myapp-server" {
  source = "./modules/webserver"
  availability_zone   = var.availability_zone
  env_prefix          = var.env_prefix
  image_name          = var.image_name
  instance_type       = var.instance_type
  my_ip               = var.my_ip
  public_key_location = var.public_key_location
  subnet_id           = module.vpc.public_subnets[0]
  vpc_id              = module.vpc.vpc_id
}

