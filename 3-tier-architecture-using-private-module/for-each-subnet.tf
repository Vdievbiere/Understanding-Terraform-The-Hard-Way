
# locals {
#     azs = data.aws_availability_zones.available.names

# ## map of map still inside local block
#     public_subnet = {
#         public_subnet_1 = {
#              #key          #value
#             cidr_block = "10.0.0.0/24"
#             availability_zone = local.azs[0]
#         }
#         public_subnet_2 = {
#              #key          #value
#             cidr_block = "10.0.2.0/24"
#             availability_zone = local.azs[1]
#         }
#     }


#     ## map of map still inside local block
#     private_subnet = {
#         private_subnet_1 = {
#              #key          #value
#             cidr_block = "10.0.1.0/24"
#             availability_zone = local.azs[0]
#         }
#        private_subnet_2 = {
#              #key          #value
#             cidr_block = "10.0.3.0/24"
#             availability_zone = local.azs[1]
#         }
#     }

#     ## map of map still inside local block
#     database_subnet = {
#         database_subnet_1 = {
#              #key          #value
#             cidr_block = "10.0.51.0/24"
#             availability_zone = local.azs[0]
#         }
#        database_subnet_2 = {
#              #key          #value
#             cidr_block = "10.0.53.0/24"
#             availability_zone = local.azs[1]
#         }
#     }
# }