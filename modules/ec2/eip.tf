resource "aws_eip" "bastion-a-eip" {
  instance = aws_instance.bastion-a.id
  tags = {
    Name = "${var.project_name}-${var.env}-bastion-a-eip"
    env = var.env
  }
}
