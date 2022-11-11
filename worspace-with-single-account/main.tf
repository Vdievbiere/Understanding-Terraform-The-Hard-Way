terraform {
    required_version = ">=1.1.0"

    backend "s3"  {
        bucket = "understanding-terraform-vivian-koji" # THE SAME STATE BUCKET IN ALL PROJECT
        key = "path/env/workspace-with-single-account"  # CHANGES KEY
        region = "us-east-1"
        dynamodb_table = "terraform-lock"
        encrypt = true 
    }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

################################################################################
# DEPLOY VPC IN 3 DF ACCOUNT VPC 
################################################################################
resource "aws_vpc" "this" {
  cidr_block       = var.vpc_cidr 
  instance_tenancy = "default"

  tags = {
    Name = upper("${terraform.workspace}-vivtechs-vpc") # SBX, DEV, PROD
  }
}
