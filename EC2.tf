provider"aws"{
  region = "ap-south-1"
access_key = "AKIAI43XAFPN6ZJIXMDQ"
secret_key = "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"
  }

resource "aws_instance" "AWSServers" {
  ami = "ami-0a9d27a9f4f5c0efc"
  instance_type = "t2.micro"
  Key_name = "Test_Key"
  security_groups =["lanuch-wizard-19"]
  tags = {
    Name = "terraform-server"
  }
}
