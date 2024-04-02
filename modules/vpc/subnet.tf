locals {
  public_subnets = {
    # `public_a` is Required Subnet
    "public_a" = {
      cidr              = var.vpc_config.public_subnet_a
      availability_zone = var.aws_config.region_a
    }
    "public_b" = {
      cidr              = var.vpc_config.public_subnet_b
      availability_zone = var.aws_config.region_b
    }
  }

  private_subnets = {
    "private_a" = {
      cidr              = var.vpc_config.private_subnet_a
      availability_zone = var.aws_config.region_a
    }
    "private_b" = {
      cidr              = var.vpc_config.private_subnet_b
      availability_zone = var.aws_config.region_b
    }
  }
}

resource "aws_subnet" "public" {
  for_each = local.public_subnets

  vpc_id     = aws_vpc.this.id # 위에서 생성한 vpc 별칭 입력
  cidr_block = each.value.cidr # IPv4 CIDER 블럭

  availability_zone       = each.value.availability_zone # 가용영역 지정
  map_public_ip_on_launch = true #퍼블릭 IP 자동 부여 설정

  tags = {
    Name = "${var.project.name}-${var.project.env}-${each.key}"
    env  = var.project.env
  } #태그 설정
}

resource "aws_subnet" "private" {
  for_each = local.private_subnets

  vpc_id     = aws_vpc.this.id # 위에서 생성한 vpc 별칭 입력
  cidr_block = each.value.cidr # IPv4 CIDER 블럭

  availability_zone       = each.value.availability_zone # 가용영역 지정
  map_public_ip_on_launch = false # 퍼블릭 IP 부여를 하지 않습니다.

  tags = {
    Name = "${var.project.name}-${var.project.env}-${each.key}"
    env  = var.project.env
  } #태그 설정
}
