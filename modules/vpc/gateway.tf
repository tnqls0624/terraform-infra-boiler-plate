# 인터넷 게이트웨이 생성
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id #어느 VPC와 연결할 것인지 지정

  tags = {
    Name = "${var.project.name}-${var.project.env}-igw"
    env  = var.project.env
  }  #태그 설정
}

# NAT 게이트웨이가 사용할 Elastic IP생성_A
resource "aws_eip" "nat_ip_a" {
  tags = {
    Name = "${var.project.name}-${var.project.env}-a-natgw-eip"
    env  = var.project.env
  }
}

# NAT 게이트웨이 생성_A
resource "aws_nat_gateway" "nat_a" {
  allocation_id = aws_eip.nat_ip_a.id #EIP 연결
  subnet_id     = aws_subnet.public["public_a"].id #NAT가 사용될 서브넷 지정

  tags = {
    Name = "${var.project.name}-${var.project.env}-a-nat"
    env  = var.project.env
  }
}
