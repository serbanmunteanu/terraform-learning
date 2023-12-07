provider "aws" {
  region = "eu-central-1"
}

resource "aws_vpc" "my-app-vpc" {
  cidr_block = var.vpc_cidr_blocks
  tags = {
    Name: "${var.env_prefix}-vpc"
  }
}

module "myapp-subnet" {
  source = "./modules/subnet"
  availability_zone = var.availability_zone
  default_route_table_id = aws_vpc.my-app-vpc.default_route_table_id
  env_prefix = var.env_prefix
  subnet_cidr_block = var.subnet_cidr_block
  vpc_id = aws_vpc.my-app-vpc.id
}

module "myapp-server" {
  source = "./modules/webserver"
  availability_zone   = var.availability_zone
  env_prefix          = var.env_prefix
  image_name          = var.image_name
  instance_type       = var.instance_type
  my_ip               = var.my_ip
  public_key_location = var.public_key_location
  subnet_id           = module.myapp-subnet.subnet.id
  vpc_id              = aws_vpc.my-app-vpc.id
}

