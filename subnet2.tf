resource "aws_subnet" "second" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  tags = {
    Name = "MySubnet1"
  }
}
