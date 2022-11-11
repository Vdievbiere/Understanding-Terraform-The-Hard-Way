#create 5 instances with window ami, 3 ubuntu ami. with the concept of for each 
#for_each 

# ["ami-09d3b3274b6c5d4aa", "ami-08c40ec9ead489470"]
#count it support list
#for_each would map 


resource "aws_instance" "frontend" {
    count=5
  ami           = ["ami-09d3b3274b6c5d4aa", "ami-08c40ec9ead489470"]
  instance_type = "t3.micro"

  tags = {
    Name = "HelloWorld"
  }
}

locals{
    frontend_instance =
}