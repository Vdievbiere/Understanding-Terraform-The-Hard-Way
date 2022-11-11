
terraform {
    required_version = ">= 1.1.0"

    backend "s3"{
        bucket = "understanding-terraform-vivian-koji"
        key="path/env"
        region = "us-east-1"
        dynamodb_table = "terraform-lock"
        encrypt = true
    }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"  #optional but recommended in production - this is AWS APi vesrion
    }
  }
}


