# Network resources creation
# Note for GuardDuty : 
# - https://medium.com/@roinisimi/eks-cluster-with-terraform-overcome-dependency-violation-errors-on-a-guardduty-runtime-protection-41c8ff0a302c
# - https://github.com/roin-orca/terraform-eks-guardduty-dependency-violation

# 1 - VPC
resource "aws_vpc" "triage_ec2_vpc" {
  cidr_block = "172.16.0.0/22"

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${lower(var.agency_secret)}-triage-ec2-vpc"
  }
}

# 2 - Subnets - 2 Private - 1 Public
# 2A - Private - us-east-1a 
resource "aws_subnet" "triage_ec2_subnet_priv_a" {
  vpc_id     = aws_vpc.triage_ec2_vpc.id
  cidr_block = "172.16.0.0/24"

  availability_zone = "${var.aws_region}a"

  tags = {
    Name = "${lower(var.agency_secret)}-triage-ec2-subnet-priv-a"
  }
}

# 2B - Private - us-east-1b
resource "aws_subnet" "triage_ec2_subnet_priv_b" {
  vpc_id     = aws_vpc.triage_ec2_vpc.id
  cidr_block = "172.16.1.0/24"

  availability_zone = "${var.aws_region}b"

  tags = {
    Name = "${lower(var.agency_secret)}-triage-ec2-subnet-priv-b"
  }
}

# 2C - Public - us-east-1a
resource "aws_subnet" "triage_ec2_subnet_pub_a" {
  vpc_id     = aws_vpc.triage_ec2_vpc.id
  cidr_block = "172.16.2.0/24"

  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true

  tags = {
    Name = "${lower(var.agency_secret)}-triage-ec2-subnet-pub-a"
  }
}

# 2D - Public - us-east-1b
resource "aws_subnet" "triage_ec2_subnet_pub_b" {
  vpc_id     = aws_vpc.triage_ec2_vpc.id
  cidr_block = "172.16.3.0/24"

  availability_zone       = "${var.aws_region}b"
  map_public_ip_on_launch = true

  tags = {
    Name = "${lower(var.agency_secret)}-triage-ec2-subnet-pub-b"
  }
}

# 3 - Gateways
# 3A - Internet Gateway
resource "aws_internet_gateway" "triage_ec2_igw" {
  vpc_id = aws_vpc.triage_ec2_vpc.id

  tags = {
    Name = "${lower(var.agency_secret)}-triage-ec2-igw"
  }
}

# 3B - NAT Gateway
resource "aws_eip" "triage_ec2_natgw_eip" {
  domain = "vpc"

  tags = {
    Name = "${lower(var.agency_secret)}-triage-ec2-natgw-eip"
  }

  depends_on = [aws_internet_gateway.triage_ec2_igw]
}

resource "aws_nat_gateway" "triage_ec2_natgw" {
  connectivity_type = "public"
  subnet_id         = aws_subnet.triage_ec2_subnet_pub_a.id
  allocation_id     = aws_eip.triage_ec2_natgw_eip.id

  tags = {
    Name = "${lower(var.agency_secret)}-triage-ec2-natgw"
  }

  depends_on = [aws_internet_gateway.triage_ec2_igw]
}

# 4 - Routes and route tables
# Public route
resource "aws_route_table" "triage_ec2_public_route" {
  vpc_id = aws_vpc.triage_ec2_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.triage_ec2_igw.id
  }

  tags = {
    Name = "${lower(var.agency_secret)}-triage-ec2-public-route"
  }
}

resource "aws_route_table_association" "triage_ec2_public_route_ass_a" {
  subnet_id      = aws_subnet.triage_ec2_subnet_pub_a.id
  route_table_id = aws_route_table.triage_ec2_public_route.id
}

resource "aws_route_table_association" "triage_ec2_public_route_ass_b" {
  subnet_id      = aws_subnet.triage_ec2_subnet_pub_b.id
  route_table_id = aws_route_table.triage_ec2_public_route.id
}

# Private route
resource "aws_route_table" "triage_ec2_private_route" {
  vpc_id = aws_vpc.triage_ec2_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.triage_ec2_natgw.id
  }

  tags = {
    Name = "${lower(var.agency_secret)}-triage-ec2-private-route"
  }
}

resource "aws_route_table_association" "triage_ec2_private_route_ass_a" {
  subnet_id      = aws_subnet.triage_ec2_subnet_priv_a.id
  route_table_id = aws_route_table.triage_ec2_private_route.id
}

resource "aws_route_table_association" "triage_ec2_private_route_ass_b" {
  subnet_id      = aws_subnet.triage_ec2_subnet_priv_b.id
  route_table_id = aws_route_table.triage_ec2_private_route.id
}

