## ALL IDS FOR COUNT ONLY
output "public_subnet_ids" {
   value = [for x in aws_subnet.public_subnet: x.id]
}

output "private_subnet_ids" {
   value = [for each_id in aws_subnet.private_subnet: each_id.id]
}

output "database_subnet_ids" {
   value = [for each_id in aws_subnet.database_subnet: each_id.id]
}

### Output I subenet ID  FOR EACH ###
output "public_subnet1_ids" {
   value = aws_subnet.public_subnet["public_subnet_1"].id
}
