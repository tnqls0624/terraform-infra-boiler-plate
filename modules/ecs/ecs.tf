resource "aws_ecs_cluster" "this" {
  name = "${var.name}-ecs-cluster-${var.env}"

  configuration {
    execute_command_configuration {
      logging = "DEFAULT"
    }
  }

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    name = "${var.name}-ecs-cluster-${var.env}"
    env  = var.env
  }
}

# docs: https://docs.aws.amazon.com/ko_kr/AmazonECS/latest/developerguide/cluster-capacity-providers.html
resource "aws_ecs_cluster_capacity_providers" "this" {
  cluster_name = aws_ecs_cluster.this.name

  capacity_providers = [
    "FARGATE",
    "FARGATE_SPOT",
  ]
}

resource "aws_service_discovery_service" "this" {
  name = "${var.name}-${var.project.sub_name}"

  namespace_id = var.namespace_id

  health_check_custom_config {
    failure_threshold = 1
  }

  tags = {
    Name = "${var.name}-${var.project.sub_name}-${var.env}"
    env  = var.env
  }
}


resource "aws_ecs_service" "this" {
  name            = "${var.name}-${var.project.sub_name}-service-${var.env}"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = 2

  service_registries {
    registry_arn   = aws_service_discovery_service.this.arn
    container_name = local.ecs_container_names
  }

  enable_ecs_managed_tags           = true
  health_check_grace_period_seconds = 0
  propagate_tags                    = "TASK_DEFINITION"

  capacity_provider_strategy {
    capacity_provider = "FARGATE"
    base              = 1
    weight            = 1
  }

  deployment_controller {
    type = "ECS"
  }

  network_configuration {
    security_groups = [var.ecs_security_group_id]
    subnets         = var.vpc.subnet_ids
  }

  load_balancer {
    target_group_arn = var.alb.target_group_arn
    container_name   = local.ecs_container_names
    container_port   = var.project.alb_container_port
  }

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  lifecycle {
    ignore_changes = [
      task_definition,
    ]
  }
}

