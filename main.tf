provider "aws" {
  region = "us-east-1"
}

# vpc 
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

# subnet for the nethermind ec2 instance
resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Main"
  }
}

# create igw for internet connectivity to EC2 instance
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}

resource "aws_route_table" "test" {
  vpc_id = aws_vpc.main.id

  # since this is exactly the route AWS will create, the route will be adopted
  route {
    cidr_block = "10.0.0.0/16"
    gateway_id = "local"
  }

  route {
    gateway_id = aws_internet_gateway.gw.id
    cidr_block = "0.0.0.0/0"
  }
}

resource "aws_route_table_association" "main" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.test.id
}