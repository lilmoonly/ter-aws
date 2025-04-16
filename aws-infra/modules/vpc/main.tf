// VPC Module - main.tf
// This module creates a VPC with public and private subnets, Internet Gateway, NAT Gateways, and appropriate route tables.

// Create VPC
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge({
    Name = "${var.project_name}-vpc"
  }, var.common_tags)
}

// Create Internet Gateway
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge({
    Name = "${var.project_name}-igw"
  }, var.common_tags)
}

// Create Public Subnets
resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = merge({
    Name = "${var.project_name}-public-${count.index + 1}"
  }, var.common_tags)
}

// Create Public Route Table with default route via Internet Gateway
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = merge({
    Name = "${var.project_name}-public-rt"
  }, var.common_tags)
}

// Associate Public Subnets with Public Route Table
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

// Create Elastic IPs for NAT Gateways (one per private subnet)
resource "aws_eip" "nat" {
  count = length(var.private_subnet_cidrs)
  domain = "vpc"

  tags = merge({
    Name = "${var.project_name}-nat-eip-${count.index + 1}"
  }, var.common_tags)
}

// Create NAT Gateways (using one per private subnet)
// NAT Gateways provide Internet access for private subnets
resource "aws_nat_gateway" "this" {
  count         = length(var.private_subnet_cidrs)
  allocation_id = aws_eip.nat[count.index].id
  // Associate NAT Gateway with a public subnet in the same AZ as the corresponding private subnet.
  // Here, we assume that the public subnets array is long enough and corresponds index-by-index with private subnets.
  subnet_id = aws_subnet.public[count.index % length(aws_subnet.public)].id

  tags = merge({
    Name = "${var.project_name}-nat-${count.index + 1}"
  }, var.common_tags)

  depends_on = [aws_internet_gateway.this]
}

// Create Private Subnets
resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = element(var.availability_zones, count.index)
  map_public_ip_on_launch = false

  tags = merge({
    Name = "${var.project_name}-private-${count.index + 1}"
  }, var.common_tags)
}

// Create Private Route Tables for each Private Subnet with default route via the corresponding NAT Gateway
resource "aws_route_table" "private" {
  count  = length(var.private_subnet_cidrs)
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this[count.index].id
  }

  tags = merge({
    Name = "${var.project_name}-private-rt-${count.index + 1}"
  }, var.common_tags)
}

// Associate Private Subnets with their respective Private Route Tables
resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}
