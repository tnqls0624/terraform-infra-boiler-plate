resource "aws_instance" "bastion-a" {
  ami = var.bastion_ami
  instance_type = var.bastion_instance_type
  subnet_id = var.subnet_id
  iam_instance_profile    = aws_iam_instance_profile.ssm_instance_profile.name
  vpc_security_group_ids = [
    aws_security_group.bastion-sg.id,
  ]
  tags = {
    Name = "${var.project_name}-${var.env}-bastion-a-ec2"
    env = var.env
  }
}
