################################################################################
# CONFIGURE BACKEND
################################################################################

terraform {
  required_version = ">=1.1.0" # version

  backend "s3" {
    bucket         = "3-tier-architecture-implement-11-14-22"
    key            = "path/env"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

################################################################################
# PROVIDERS BLOCK
################################################################################

provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      ChangeCode = "100283836HDHDF"
      component  = var.component
    }
  }
}

################################################################################
# LOCALS BLOCK
################################################################################

locals {
  azs    = data.aws_availability_zones.available.names
  vpc_id = module.vpc.vpc_id
}

################################################################################
# DATA SOURCE BLOCK
################################################################################

data "aws_availability_zones" "available" {
  state = "available"
}

################################################################################
# USING MODULE
################################################################################

module "vpc" {
  source = "git::https://gitlab.com/Ogheneovo/operational-environment-networking.tf.git?ref=v1.1.0"
 

  component_name = "${var.component}-vpc"  
  vpc_cidr = var.vpc_cidr 
  availability_zone = slice(local.azs, 0, 3)
  public_subnetcidr = var.public_subnetcidr 
  private_subnetcidr = var.private_subnetcidr 
  database_subnetcidr = var.database_subnetcidr 
}


### HOW CAN WE GET VPC_ID, SUBNET_ID(PUBLIC && PRIVATE)