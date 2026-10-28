
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket       = "github-s3-demo-2026 "
    key          = "s3-demo/terraform.tfstate"
    region       = "ap-south-1"
    encrypt      = true
    use_lockfile = true
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "ap-south-1"
}

# 1. Create the S3 Bucket
resource "aws_s3_bucket" "my_bucket" {
  bucket        = "github-action-2026-unique"
  force_destroy = false

  tags = {
    Name        = "My github action Bucket"
    Environment = "Dev"
  }
}

# 2. Enable Bucket Versioning
resource "aws_s3_bucket_versioning" "my_bucket_versioning" {
  bucket = aws_s3_bucket.my_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# 3. Enable Server-Side Encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "my_bucket_encryption" {
  bucket = aws_s3_bucket.my_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# 4. Block All Public Access
resource "aws_s3_bucket_public_access_block" "my_bucket_public_block" {
  bucket = aws_s3_bucket.my_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# 5. Output the Bucket Name
output "bucket_name" {
  value       = aws_s3_bucket.my_bucket.id
  description = "The name of the bucket"
}

# 6. Output the Bucket ARN
output "bucket_arn" {
  value       = aws_s3_bucket.my_bucket.arn
  description = "The ARN of the bucket"
}
