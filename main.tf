provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    # Replace this with your bucket name!
    bucket         = "richjam-terraform-state"
    key            = "global/s3/terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "richjam-terraform-locks"
    encrypt        = true
  }
}

resource "aws_instance" "rjam1" {
  ami           = var.instance_ami
  instance_type = var.instance_type

  tags = {
    Name = var.instance_name
  }
}

resource "aws_kms_key" "jam-state-key" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}

resource "aws_s3_bucket" "richjam-terraform-state" {
  bucket = "richjam-terraform-state"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform-state-enc" {
  bucket = aws_s3_bucket.richjam-terraform-state.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.jam-state-key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_versioning" "terraform-state-versioning" {
  bucket = aws_s3_bucket.richjam-terraform-state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "richjam-terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}