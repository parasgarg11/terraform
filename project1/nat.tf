resource "aws_eip" "eip" {
  vpc = true
}

resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.eip.id
  subnet_id = aws_subnet.publicSubnet-1.id
}

resource "aws_route_table" "rt_private" {
  vpc_id = aws_vpc.prod-vpc.id
  route {
    cidr_block = "0.0.0.0/0"                
    gateway_id = aws_nat_gateway.natgw.id 
  }
}

resource "aws_route_table_association" "private-us-east-1a" {
  subnet_id = aws_subnet.privateSubnet-1.id
  route_table_id = aws_route_table.rt_private.id
}

resource "aws_route_table_association" "private-us-east-1b" {
  subnet_id = aws_subnet.privateSubnet-2.id
  route_table_id = aws_route_table.rt_private.id
}