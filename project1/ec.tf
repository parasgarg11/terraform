resource "aws_instance" "EC-1_public" {
  ami                    = var.image
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.publicSubnet-1.id
  depends_on = [
    aws_security_group.allow_web_sg
  ]
  vpc_security_group_ids = [aws_security_group.allow_web_sg.id]
  key_name               = var.keyName

  tags = {
    Name = "Public EC2-1"
  }
}

# resource "aws_instance" "EC-2_public" {
#   ami                    = var.image
#   instance_type          = "t2.micro"
#   subnet_id              = aws_subnet.publicSubnet-2.id
#   vpc_security_group_ids = ["aws_security_group.allow_web_sg.id"]
#   # key_name               = var.keyName

#   tags = {
#     Name = "Public EC2-2"
#   }
# }

# resource "aws_instance" "EC-1_private" {
#   ami                    = var.image
#   instance_type          = "t2.micro"
#   subnet_id              = aws_subnet.privateSubnet-1.id
#   vpc_security_group_ids = ["aws_security_group.allow_web_sg.id"]
#   # key_name               = var.keyName

#   tags = {
#     Name = "Private EC2-1"
#   }
# }


# resource "aws_instance" "EC-2_private" {
#   ami                    = var.image
#   instance_type          = "t2.micro"
#   subnet_id              = aws_subnet.privateSubnet-2.id
#   vpc_security_group_ids = ["aws_security_group.allow_web_sg.id"]
#   # key_name               = var.keyName

#   tags = {
#     Name = "Private EC2-2"
#   }
# }
