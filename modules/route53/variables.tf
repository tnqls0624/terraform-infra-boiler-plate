# Project
variable "projects" {
  description = <<EOT
  Project configurations:
  - `env`: The environment in which the infrastructure is deployed
  - `name`: The name of the project
  - `sub_name`: The SubName of the project
  EOT

  type = map(object({
    sub_name : string
  }))
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

# VPC
variable "vpc" {
  description = <<EOT
  VPC configurations:
  - `id`: The ID of the VPC
EOT

  type = object({
    id : string
  })
}

# Route 53
variable "route53" {
  description = <<EOT
  Route 53 configurations:
  - `name`: The name of the Route 53 Hosted Zone
EOT

  type = object({
    name : string
  })
}

# ALB
variable "alb" {
  description = <<EOT
  ALB configurations:
  - `dns_names`: The DNS name of the ALB
EOT

  type = map(object({
    dns_name : string
  }))
}

variable "env" {
  description = "The environment in which the infrastructure is deployed"
  type        = string
}

