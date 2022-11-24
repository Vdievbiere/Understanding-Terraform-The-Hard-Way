
output "vpc_id" {
  value = aws_vpc.this.id
}

# output "instance_ips" {
#   value = aws_instance.web.*.public_ip
# }

# output "lb_address" {
#   value = variable "dns_name" 
# }

# output "password" {
#   sensitive = true
#   value = var.secret_password
# }
