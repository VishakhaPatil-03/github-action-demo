# Configure the AWS Provider
provider "aws" {
  region = "ap-south-1" # Change to your preferred region
}

# 1. Create the S3 Bucket
resource "aws_s3_bucket" "my_bucket" {
  bucket        = "github-action-2026" # S3 bucket names must be globally unique
  force_destroy = false                         # Prevents Terraform from deleting a bucket that contains objects

  tags = {
    Name        = "My github action Bucket"
    Environment = "Dev"
  }
}

# 2. Enable Bucket Versioning (Highly Recommended)
resource "aws_s3_bucket_versioning" "my_bucket_versioning" {
  bucket = aws_s3_bucket.my_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# 3. Enable Server-Side Encryption (Best Practice)
resource "aws_s3_bucket_server_side_encryption_configuration" "my_bucket_encryption" {
  bucket = aws_s3_bucket.my_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# 4. Block All Public Access (Security Best Practice)
resource "aws_s3_bucket_public_access_block" "my_bucket_public_block" {
  bucket = aws_s3_bucket.my_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Output the Bucket Name and ARN
output "bucket_name" {
  value       = aws_s3_bucket.my_bucket.id
  description = "The name of the bucket"
}

output "bucket_arn" {
  value       = aws_s3_bucket.my_bucket.arn
  description = "The ARN of the bucket"
}
