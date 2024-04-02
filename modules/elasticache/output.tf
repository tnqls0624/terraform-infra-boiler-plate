output "elastic_cache_host" {
  description = "The hostname of the Elasticache instance"
  value       = aws_elasticache_replication_group.this.primary_endpoint_address
}

output "elastic_cache_port" {
  description = "The port of the Elasticache instance"
  value       = aws_elasticache_replication_group.this.port
}
