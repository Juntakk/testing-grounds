# Network resources creation

# 1 - VPC
data "aws_vpc" "triage_ec2_vpc" {
  tags = {
    Name = "${lower(var.agency_secret)}-triage-ec2-vpc"
  }
}

# 2 - Subnets - 2 Private - 1 Public
data "aws_subnet" "triage_ec2_subnet_priv_a" {
  tags = {
    Name = "${lower(var.agency_secret)}-triage-ec2-subnet-priv-a"
  }
}

data "aws_subnet" "triage_ec2_subnet_priv_b" {
  tags = {
    Name = "${lower(var.agency_secret)}-triage-ec2-subnet-priv-b"
  }
}

# 5 - Security Group
data "aws_security_group" "triage_ec2_pg_sg" {
  tags = {
    Name = "${lower(var.agency_secret)}-triage-ec2-pg-sg"
  }
}

data "aws_security_group" "triage_ec2_http_sg" {
  tags = {
    Name = "${lower(var.agency_secret)}-triage-ec2-http-sg"
  }
}

data "aws_security_group" "triage_ec2_priv_to_vpce_sg" {
  tags = {
    Name = "${lower(var.agency_secret)}-triage-ec2-priv-to-vpce-sg"
  }
}
