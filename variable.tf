# -----------------------------------------
# AWS Region Variable
# -----------------------------------------

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

# -----------------------------------------
# S3 Bucket Name Variable
# -----------------------------------------

variable "bucket_name" {
  description = "Globally unique S3 bucket name"
  type        = string

  validation {
    condition = (
      length(var.bucket_name) >= 3 &&
      length(var.bucket_name) <= 63 &&
      can(regex("^[a-z0-9][a-z0-9-]*[a-z0-9]$", var.bucket_name)) &&
      !can(regex("[0-9]+\\.[0-9]+\\.[0-9]+\\.[0-9]+", var.bucket_name))
    )

    error_message = "Bucket name must be 3-63 characters, lowercase letters, numbers, and hyphens only. It must start and end with a letter or number and cannot be formatted as an IP address."
  }
}
