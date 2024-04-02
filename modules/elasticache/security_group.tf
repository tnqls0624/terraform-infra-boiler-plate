resource "aws_security_group" "elasticache" {
  name   = "${var.project.name}-redis-sg-${var.project.env}"
  description = "${var.project.name}-redis-sg-${var.project.env}"

  vpc_id = var.vpc.id

  ingress {
    description = "redis"
    from_port   = var.elasticache.port
    to_port     = var.elasticache.port
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
