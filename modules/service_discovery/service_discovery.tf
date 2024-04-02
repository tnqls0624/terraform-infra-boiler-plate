resource "aws_service_discovery_http_namespace" "this" {
  name        = "${var.name}-ecs-cluster-${var.env}"
  description = "HTTP Namespace for ${var.name}-${var.env}"

  tags = {
    name    = "${var.name}-ns-${var.env}"
    env     = var.env
    project = var.name
    AmazonECSManaged = "true"
  }
}