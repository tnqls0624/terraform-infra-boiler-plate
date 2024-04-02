variable "env" {
  description = "The environment in which the infrastructure is deployed"
  type        = string
}

variable "name" {
  description = "The name of the project"
  type        = string
}

# VPC Config
variable "vpc" {
  description = <<EOT
  VPC configurations:
  - `id` = The ID of the VPC
EOT

  type = object({
    id : string
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