## this block is meant to set constraint on terrafornm version 
terraform {
    required_version = ">= 1.1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

## for now BEST 
provider "aws" {
    region= "us-east-1"
  profile = "default"
}

##Resource Block (Create Resource/Bring into an existence)
resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "main"
  }
}

##data source to pull down avaialbe resource in aws 
