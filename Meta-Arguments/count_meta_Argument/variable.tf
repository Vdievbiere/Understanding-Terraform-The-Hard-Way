
variable "public_cidr"{
    type=list
    description = "public subnet cidrs"
    default = ["10.0.0.0/24", "10.0.2.0/24"]
}

variable "private_cidr"{
    type=list
    description = "private subnet cidrs"
    default = ["10.0.1.0/24", "10.0.3.0/24"]
}

variable "database_cidr"{
    type=list
    description = "database subnet cidrs"
    default = ["10.0.51.0/24", "10.0.53.0/24"]
}