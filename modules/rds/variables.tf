# Project
variable "project" {
  description = <<EOT
  Project configurations:
  - `env`: The environment in which the infrastructure is deployed
  - `name`: The name of the project
  EOT

  type = object({
    env : string
    name : string
  })
}

# AWS Config
variable "aws_config" {
  description = <<EOT
  AWS configurations:
  - `account_id`: The AWS account ID
  - `region`: The AWS region to deploy to
  - `region_a`: The Subnet Availability Zone A
  - `region_b`: The Subnet Availability Zone B
EOT

  type = object({
    account_id : string
    region : string
    region_a : string
    region_b : string
  })
}

# VPC
variable "vpc" {
  description = <<EOT
  VPC configurations:
  - `id`: The ID of the VPC
  - `subnet_ids` = The subnet IDs to deploy to
EOT

  type = object({
    id : string
    subnet_ids : list(string)
  })
}

variable "rds" {
  description = <<EOT
  VPC configurations:
  - `public_access` = The public_access
EOT

  type = object({
    public_access : bool
  })
}
