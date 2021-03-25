resource "aws_security_group" "allow_web_sg" {
  name        = "allow_web-traffic"
  description = "Allow Web inbound traffic"
  vpc_id      = aws_vpc.prod-vpc.id

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress { //we allowing all ports in egress dir.  
    from_port   = 0
    to_port     = 0
    protocol    = "-1" //for any protocol
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_web-sg"
  }
}

resource "aws_route_table_association" "private-1" {
  subnet_id = aws_subnet.privateSubnet-1.id
  route_table_id = aws_route_table.rt_private.id
}

resource "aws_route_table_association" "private-2" {
  subnet_id = aws_subnet.privateSubnet-2.id
  route_table_id = aws_route_table.rt_private.id
}
