resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.prod-vpc.id

    tags = {
        Name = "Internet Gateway in Public Subnet"
    }
}

resource "aws_subnet" "publicSubnet-1" {
  vpc_id            = aws_vpc.prod-vpc.id
  cidr_block        = "10.0.15.0/24"
  availability_zone = var.zone1

  tags = {
    Name = "publicSubnet-1"
  }
}


resource "aws_subnet" "publicSubnet-2" {
  vpc_id            = aws_vpc.prod-vpc.id
  cidr_block        = "10.0.25.0/24"
  availability_zone = var.zone2

  tags = {
    Name = "publicSubnet-2"
  }
}
