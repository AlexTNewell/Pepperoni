##################### VPC #####################

resource "aws_vpc" "dev_vpc" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames = true
}

##################### IG #####################

resource "aws_internet_gateway" "dev_ig" {
  vpc_id = aws_vpc.dev_vpc.id
}

##################### Subnets AZ 1 #####################

resource "aws_subnet" "pub_az_1" {
  vpc_id     = aws_vpc.dev_vpc.id
  availability_zone = "us-east-1a"
  cidr_block = "10.0.0.0/24"
}

resource "aws_subnet" "pri_app_az_1" {
  vpc_id     = aws_vpc.dev_vpc.id
  availability_zone = "us-east-1a"
  cidr_block = "10.0.2.0/24"
}

resource "aws_subnet" "pri_db_az_1" {
  vpc_id     = aws_vpc.dev_vpc.id
  availability_zone = "us-east-1a"
  cidr_block = "10.0.4.0/24"
}

##################### Subnets AZ 2 #####################

resource "aws_subnet" "pub_az_2" {
  vpc_id     = aws_vpc.dev_vpc.id
  availability_zone = "us-east-1b"
  cidr_block = "10.0.1.0/24"
}

resource "aws_subnet" "pri_app_az_2" {
  vpc_id     = aws_vpc.dev_vpc.id
  availability_zone = "us-east-1b"
  cidr_block = "10.0.3.0/24"
}

resource "aws_subnet" "pri_db_az_2" {
  vpc_id     = aws_vpc.dev_vpc.id
  availability_zone = "us-east-1b"
  cidr_block = "10.0.5.0/24"
}

##################### Main Route Table #####################

resource "aws_route_table" "main_route_table" {
  vpc_id = aws_vpc.dev_vpc.id
}

##################### Internet Route Table #####################

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.dev_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dev_ig.id
  }

}

##################### Internet Route Table Associations #####################

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.pub_az_1.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.pub_az_2.id
  route_table_id = aws_route_table.public_route_table.id
}

##################### Elastic IPs #####################

resource "aws_eip" "nat_gw_az1__eip" {
  domain = "vpc"
}

resource "aws_eip" "nat_gw_az2__eip" {
  domain = "vpc"
}

##################### NAT GWs #####################

resource "aws_nat_gateway" "nat_gw_az1" {
  allocation_id = aws_eip.nat_gw_az1__eip.id
  subnet_id     = aws_subnet.pub_az_1.id
  connectivity_type = "public"
}

resource "aws_nat_gateway" "nat_gw_az2" {
  allocation_id = aws_eip.nat_gw_az2__eip.id
  subnet_id     = aws_subnet.pub_az_2.id
  connectivity_type = "public"
}

##################### Private Route Tables #####################

resource "aws_route_table" "private_route_table_az1" {
  vpc_id = aws_vpc.dev_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw_az1.id
  }

}

resource "aws_route_table" "private_route_table_az2" {
  vpc_id = aws_vpc.dev_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw_az2.id
  }

}

##################### Private Route Table Associations #####################

resource "aws_route_table_association" "az1-app" {
  subnet_id      = aws_subnet.pri_app_az_1.id
  route_table_id = aws_route_table.private_route_table_az1.id
}

resource "aws_route_table_association" "az1-db" {
  subnet_id      = aws_subnet.pri_db_az_1.id
  route_table_id = aws_route_table.private_route_table_az1.id
}

resource "aws_route_table_association" "az2-app" {
  subnet_id      = aws_subnet.pri_app_az_2.id
  route_table_id = aws_route_table.private_route_table_az2.id
}

resource "aws_route_table_association" "az2-db" {
  subnet_id      = aws_subnet.pri_db_az_2.id
  route_table_id = aws_route_table.private_route_table_az2.id
}

