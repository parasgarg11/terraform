provider "aws" { //first create a key pair
  region  = "us-east-1"
  profile = "default"
  # access_key = "AKIASHTZ2RJFU6M24KEP"
  # secret_key = "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"
}

# 1. Create VPC
resource "aws_vpc" "prod-vpc" {
  cidr_block = "10.0.0.0/16"
}

# 2. Create Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.prod-vpc.id //Note: not put in ""
}

# 3. Create Custom Route Table(RT)
resource "aws_route_table" "prod-route-table" {
  vpc_id = aws_vpc.prod-vpc.id

  route {
    cidr_block = "0.0.0.0/0"                //send all traffic to the Internet Gateway
    gateway_id = aws_internet_gateway.gw.id // refers to the internet gateway so we use "gw" 
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "public"
  }
}

# 4. Create a subnet
resource "aws_subnet" "subnet-1" {
  vpc_id            = aws_vpc.prod-vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "prod-subnet"
  }
}

# 5. Associate subnet with RT (associate a subnet with RT)
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.prod-route-table.id
}

# 6. Create Security Group to allow port 22,80,443
resource "aws_security_group" "allow-web" {
  name        = "allow_web-traffic"
  description = "Allow Web inbound traffic"
  vpc_id      = aws_vpc.prod-vpc.id

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] //what subnets can actually reach this box we allow anyone or we can specific ip address also
  }
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] //what subnets can actually reach this box we allow anyone or we can specific ip address also
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] //what subnets can actually reach this box we allow anyone or we can specific ip address also
  }

  egress { //we allowing all ports in egress dir.  
    from_port   = 0
    to_port     = 0
    protocol    = "-1" //for any protocol
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_web"
  }
}

# 7. Create a Network Interface with an IP in the subnet that was created in step 4
resource "aws_network_interface" "web-server-nic" { //private IP address for the host
  subnet_id       = aws_subnet.subnet-1.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.allow-web.id]

  //to attach a device, but we use EC2 later 
  #   attachment {
  #     instance     = aws_instance.test.id
  #     device_index = 1
  #   }
}

# 8. Assign an elastic IP to the network interface created in step 7
resource "aws_eip" "one" { //EIP relies on the internet gateway
  vpc                       = true
  network_interface         = aws_network_interface.web-server-nic.id
  associate_with_private_ip = "10.0.1.50"
  depends_on                = [aws_internet_gateway.gw] //No id because here we reference the whole object and not just the id and pass it in a list
}

# 9. Create Ubuntu server and install/enabe apache2
resource "aws_instance" "web-server-instance" {
  ami               = "ami-042e8287309f5df03"
  instance_type     = "t2.micro"
  availability_zone = "us-east-1a"
  key_name          = "us-east-1_KeyPair" //created a new in key pairs and downloads it (pem file)

  network_interface {
    device_index         = 0 //when we deploy we have to give the interfaces like eth0, eth1, so first interface i.e.0
    network_interface_id = aws_network_interface.web-server-nic.id
  }

  #To deploy this server and run commands on the server to install
  user_data = <<-EOF
                #!/bin/bash
                sudo apt update -y
                sudo apt install apache2 -y
                sudo systemctl start apache2
                sudo bash -c 'echo My first Application >/var/www/html/index.html'
                EOF

  tags = {
    Name = "web-server"
  }
}

# variable "key" {
#   type    = "string"
#   default = "this is my first string"
# }

# output "myfirstoutput" {
#   value = "${var.key}"
# }

# output "server_public_ip" {
#     value = <resource_list>.public_ip   //any key you select from the "terraform state show <any_state_list>"
# }

# output "server_ip" {
#     value = <resource_list>.public_ip   //any key you select from the "terraform state show <any_state_list>"
# }

#MAPS (multi key value and want to group together)
  # variable "mapexample" {
  #   type="map"
  #   default = {
  #     "useast" = "ami1"
  #     "uswest" = "ami2"
  #   }
  # }

  # output "mapoutput" {
  #   value = "${var.mapexample[usewest]}" //which want to use
  # }

  # #LISTS
  # variable "listkey"{ //like arrays
  #     type = "list"
  #     default = ["sg1", "sg2", "sg3"]
  #  }

  # output "sgoutput"{
  #   value = "${var.list[0]}" //only sg1 use
  #   value1 = "${var.list}" //apply all sg
  # }

  # #BOOLEANS
  # variable "testbool" {
  #   default = true
  # }

  # output "boolOut" {
  #   value = "${var.testbool}" //outputs 0 or 1
  # }

#----------------------------------------------
#  # Input & Output
#  variable "myInput" {
#    type = "string"
#  }
#  output "myOutput"{
#    sensitive = true //not shows the output it displays <sensitive>
#    value = "${var.myInput}" //ask for input when apply and shows all the details of Output variable if you don't wanna show then add above line
#  }