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
  - `region_a`: The AWS region_A to deploy to
  - `region_b`: The AWS region B to deploy to
EOT

  type = object({
    account_id : string
    region : string
    region_a : string
    region_b : string
  })
}

# VPC Config
variable "vpc_config" {
  description = <<EOT
  VPC configurations:
  - `cidr_block`: The Cidr Block
  - `public_subnet_a`: The Public Subnet Area A
  - `public_subnet_b`: The Public Subnet Area A
  - `private_subnet_a`: The Private Subnet Area A
  - `private_subnet_b`: The Private Subnet Area B
EOT

  type = object({
    cidr_block : string
    public_subnet_a : string
    public_subnet_b : string
    private_subnet_a : string
    private_subnet_b : string
  })
}
