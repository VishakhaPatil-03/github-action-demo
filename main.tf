
# -----------------------------------------
# Terraform Configuration
# -----------------------------------------

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "local" {
    path = "/opt/terraform-state/github-action-demo/terraform.tfstate"
  }
}

# -----------------------------------------
# AWS Provider
# -----------------------------------------

provider "aws" {
  region = var.aws_region
}

# -----------------------------------------
# Variables
# -----------------------------------------

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "bucket_name" {
  description = "Globally unique S3 bucket name"
  type        = string
}

# -----------------------------------------
# Create S3 Bucket
# -----------------------------------------

resource "aws_s3_bucket" "my_bucket" {
  bucket = var.bucket_name

  tags = {
    Name        = var.bucket_name
    Environment = "Dev"
    ManagedBy   = "Terraform"
  }
}

# -----------------------------------------
# Enable Bucket Versioning
# -----------------------------------------

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.my_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# -----------------------------------------
# Enable Encryption
# -----------------------------------------

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.my_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# -----------------------------------------
# Block Public Access
# -----------------------------------------

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.my_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# -----------------------------------------
# Outputs
# -----------------------------------------

output "s3_bucket_name" {
  value = aws_s3_bucket.my_bucket.bucket
}

output "s3_bucket_arn" {
  value = aws_s3_bucket.my_bucket.arn
}

output "s3_bucket_region" {
  value = var.aws_region
}
