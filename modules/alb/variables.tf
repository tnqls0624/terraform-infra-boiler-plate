# Project
variable "projects" {
  description = <<EOT
  Project configurations:
  - `env`: The environment in which the infrastructure is deployed
  - `name`: The name of the project
  - `sub_name`: The sub_name of the project
 - `alb_container_port`: The alb_container_port of the project
  EOT

  type = map(object({
    sub_name : string
    alb_container_port : string
  }))
}

# AWS Config
variable "aws_config" {
  description = <<EOT
  AWS configurations:
  - `account_id`: The AWS account ID
  - `region`: The AWS region to deploy to
EOT

  type = object({
    account_id : string
    region : string
  })
}

# VPC Config
variable "vpc" {
  description = <<EOT
  VPC configurations:
  - `id` = The ID of the VPC
  - `subnet_ids` = The subnet IDs to deploy to
EOT

  type = object({
    id : string
    subnet_ids : list(string)
  })
}

# Route 53
variable "route53" {
  description = <<EOT
  Route 53 configurations:
  - `hosted_zone_name`: The name of the Route 53 Hosted Zone
EOT

  type = object({
    hosted_zone_name : string
  })
}

# Container
variable "container" {
  description = <<EOT
  Container configurations:
  - `port`: The port on which the container listens
EOT

  type = object({
    port : number
  })
}

variable "env" {
  description = "The environment in which the infrastructure is deployed"
  type        = string
}

variable "name" {
  description = "The name of the project"
  type        = string
}