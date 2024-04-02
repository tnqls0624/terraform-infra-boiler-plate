resource "aws_security_group" "ecs" {
  name   = "${var.name}-ecs-sg-${var.env}"
  vpc_id = var.vpc.id

  ingress {
    description = "container"
    from_port   = var.container.port
    to_port     = var.container.port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "all"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
