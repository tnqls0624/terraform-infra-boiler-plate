resource "aws_elasticache_parameter_group" "this" {
  name        = "${var.project.name}-${var.project.env}-default-pg"
  description = "Default parameter group for redis 7.0"
  family      = "redis7"
}

resource "aws_elasticache_subnet_group" "this" {
  name       = "${var.project.name}-redis-sbg-${var.project.env}"
  subnet_ids = var.vpc.subnet_ids
}

resource "aws_elasticache_replication_group" "this" {
  replication_group_id = "${var.project.name}-redis-${var.project.env}"
  description          = "${var.project.name}-redis-${var.project.env}"

  engine         = "redis"
  engine_version = "7.0"
  node_type      = "cache.t2.small"
  port           = var.elasticache.port

  num_cache_clusters = var.elasticache.num_cache_clusters

  auto_minor_version_upgrade = "true"
  automatic_failover_enabled = true
  multi_az_enabled           = true

  security_group_ids   = [aws_security_group.elasticache.id]
  parameter_group_name = aws_elasticache_parameter_group.this.name
  subnet_group_name    = aws_elasticache_subnet_group.this.name

  snapshot_retention_limit = 1 // 스냅샷 보존 일수
  snapshot_window          = "01:30-02:30"
  maintenance_window       = "sun:07:00-sun:08:00"

  tags = {
    Name = "${var.project.name}-redis-${var.project.env}"
    Env  = var.project.env
  }
}
