# docs: https://www.terraform-best-practices.com/naming#code-examples-of-output

output "ecr_name" {
  description = "The Name of the ECR repository"
  value       = try(aws_ecr_repository.this.name, "")
}

output "ecr_url" {
  description = "The Url of the ECR repository"
  value       = try(aws_ecr_repository.this.repository_url, "")
}