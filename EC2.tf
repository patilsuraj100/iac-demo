resource "aws_instance" "AWSServers" {
  ami = "ami-0a9d27a9f4f5c0efc"
  instance_type = "t2.micro"
  Key_name = "test_key"
  security_groups =["lanuch-wizard-19"]
  tags = {
    Name = "terraform-server"
  }
}
