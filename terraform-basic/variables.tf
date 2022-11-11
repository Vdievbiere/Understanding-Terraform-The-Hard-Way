#### variables ( type of variables )

# creating var

variable "ami_id" { 
    type = string
    description = "ami_id"
    default = "ami-09d3b3274b6c5d4aa"
}

variable "cidr_block" { 
    type = string
    description = "cidr_block"
    default = "10.0.0.0/16"
}

variable "instance_type" { 
    type = string
    description = "instance_type"
    default = "t2.micro"
}

# variable "subnet_cidr" {
#     type = list
#     description = "subnet_cidr"
#     default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24",  "10.0.6.0/24" ]
#  }

# variable "subnet_cidr_pub1" {
#     type = string
#     description = subnet_cidr_pub1
#     default = "10.0.1.0/24"
#  }

variable "private_subnets" { 
    type = list(any)
    default = ["10.0.1.0/24", "10.0.3.0/24", "10.0.5.0/24"]  # list variable
}

variable "public_subnets" { 
    type = list(any)
    default = ["10.0.2.0/24", "10.0.4.0/24", "10.0.6.0/24"]  # list variable
}


# variable "create_vpc" {
#     type = bool
#     description = "optional to create vpc"
#     default = true 
#  }