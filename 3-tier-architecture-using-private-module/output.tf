

################################################################################
# ROOT MODULE
################################################################################

# output "vpc_id" {
#   value = aws_vpc.this.id
# }

# output "public_subnets" {
#   value = aws_subnet.public_subnet[*].id
# }

# output "priavate_subnets" {
#   value = aws_subnet.private_subnet[*].id
# }

# output "database_subnets" {
#   value = aws_subnet.database_subnets[*].id
# }

output "dns_name" {
  value = aws_route53_record.www.fqdn
}

