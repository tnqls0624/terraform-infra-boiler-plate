# Project
variable "env" {
  description = "The environment in which the infrastructure is deployed"
  default     = "dev"
  type        = string
}

variable "project_name" {
  description = "The name of the project"
  default     = "test"
  type        = string
}

variable "account_id" {
  description = "The aws of the account id"
  default     = ""
  type        = string
}

variable "repo_owner" {
  description = "The name of the project"
  default     = "tnqls0624"
  type        = string
}

variable "branch_name" {
  description = "The name of the Remote Repository branch"
  default     = "dev"
  type        = string
}

variable "projects" {
  description = "Configuration for each project"
  type        = map(object({
    sub_name           = string
    alb_container_port = number
    cpu                = number
    memory             = number
    repo_name          = string
  }))
  default = {
    #    "project2" = {
    #      name               = "test"
    #      sub_name           = "project"
    #      env                = "dev"
    #      region             = "ap-northeast-2"
    #      hosted_zone_name   = "example.org"
    #      alb_container_port = 8081
    #    }
    # 추가 프로젝트 구성
  }
}

# Region
variable "region" {
  description = "The AWS region to deploy to"
  default     = "ap-northeast-2"
  type        = string
}

variable "region_a" {
  description = "The Subnet Availability Zone A"
  default     = "ap-northeast-2a"
  type        = string
}

variable "region_b" {
  description = "The Subnet Availability Zone B"
  default     = "ap-northeast-2c"
  type        = string
}

# VPC
variable "cidr_block" {
  description = "The CIDR block for the VPC"
  default     = "10.110.0.0/16"
  type        = string
}

# Subnet
variable "public_subnet_a" {
  description = "The Public Subnet Area A"
  default     = "10.110.1.0/24"
  type        = string
}

variable "public_subnet_b" {
  description = "The Public Subnet Area B"
  default     = "10.110.2.0/24"
  type        = string
}

variable "private_subnet_a" {
  description = "The Private Subnet Area A"
  default     = "10.110.3.0/24"
  type        = string
}

variable "private_subnet_b" {
  description = "The Private Subnet Area B"
  default     = "10.110.4.0/24"
  type        = string
}

# Route 53
variable "hosted_zone_name" {
  description = "The name of the Route 53 Hosted Zone"
  default     = "test.com"
  type        = string
}

# Container
variable "container_port" {
  description = "The port on which the container listens"
  default     = 80
  type        = number
}

variable "container_cpu" {
  description = "The number of CPU units used by the task"
  default     = 2048
  type        = number
}

variable "container_memory" {
  description = "The amount of memory (in MiB) used by the task"
  default     = 4096
  type        = number
}

# ElastiCache
variable "num_cache_clusters" {
  description = "The number of cache clusters to Redis"
  default     = 2
  type        = number
}

variable "elasticache_port" {
  description = "The port of the elasticache"
  default     = 6379
  type        = number
}

# RDS
variable "rds_public_access" {
  type = bool
  default = true
}