resource "aws_security_group" "rds_all" {
  name   = "${var.project.name}-${var.project.env}-rds-all-sg"
  vpc_id = var.vpc.id

  ingress {
    description = "all"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
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
