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
  cidr_block        = var.public-cidr-3
  availability_zone = var.zone-3
  tags = {
    Name = "${local.tag}-public-subnet3"
  }
}
resource "aws_subnet" "subnet_id_4" {
  vpc_id            = aws_vpc.eks-vpc.id
  cidr_block        = var.public-cidr-4
  availability_zone = var.zone-4
  tags = {
    Name = "${local.tag}-public-subnet4"
  }
}

resource "aws_subnet" "subnet_id_5" {
  vpc_id            = aws_vpc.eks-vpc.id
  cidr_block        = var.private-cidr-5
  availability_zone = var.zone-1
  tags = {
    Name = "${local.tag}-private-subnet1"
  }
}
resource "aws_subnet" "subnet_id_6" {
  vpc_id            = aws_vpc.eks-vpc.id
  cidr_block        = var.private-cidr-6
  availability_zone = var.zone-2
  tags = {
    Name = "${local.tag}-private-subnet2"
  }
}

resource "aws_subnet" "subnet_id_7" {
  vpc_id            = aws_vpc.eks-vpc.id
  cidr_block        = var.private-cidr-7
  availability_zone = var.zone-3
  tags = {
    Name = "${local.tag}-private-subnet3"
  }
}
resource "aws_subnet" "subnet_id_8" {
  vpc_id            = aws_vpc.eks-vpc.id
  cidr_block        = var.private-cidr-8
  availability_zone = var.zone-4
  tags = {
    Name = "${local.tag}-private-subnet4"
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
resource "aws_eip" "nat_gateway-1" {
  vpc = true
}
resource "aws_eip" "nat_gateway-2" {
  vpc = true
}
resource "aws_nat_gateway" "eks_nat-1" {
  allocation_id = aws_eip.nat_gateway-1.id
  subnet_id     = aws_subnet.subnet_id_1.id
  tags = {
    Name = "${local.tag}-nat"
  }
}

resource "aws_nat_gateway" "eks_nat-2" {
  allocation_id = aws_eip.nat_gateway-2.id
  subnet_id     = aws_subnet.subnet_id_2.id
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

resource "aws_route_table" "eks_route_private-1" {
  vpc_id = aws_vpc.eks-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.eks_nat-1.id
  }
  tags = {
    Name = "${local.tag}-route-private-1"
  }
}

resource "aws_route_table" "eks_route_private-2" {
  vpc_id = aws_vpc.eks-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.eks_nat-2.id
  }
  tags = {
    Name = "${local.tag}-route-private-2"
  }
}

##Route Table Association Public subnet
resource "aws_route_table_association" "public-1" {
  subnet_id      = aws_subnet.subnet_id_1.id
  route_table_id = aws_route_table.eks_route_public.id
}
resource "aws_route_table_association" "public-2" {
  subnet_id      = aws_subnet.subnet_id_2.id
  route_table_id = aws_route_table.eks_route_public.id
}

resource "aws_route_table_association" "public-3" {
  subnet_id      = aws_subnet.subnet_id_3.id
  route_table_id = aws_route_table.eks_route_public.id
}
resource "aws_route_table_association" "public-4" {
  subnet_id      = aws_subnet.subnet_id_4.id
  route_table_id = aws_route_table.eks_route_public.id
}

##Route Table Association Private subnet
resource "aws_route_table_association" "private-1" {
  subnet_id      = aws_subnet.subnet_id_5.id
  route_table_id = aws_route_table.eks_route_private-1.id
}
resource "aws_route_table_association" "private-2" {
  subnet_id      = aws_subnet.subnet_id_6.id
  route_table_id = aws_route_table.eks_route_private-1.id
}
resource "aws_route_table_association" "private-3" {
  subnet_id      = aws_subnet.subnet_id_7.id
  route_table_id = aws_route_table.eks_route_private-2.id
}
resource "aws_route_table_association" "private-4" {
  subnet_id      = aws_subnet.subnet_id_8.id
  route_table_id = aws_route_table.eks_route_private-2.id
}