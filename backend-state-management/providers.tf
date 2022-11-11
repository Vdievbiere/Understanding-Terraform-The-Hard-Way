
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

