resource "aws_default_route_table" "default" {
  default_route_table_id = aws_vpc.this.default_route_table_id

  tags = {
    env  = var.project.env
    Name = "${var.project.name}-${var.project.env}-default-rt"
  }
}

resource "aws_route" "default" {
  route_table_id         = aws_default_route_table.default.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id # IGW 연결
}

resource "aws_route_table" "public" {
  for_each = local.public_subnets

  vpc_id = aws_vpc.this.id

  tags = {
    env  = var.project.env
    Name = "${var.project.name}-${var.project.env}-${each.key}-rt"
  }
}

resource "aws_route" "public" {
  for_each = local.public_subnets

  route_table_id         = aws_route_table.public[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id # IGW 연결
}

resource "aws_route_table" "private" {
  for_each = local.private_subnets

  vpc_id = aws_vpc.this.id

  tags = {
    env  = var.project.env
    Name = "${var.project.name}-${var.project.env}-${each.key}-rt"
  }
}

resource "aws_route" "private" {
  for_each = local.private_subnets

  route_table_id         = aws_route_table.private[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_a.id #NAT Gateway 별칭 입력
}

