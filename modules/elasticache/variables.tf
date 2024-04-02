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
  - `region_a`: The Availability Zone A
  - `region_b`: The Availability Zone B
EOT

  type = object({
    account_id : string
    region : string
    region_a : string
    region_b : string
  })
}

# VPC Config
variable "vpc" {
  description = <<EOT
  VPC configurations:
  - `id` = The VPC ID
  - `subnet_ids` = The subnet IDs to deploy to
EOT

  type = object({
    id : string
    subnet_ids : list(string)
  })
}


# ElastiCache Config
variable "elasticache" {
  description = <<EOT
  ElastiCache configurations:
  - `port`: The port to use for Redis
  - `num_cache_clusters`: The number of cache clusters to Redis
EOT

  type = object({
    port : number
    num_cache_clusters : number
  })
}
