
terraform {
    required_version = ">= 1.1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"  #optional but recommended in production - this is AWS APi vesrion
    }
  }
}

## for now BEST -Provider Block
provider "aws" {
    region= "us-east-1"
  profile = "default"
}

##data source to pull down avaialbe/existing resource in aws 
## how to pull a reosurce using data source # -target 
data "aws_availability_zones" "available" {
  state = "available"
}


## PUBLIC (VPC MODULE:)

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = data.aws_availability_zones.available.names
  private_subnets = var.private_cidr
  public_subnets  = var.public_cidr

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}