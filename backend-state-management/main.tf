

#################################################
# CREATE ANE S3 BUCKET FOR STATEFILE MANAGEMENT 
################################################

resource "aws_s3_bucket" "this"{
    count = length(var.bucket_name)
    bucket = var.bucket_name[count.index]
    lifecycle {
        prevent_destroy = true
    }
  tags = {
    Name        = "my_bucket"
    Environment = "dev"
  }

}


################################################
#CREATE AN S#3 BUCKET FOR STATEFILE MANAGEMENT
############################################

resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = "terraform-lock"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "LockID"
 
  attribute {
    name = "LockID"
    type = "S"
  }

  lifecycle {
    prevent_destroy = true
  }

}

  
  