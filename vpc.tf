##VPC
resource "aws_vpc" "eks-vpc" {
  cidr_block           = var.vpc-cidr
  enable_dns_hostnames = "true"
  enable_dns_support   = "true"
  enable_classiclink   = "false"
  instance_tenancy     = "default"
  tags = {
    Name = "${local.tag}-eks"
  }
}

##Subnets
resource "aws_subnet" "subnet_id_1" {
  vpc_id            = aws_vpc.eks-vpc.id
  cidr_block        = var.public-cidr-1
  availability_zone = var.zone-1
  tags = {
    Name = "${local.tag}-public-subnet1"
  }
}
resource "aws_subnet" "subnet_id_2" {
  vpc_id            = aws_vpc.eks-vpc.id
  cidr_block        = var.public-cidr-2
  availability_zone = var.zone-2
  tags = {
    Name = "${local.tag}-public-subnet2"
  }
}
resource "aws_subnet" "subnet_id_3" {
  vpc_id            = aws_vpc.eks-vpc.id
  cidr_block        = var.private-cidr-3
  availability_zone = var.zone-3
  tags = {
    Name = "${local.tag}-private-subnet3"
  }
}
resource "aws_subnet" "subnet_id_4" {
  vpc_id            = aws_vpc.eks-vpc.id
  cidr_block        = var.private-cidr-4
  availability_zone = var.zone-4
  tags = {
    Name = "${local.tag}-privatesubnet4"
  }
}

##Internet Gateway for Public Subnet
resource "aws_internet_gateway" "eks-ig" {
  vpc_id = aws_vpc.eks-vpc.id
  tags = {
    Name = "${local.tag}-ig"
  }
}

##NAT gateway
resource "aws_eip" "nat_gateway" {
  vpc = true
}
resource "aws_nat_gateway" "eks_nat" {
  allocation_id = aws_eip.nat_gateway.id
  subnet_id     = aws_subnet.subnet_id_1.id
  tags = {
    Name = "${local.tag}-nat"
  }
}

##route table
resource "aws_route_table" "eks_route_public" {
  vpc_id = aws_vpc.eks-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eks-ig.id
  }
  tags = {
    Name = "${local.tag}-public"
  }
}

resource "aws_route_table" "eks_route_private" {
  vpc_id = aws_vpc.eks-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.eks_nat.id
  }
  tags = {
    Name = "${local.tag}-route-private"
  }
}

##Route Table Association
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.subnet_id_1.id
  route_table_id = aws_route_table.eks_route_public.id
}
resource "aws_route_table_association" "public-2" {
  subnet_id      = aws_subnet.subnet_id_2.id
  route_table_id = aws_route_table.eks_route_public.id
}

resource "aws_route_table_association" "private-1" {
  subnet_id      = aws_subnet.subnet_id_3.id
  route_table_id = aws_route_table.eks_route_private.id
}
resource "aws_route_table_association" "private-2" {
  subnet_id      = aws_subnet.subnet_id_4.id
  route_table_id = aws_route_table.eks_route_private.id
}