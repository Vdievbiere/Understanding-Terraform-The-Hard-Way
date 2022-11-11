

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ami" "ami" {
  most_recent      = true
  owners           = ["amazon"] # for golden ami you put "self"

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-*-gp2"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

locals {
    azs = data.aws_availability_zones.available.names

## map of map
    public_subnet = {
        public_subnet_1 = {
             #key          #value
            cidr_block = "10.0.0.0/24"
            availability_zone = local.azs[0]
        }
        public_subnet_2 = {
             #key          #value
            cidr_block = "10.0.2.0/24"
            availability_zone = local.azs[1]
        }
    }

## map of map
    private_subnet = {
        private_subnet_1 = {
             #key          #value
            cidr_block = "10.0.1.0/24"
            availability_zone = local.azs[0]
        }
        private_subnet_2 = {
             #key          #value
            cidr_block = "10.0.3.0/24"
            availability_zone = local.azs[1]
        }
    }

## map of map
    database_subnet = {
        database_subnet_1 = {
             #key          #value
            cidr_block = "10.0.4.0/24"
            availability_zone = local.azs[0]
        }
        database_subnet_2 = {
             #key          #value
            cidr_block = "10.0.6.0/24"
            availability_zone = local.azs[1]
        }
    }


## to do
# ## map of list
#     public_subnet_map_of_list = {
#         public_subnet_1 = {
#              #key          #value
#             cidr_block = "10.0.1.0/24"
#             availability_zone = local.azs[0]
#         }
#         public_subnet_2 = {
#              #key          #value
#             cidrP_block = "10.0.3.0/24"
#             availability_zone = local.azs[1]
#         }
#     }

}


# Create a VPC
resource "aws_vpc" "this" {
  cidr_block = "10.0.0.0/16"
}

## create 2 public subnets, 2 private subnets, 2 database subnets (using count)
# 6

resource "aws_subnet" "public_subnet" {
    for_each = local.public_subnet

  vpc_id     = aws_vpc.this.id
                           #key
  cidr_block = each.value.cidr_block 
                                   #key
  availability_zone = each.value.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name = each.key
  }
  
}

resource "aws_subnet" "private_subnet" {
    for_each = local.private_subnet

  vpc_id     = aws_vpc.this.id
                           #key
  cidr_block = each.value.cidr_block 
                                   #key
  availability_zone = each.value.availability_zone

  tags = {
    Name = each.key
  }
  
}

resource "aws_subnet" "database_subnet" {
    for_each = local.database_subnet

  vpc_id     = aws_vpc.this.id
                           #key
  cidr_block = each.value.cidr_block 
                                   #key
  availability_zone = each.value.availability_zone

  tags = {
    Name = each.key
  }
  
}





## exemple  of concatenation : Name = "public_subnet_${count.index + 1}"
##                                      "eli_${count.index + 1}"

## create private_subnet and database susbnet

### FOR EACH USING VARIABLES (USED WHEN WORKINGWITH MODULES)

# variable "private_subnet" {
#   type = mapdescription = ""
#   default = {
#     private_subnet = {
#       kojitechs_private_subnet1 = {
#         cidr_block = "10.0.1.0/24"
#         availability_zone = "us-east-1a"
#       }
#       kojitechs_private_subnet2 = {
#         cidr_block = "10.0.1.0/24"
#         availability_zone = "us-east-1b"
#       }
#     }
#   }
#  } 



## CREATE OUR EC2 INSTANCE
resource "aws_instance" "web" {
  ami           = data.aws_ami.ami.id
  instance_type = "t2.micro"
  subnet_id = aws_subnet.public_subnet["public_subnet_1"].id

  tags = {
    Name = "Eli_test"
  }
}
