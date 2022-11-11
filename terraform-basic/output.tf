# ## ###Output IP address
# output "private_ip" { value = "${aws_instance.ec2_instance.private_ip}" }
# output "public_ip"  { value = "${aws_instance.ec2_instance.public_ip}" }
# output "private_dns" {
#   description = "private dns id"
#   value = aws_instance.ec2_instance.private_dns
# }


### output values

output "instance_private_ip" {
  description = "instance_private_ip"
  value = aws_instance.ec2_instance.private_ip
}

output "instance_public_ip" {
  description = "instance_public_ip"
  value = aws_instance.ec2_instance.public_ip
}

output "instance_id" {
  description = "instance_id"
  value = aws_instance.ec2_instance.id
}

output "private_dns" {
  description = "private_dns"
  value = aws_instance.ec2_instance.private_dns
}

output "vpc_id" {
    description = "vpc id"
   value = module.vpc.vpc_id  ##since we are using module we have to call the module the source  + resource name and the logical name.to get logical name go to main.tf of the root module.
}

# output "public_subnets_id" {
#    value = module.vpc.public_subnets
# }

# output "private_subnets_id" {
#    value = module.vpc.private_subnets
# }

#latest splatoperator 
output "public_subnets_id" {
   value = aws_subnet.private.*.id #
}

#latest splat operator
output "private_subnets_id" {
   value = aws_subnet.private[*].id
}

## CREATE OUR EC2 INSTANCE
resource "aws_instance" "web" {
  ami           = data.aws_ami.ami.id
  instance_type = "t2.micro"
  subnet_id = aws_subnet.public_subnet["public_subnet_1"].id

  tags = {
    Name = "viv_test"
  }
}



# #output just a single 
# output "private_subnets_id" {
#    value = aws_subnet.prvate[0].id
# }
## for 2 or more subnet is we will use slice 
# #output just a single 
# output "private_subnets_id" {
#    value = aws_subnet.prvate[0].id
# }

# #################################
# # out ALL public subnet IDS in FOR_EACH  - iteration
# #######################
# output "all_public_subnet_ids"
#     value = [for sub in aws_subnet.public: sub.id] # works for both count && for each