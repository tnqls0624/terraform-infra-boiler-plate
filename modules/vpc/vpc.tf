resource "aws_vpc" "this" {
  cidr_block = var.vpc_config.cidr_block #VPC_CIDR

  enable_dns_hostnames = true #DNS Hostname 사용 옵션, 기본은 false

  tags = {
    Name = "${var.project.name}-${var.project.env}-vpc"
    env  = var.project.env
  } #tag 입력
}
