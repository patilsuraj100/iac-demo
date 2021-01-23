provider "aws" {
  region = "us-east-1"
  access_key = "AKIAI56OVUB5MO3VYHJQ"
  secret_key = "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"
}

resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "r" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    gateway_id = aws_internet_gateway.gw.id
}

resources "aws_subnet" "subnet1" {
	vpc_id = aws_vpc.main.id
	cidr_block = "10.0.1.0/24"
	availability_zone = "us-east-1a"
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.r.id
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "TLS from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_network_interface" "test" {
  subnet_id       = aws_subnet.subnet1.id
  private_ips     = ["10.0.0.50"]
  security_groups = aws_security_group.allow_tls.id
}

resource "aws_eip" "lb" {
  vpc      = true
  network_interface = aws_network_interface.test.id
  associate_with_private_ip = "10.0.1.50" 
  depends_on = [aws_internet_gateway.gw]
}

resource "aws_instance" "main" {
	ami = "ami-096fda3c22c1c990a"
	instance_type = "t2.micro"
	availability_zone = "us-east-1a"
	key_name = "test"

	network_interface {
		device_index = 0
		network_interface_id = aws_network_interface.test.id
	}
}
