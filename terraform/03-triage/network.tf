# Network resources creation

# 1 - VPC
data "aws_vpc" "triage_ec2_vpc" {
  tags = {
    Name = "${lower(var.agency_secret)}-triage-ec2-vpc"
  }
}

/*
# 1A - private network ACL
data "aws_network_acls" "triage_ec2_pub_nacl" {
  vpc_id = data.aws_vpc.triage_ec2_vpc.id

  tags = {
    Name = "${lower(var.agency_secret)}-triage-ec2-pub-nacl"
  }
}
*/

# 2 - Subnets - 2 Private - 1 Public
# 2A - Private - us-east-1a 
data "aws_subnet" "triage_ec2_subnet_priv_a" {
  tags = {
    Name = "${lower(var.agency_secret)}-triage-ec2-subnet-priv-a"
  }
}

/*
# 2B - Private - us-east-1b
data "aws_subnet" "triage_ec2_subnet_priv_b" {
  tags = {
    Name = "${lower(var.agency_secret)}-triage-ec2-subnet-priv-b"
  }
}
*/

# 2C - Private - us-east-1b
data "aws_subnet" "triage_ec2_subnet_pub_a" {
  tags = {
    Name = "${lower(var.agency_secret)}-triage-ec2-subnet-pub-a"
  }
}

/*
data "aws_subnet" "triage_ec2_subnet_pub_b" {
  tags = {
    Name = "${lower(var.agency_secret)}-triage-ec2-subnet-pub-b"
  }
}
*/

# 5 - Security Group
# 5A - SSH
data "aws_security_group" "triage_ec2_ssh_sg" {
  tags = {
    Name = "${lower(var.agency_secret)}-triage-ec2-ssh-sg"
  }

}


# 5C - HTTP - 80
data "aws_security_group" "triage_ec2_http_sg" {
  tags = {
    Name = "${lower(var.agency_secret)}-triage-ec2-http-sg"
  }
}


# 5D - Allow TLS within private subnet
data "aws_security_group" "triage_ec2_vpce_sg" {

  tags = {
    Name = "${lower(var.agency_secret)}-triage-ec2-vpc-sg"
  }
}


data "aws_security_group" "triage_ec2_priv_to_vpce_sg" {
  tags = {
    Name = "${lower(var.agency_secret)}-triage-ec2-priv-to-vpce-sg"
  }
}
