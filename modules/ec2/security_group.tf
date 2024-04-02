resource "aws_security_group" "bastion-sg" {
  name   = "${var.project_name}-${var.env}-bastion-sg"
  vpc_id = var.vpc_id
  tags   = {
    Name = "${var.project_name}-${var.env}-bastion-sg"
    env  = var.env
  }
}

resource "aws_security_group_rule" "bastion-out-all-accept" {
  security_group_id = aws_security_group.bastion-sg.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  description       = "every"
  cidr_blocks       = ["0.0.0.0/0"]
}