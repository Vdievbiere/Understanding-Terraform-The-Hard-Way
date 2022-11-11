locals{
    azs = data.aws_availability_zones.available.names
}

# create a VPC
resource "aws_vpc" "this" {
  cidr_block = "10.0.0.0/16"
}

## two public subnets, 2 private subnet, 2 databasesubnet (using count)
resource "aws_subnet" "public_subnet" {
    count = 2
  vpc_id     = aws_vpc.this.id
  cidr_block = var.public_cidr[count.index]
  availability_zone = [local.azs[0], local.azs[1]][count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet_${count.index + 1}"
  }
}

#create 2private_subnets
resource "aws_subnet" "private_subnet" {
    count = 2
  vpc_id     = aws_vpc.this.id
  cidr_block = var.private_cidr[count.index]
  availability_zone = [local.azs[0], local.azs[1]][count.index]
 
  tags = {
    Name = "private_subnet_${count.index + 1}"
  }
}

## and database subnet
resource "aws_subnet" "database_subnet" {
    count = 2
  vpc_id     = aws_vpc.this.id
  cidr_block = var.database_cidr[count.index]
  availability_zone = [local.azs[0], local.azs[1]] [count.index]

  tags = {
     #format("Hello, %s!", "Ander")
     Name = format("database_subnet_%s", count.index + 1)
    # Name = "database_subnet_${count.index + 1}"
  }
}