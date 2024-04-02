# Project
variable "project" {
  description = <<EOT
  AWS configurations:
  - `sub_name`: The Project SubName
  - `alb_container_port`: The Container Port
  - `cpu`: The ECS Service Cpu
  - `memory`: The ECS Service Memory
EOT
  type        = object({
    sub_name           = string
    alb_container_port = number
    repo_name          = string
  })
}

variable "repo_owner" {
  description = "The Repository Owner"
  type        = string
}

variable "env" {
  description = "The environment in which the infrastructure is deployed"
  type        = string
}

variable "name" {
  description = "The name of the project"
  type        = string
}

variable "iam_code_build_arn" {
  description = "The arn of the Code Build IAM"
  type        = string
}

variable "iam_code_pipeline_arn" {
  description = "The arn of the Code Pipeline IAM"
  type        = string
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

# ECR
variable "ecr" {
  description = <<EOT
  ECR configurations:
  - `name`: The Name of the ECR
EOT

  type = object({
    name : string
  })
}

# ECS
variable "ecs" {
  description = <<EOT
  ECS configurations:
  - `service_name`: The name of the ECS service
  - `cluster_name`: The name of the ECS cluster
EOT

  type = object({
    cluster_name : string
    service_name : string
  })
}

# Container
variable "container" {
  description = <<EOT
  Container configurations:
  - `name`: The Name of the ECS Container
EOT

  type = object({
    name : string
  })
}

# S3
variable "s3" {
  description = <<EOT
  S3 configurations:
  - `bucket_name`: The name of the S3 bucket
EOT

  type = object({
    bucket_name : string
  })
}
