# ## this block is meant to set constraint on terrafornm version 
# terraform {
#     required_version = ">= 1.1.0"

#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 4.0"  #optional but recommended in production - this is AWS APi vesrion
#     }
#   }
# }

# ## for now BEST -Provider Block
# provider "aws" {
#     region= "us-east-1"
#   profile = "default"
# }



# #Creating VPC
# ##Resource Block (Create Resource/Bring into an existence)
# # resource "aws_vpc" "example" {
# #   cidr_block       = var.cidr #cidr (re-usable)
# # #variable  instance_tenancy = "default"
# #   tags = {
# #     Name = "main"
# #   }
# # }

# resource "aws_subnet" "private1" {
#     count = length(var.private_subnets_cidr) # 4
#   vpc_id     =local.example_vpc_id # 
#   cidr_block = var.subnet_cidr[0] # var.variable 
#   availability_zone =  data.aws_availability_zones.available.names[0]  #element]
# #   tags = {
# #     Name = "private_subnet"
# #   }
# }
# #'  0
# #["10.0.1.0/24", 10.0.3.0/24, 10.0.5.0/24, 10.0.7.0/24 ]

# # resource "aws_subnet" "private1" {
# #     count = 0
# #   vpc_id     =local.example_vpc_id # 
# #   cidr_block = var.subnet_cidr[0] # var.variable 
# #   availability_zone =  data.aws_availability_zones.available.names[0]

# # ## 
# # resource "aws_subnet" "private2" {
# #   vpc_id     = local.example_vpc_id # 
# #   cidr_block = var.subnet_cidr[1]
# #   availability_zone =  data.aws_availability_zones.available.names[1]
# # }

# # ## 
# # resource "aws_subnet" "private3" {
# #   vpc_id     = local.example_vpc_id # 
# #   cidr_block = var.subnet_cidr[2]
# #   availability_zone =  data.aws_availability_zones.available.names[0]
# # }

# # ## 
# # resource "aws_subnet" "private4" {
# #   vpc_id     = local.example_vpc_id # 
# #   cidr_block = var.subnet_cidr[3]
# #   availability_zone =  data.aws_availability_zones.available.names[1]
# # }


# #how to ref a variable  (var.ami.id)


# #creating ec2
#           #local_name    #resource_name
# resource "aws_instance" "ec2_instance" {
#   ami           = data.aws_ami.ami_name.id #data-source 
#   instance_type = var.instance_type

#   tags = {
#     Name = "ec2_Instance"
#   }
# }

# ##data source to pull down avaialbe/existing resource in aws 
# ## how to pull a reosurce using data source # -target 
# # data "aws_availability_zones" "available" {
# #   state = "available"
# # }

# ##data source ami_id
# data "aws_ami" "ami_name" {
#   most_recent      = true
#   owners           = ["amazon"]

#   filter {
#     name   = "name"
#     values = ["amzn2-ami-hvm*"]
#   }
# }

