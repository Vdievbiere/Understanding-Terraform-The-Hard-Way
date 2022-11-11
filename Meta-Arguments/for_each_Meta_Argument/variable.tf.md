
variable "public_cidr"{
    type=list
    description = "public subnet cidrs"
    default = ["10.0.0.0/24", "10.0.2.0/24"]
}

variable "private_cidr"{
    type=list
    description = "public subnet cidrs"
    default = ["10.0.1.0/24", "10.0.3.0/24"]
}

variable "private_cidr"{
    type=list
    description = "public subnet cidrs"
    default = ["10.0.1.0/24", "10.0.3.0/24"]
}