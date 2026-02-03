resource "aws_vpc" "project_1" {
  cidr_block = "45.0.0.0/16"
  tags = {
    name = "project_001"
  }
}
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.project_1.id
  cidr_block              = "45.0.0.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet_001"
  }
}
resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.project_1.id
  cidr_block        = "45.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "private_subnet_001"
  }
}
resource "aws_internet_gateway" "igw_1" {
  vpc_id = aws_vpc.project_1.id
  tags = {
    Name = "IGW_001"
  }
}

resource "aws_route_table" "rt_1" {
  vpc_id = aws_vpc.project_1.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_1.id
  }
  tags = {
    Name = "public_rt_001"
  }
}
resource "aws_route_table_association" "public_asso" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.rt_1.id
}
resource "aws_eip" "nat_eip" {
  domain = "vpc"
}
resource "aws_nat_gateway" "nat_1" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet.id
  tags = {
    Name = "nat_001"
  }

}
resource "aws_route_table" "rt_2" {
  vpc_id = aws_vpc.project_1.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_1.id
  }
  tags = {
    Name = "private_rt_001"
  }

}
resource "aws_route_table_association" "private_asso" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.rt_2.id
}

resource "aws_security_group" "SG_1" {
  vpc_id = aws_vpc.project_1.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "SG__001"
  }

}
resource "aws_instance" "public_ec2" {
  ami                    = "ami-0532be01f26a3de55"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.SG_1.id]
  subnet_id              = aws_subnet.public_subnet.id
  key_name               = "KEYNO1"
  tags = {
    Name = "public_ec2"
  }

}
resource "aws_instance" "private_ec2" {
  ami                    = "ami-0532be01f26a3de55"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.SG_1.id]
  subnet_id              = aws_subnet.private_subnet.id
  key_name               = "KEYNO1"
  tags = {
    Name = "private_ec2"
  }
}
