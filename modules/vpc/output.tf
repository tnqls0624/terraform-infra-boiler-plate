# docs: https://www.terraform-best-practices.com/naming#code-examples-of-output

output "vpc" {
  description = <<EOT
  - `id`: The ID of the VPC
  - `cidr`: The CIDR block of the VPC
EOT
  value       = {
    id   = try(aws_vpc.this.id, "")
    cidr = try(aws_vpc.this.cidr_block, "")
  }
}

output "subnet" {
  description = <<EOT
  Subnet Outputs
  - `public`: public subnets configurations
  - `private`: private subnets configurations
EOT
  value       = {
    public = {
      for k, v in aws_subnet.public : k => {
        id = v.id
      }
    },
    private = {
      for k, v in aws_subnet.private : k => {
        id = v.id
      }
    }
  }
}
