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
    cpu                = number
    memory             = number
  })
}

variable "namespace_id" {
  description = "The Service Discovery Namespace ID"
  type        = string
}

variable "ecs_security_group_id" {
  description = "The ECS of Security Group ID"
  type        = string
}

variable "ecs_task_execution_arn" {
  description = "The arn of the ecs_task_execution"
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

# ECR
variable "ecr" {
  description = <<EOT
  ECR configurations:
  - `name`: The Name of the ECR
EOT

  type = object({
    name : string
    url : string
  })
}

# ALB
variable "alb" {
  description = <<EOT
  ALB configurations:
  - `target_group_arn`: The ARN of the target group
EOT

  type = object({
    target_group_arn : string
  })
}

# Container
variable "container" {
  description = <<EOT
  Container configurations:
  - `port`: The port on which the container listens
  - `cpu`: The number of CPU units used by the task
  - `memory`: The amount of memory (in MiB) used by the task
EOT

  type = object({
    cpu : number
    memory : number
    port : number
  })
}

