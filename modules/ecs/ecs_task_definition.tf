locals {
  ecs_container_names = "${var.name}-${var.project.sub_name}-container-${var.env}"
}

# docs: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html
resource "aws_ecs_task_definition" "this" {
  family             = "${var.name}-${var.project.sub_name}-task-${var.env}"
  network_mode       = "awsvpc"
  task_role_arn      = var.ecs_task_execution_arn
  execution_role_arn = var.ecs_task_execution_arn

  cpu    = var.container.cpu
  memory = var.container.memory

  requires_compatibilities = ["FARGATE"]

  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }

  skip_destroy = false

  container_definitions = jsonencode([
    {
      name         = local.ecs_container_names,
      image        = "${var.ecr.url}:latest",
      cpu          = var.project.cpu,
      memory       = var.project.memory,
      // 'environment' 섹션은 필요에 따라 구성
      environment  = [{ "name" : "PROFILE", "value" : var.env }],
      portMappings = [
        {
          containerPort = var.project.alb_container_port,
          hostPort      = var.project.alb_container_port,
          protocol      = "tcp"
        }
      ],
      logConfiguration = {
        logDriver = "awslogs",
        options   = {
          "awslogs-create-group"  = "true",
          "awslogs-group"         = "/ecs/${var.name}-${var.project.sub_name}-task-${var.env}",
          "awslogs-region"        = var.aws_config.region,
          "awslogs-stream-prefix" = "ecs"
        }
      },
      essential = true
    }
  ])
}


