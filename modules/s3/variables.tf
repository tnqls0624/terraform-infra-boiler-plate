# Project
variable "env" {
  description = "The environment in which the infrastructure is deployed"
  default     = "dev"
  type        = string
}

variable "name" {
  description = "The name of the project"
  default     = "i-api"
  type        = string
}

variable "project" {
  description = <<EOT
  AWS configurations:
  - `sub_name`: The Project SubName
EOT
  type        = object({
    sub_name           = string
  })
}

# AWS Config
variable "aws_config" {
  description = <<EOT
  AWS configurations:
  - `region`: The AWS region to deploy to
  - `account_id`: The AWS account ID
EOT

  type = object({
    region : string
    account_id : string
  })
}

# S3
variable "s3" {
  description = <<EOT
  S3 configurations:
  - `mode`: S3 buckets permission "Private" or "Public"
  - `names`: The names of the S3 buckets
EOT

  type = object({
    mode : string
    names : list(string)
  })
}

