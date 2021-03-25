resource "aws_subnet" "privateSubnet-1" {
  vpc_id            = aws_vpc.prod-vpc.id
  cidr_block        = "10.0.100.0/24"
  availability_zone = var.zone1

  tags = {
    Name = "privateSubnet-1"
  }
}

resource "aws_subnet" "privateSubnet-2" {
  vpc_id            = aws_vpc.prod-vpc.id
  cidr_block        = "10.0.200.0/24"
  availability_zone = var.zone2

  tags = {
    Name = "privateSubnet-2"
  }
}