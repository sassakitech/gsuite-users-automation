variable "prefix" {
  default = "gsuite-automation"
}

variable "region" {
  default = "us-west-2"
}

provider "aws" {
    region = var.region
}

resource "aws_s3_bucket" "remote_state" {
  bucket = "${var.prefix}-terraform-remote-state"
  tags = {
    Name = "S3 Remote Terraform State Store for GSuite automation"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "remote_state_encryption" {
  bucket = aws_s3_bucket.remote_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_acl" "remote_state_acl" {
  bucket = aws_s3_bucket.remote_state.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "remote_state_versioning" {
  bucket = aws_s3_bucket.remote_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "state" {
  bucket              = aws_s3_bucket.remote_state.id
  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "state_lock" {
  name         = "${var.prefix}-terraform-lock-state"
  hash_key     = "LockID"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "DynamoDB Remote Terraform State Lock Table for GSuite automation"
  }
}