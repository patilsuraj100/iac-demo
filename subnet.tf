resource "aws_subnet" "main" {
  vpc_id     = vpc-0a02f1bb7aa2dc59c
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Main"
  }
}
