## Step-01: Introduction
- Understand basic Terraform Commands
  - terraform init
  - terraform validate
  - terraform plan
  - terraform apply
  - terraform destroy
  - terraform console
  -terraform refresh


# """"""

# " " :> string
# [] = list 
# 80 = number 
# bool = true/false 
# {}  =  map 

# ### complicated
# [""] => list(string)
# [{}] => list(map)
# {[]} => map(list)
# """""


## use element to achieve this - it will assign the first Ip for us-east 1
## ["us-east-1a", "us-east-1b", "us-east-1a", "us-east-1b", "us-east-1a", "us-east-1b"]
## ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
