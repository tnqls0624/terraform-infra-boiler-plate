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