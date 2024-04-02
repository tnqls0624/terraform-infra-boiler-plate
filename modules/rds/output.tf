output "database_url" {
  description = "The URL for the aurora database"
  value       = "mysql://admin:chltjdals22!@${aws_rds_cluster.this.endpoint}:3306/${var.project.name}"
}

