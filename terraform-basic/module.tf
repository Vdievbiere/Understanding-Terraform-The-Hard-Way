## TYPES (ROOT/CHILD)
# CLASSES OF MODULES( PUBLIC / PRIVATE MODULES)

# PRIVATE MODULES IS FOR SPECIFIC COMPANIES

## public vpc module
## modules are dynamic

locals {
  main_vpc_id     = module.vpc.vpc_id
  azs = data.aws_availability_zones.available.names
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "main"
  cidr = "10.0.0.0/16"

  azs             = slice(data.aws_availability_zones.available.names, 0,3)   # data source
  private_subnets = var.private_subnets  # list variable
  public_subnets  = var.public_subnets # list variable

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

######################################################

terraform {
    required_version = ">= 1.1.0" 
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0" # optional but recommended in production
    }
  }
}

provider "aws" {
  region = "us-east-1"
  profile = "default"
}

# locals {
#  main_vpc_id  = aws_vpc.main.id
#   azs             = data.aws_availability_zones.azs.names

# }

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ami" "ami" {
  most_recent      = true
  owners           = ["amazon"] # for golden ami you put "self"

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-*-gp2"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

## Creating ec2
         #resource_name   #local_name
resource "aws_instance" "ec2_instance" {
  ami           = data.aws_ami.ami.id  
  instance_type = var.instance_type

  tags = {
    Name = "ec2_instance"
  }
}


resource "aws_subnet" "private" {
  count = length(var.private_subnets)
  vpc_id     = local.main_vpc_id
  cidr_block = var.private_subnets[count.index]
  availability_zone = element(slice(local.azs, 0,2), count.index)
}

resource "aws_subnet" "public" {
  count = length(var.public_subnets)
  vpc_id     = local.main_vpc_id
  cidr_block = var.private_subnets[count.index]
  availability_zone = element(slice(local.azs, 0,2), count.index)

}



## output the  vpc_id that was created

## Functions 
### slice() 
### length
### element()
### Upper
### Lower

## output the subnet_ids