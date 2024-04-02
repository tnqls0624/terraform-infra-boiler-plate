
variable "project_name" {
  type = string
}

variable "env" {
  type = string
}

variable "region" {
  type = string
}

variable "region_a" {
  type = string
}

variable "region_b" {
  type = string
}

variable "bastion_ami" {
  type = string
}

variable "bastion_instance_type" {
  type = string
}

variable "subnet_id" {
  description = "The ID of the subnet where the instance is launched"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}


