

###Creating Variable - be descriptive in naming your variables
variable "ami_id"{
    type =string
    description = "ami id"
    default= "ami-09d3b3274b6c5d4aa"
}

variable "instance_type"{
    type =string
    description = "instance type"
    default= "t2.micro"
}

##VPC Cidr Block
variable "cidr" {
  description = "(Optional) The IPv4 CIDR block for the VPC. CIDR can be explicitly set or it can be derived from IPAM using `ipv4_netmask_length` & `ipv4_ipam_pool_id`"
  type        = string
  default     = "10.0.0.0/16"
}

# variable "subnet_cidr"{
#   description = "subnet cidr blocks"
#   type        = list
#   default     =[ "10.0.1.0/24","10.0.3.0/24","10.0.5.0/24","10.0.7.0/24"]
  
# }

variable "private_cidr"{
  description = "subnet cidr blocks"
  type        = list
  default     =["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  
}

variable "public_cidr"{
  description = "subnet cidr blocks"
  type        = list
  default     =["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  
}