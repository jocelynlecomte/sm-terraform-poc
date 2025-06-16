resource "aws_default_vpc" "sm_poc_vpc" {
  tags = {
    Name = "SM POC VPC"
  }
}

resource "aws_default_subnet" "sm_poc_subnet" {
  availability_zone = var.default_az
  tags = {
    Name = "SM POC Subnet"
  }
}