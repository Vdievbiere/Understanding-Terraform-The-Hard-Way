# ## ###Output IP address
# output "private_ip" { value = "${aws_instance.ec2_instance.private_ip}" }
# output "public_ip"  { value = "${aws_instance.ec2_instance.public_ip}" }
# output "private_dns" {
#   description = "private dns id"
#   value = aws_instance.ec2_instance.private_dns
# }

output "vpc_id" {
  description = "vpc id"
  value = module.vpc.vpc_id  ##since we are using module we have to call the module the source  + resource name and the logical name.to get logical name go to main.tf of the root module.
}


