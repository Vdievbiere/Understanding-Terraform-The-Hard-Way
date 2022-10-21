## this block is meant to set constraint on terrafornm version 
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

#Creating VPC
##Resource Block (Create Resource/Bring into an existence)
resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"  #cidr (re-usable)
#variable  instance_tenancy = "default"
  tags = {
    Name = "main"
  }
}


#how to ref a variablr  (var.ami.id)


#creating ec2
          #local_name    #resource_name
resource "aws_instance" "ec2_Instance" {
  ami           = var.ami_id
  instance_type = "t2.micro"

  tags = {
    Name = "ec2_Instance"
  }
}

##data source to pull down avaialbe resource in aws 
