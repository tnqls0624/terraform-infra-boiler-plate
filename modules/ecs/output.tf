# ECS
output "ecs_service_id" {
  description = "The ID of the ECS service"
  value       = aws_ecs_service.this.id
}

output "ecs_service_name" {
  description = "The name of the ECS service"
  value       = aws_ecs_service.this.name
}

output "ecs_cluster_name" {
  description = "The name of the ECS cluster"
  value       = aws_ecs_cluster.this.name
}

output "container_name" {
  description = "The name of the container"
  value       = local.ecs_container_names
}
