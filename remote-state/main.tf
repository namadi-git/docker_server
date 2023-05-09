provider "aws" {
  region = "us-east-2"
  profile= "nelson_admin_profile"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "nelson-docker-tfstate"
     
  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_s3_bucket_versioning" "terraform_state" {
    bucket = aws_s3_bucket.terraform_state.id

    versioning_configuration {
      status = "Enabled"
    }
}

resource "aws_dynamodb_table" "terraform_state_lock" {
  name           = "tf-state"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
