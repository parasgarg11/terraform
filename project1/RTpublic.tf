resource "aws_route_table" "rt_public" {
  vpc_id = aws_vpc.prod-vpc.id
  route {
    cidr_block = "0.0.0.0/0"                
    gateway_id = aws_internet_gateway.igw.id 
  }
}

resource "aws_route_table_association" "public-us-east-1a" {
  subnet_id = aws_subnet.publicSubnet-1.id
  route_table_id = aws_route_table.rt_public.id
}

resource "aws_route_table_association" "public-us-east-1b" {
  subnet_id = aws_subnet.publicSubnet-2.id
  route_table_id = aws_route_table.rt_public.id
}