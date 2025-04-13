# Will create security group to apply to subnets
# 01 - Configure/Replace default Security Group for the VPC
resource "aws_default_security_group" "triage_ec2_default_sg" {
  vpc_id = aws_vpc.triage_ec2_vpc.id

  # removes all rules

  tags = {
    Name = "${lower(var.agency_secret)}-triage-ec2-default-sg"
  }
}

# 5 - Security Group
# 5A - SSH
resource "aws_security_group" "triage_ec2_ssh_sg" {
  name        = "${lower(var.agency_secret)}-triage-ec2-ssh-sg"
  description = "Security Group for SSH access"
  vpc_id      = aws_vpc.triage_ec2_vpc.id

  tags = {
    Name = "${lower(var.agency_secret)}-triage-ec2-ssh-sg"
  }

}

resource "aws_vpc_security_group_ingress_rule" "triage_ec2_ssh_in_public_ipv4" {
  security_group_id = aws_security_group.triage_ec2_ssh_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22

  tags = {
    Name = "${lower(var.agency_secret)}-triage-ec2-ssh-in-ipv4"
  }
}

resource "aws_vpc_security_group_egress_rule" "triage_ec2_ssh_out_ipv4" {
  security_group_id = aws_security_group.triage_ec2_ssh_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"

  tags = {
    Name = "${lower(var.agency_secret)}-triage-ec2-ssh-out-all-ipv4"
  }
}

# 5B - PostgreSQL (1475)
resource "aws_security_group" "triage_ec2_pg_sg" {
  name        = "${lower(var.agency_secret)}-triage-ec2-pg-sg"
  description = "Allow PostgreSQL inbound local traffic"
  vpc_id      = aws_vpc.triage_ec2_vpc.id

  tags = {
    Name = "${lower(var.agency_secret)}-triage-ec2-pg-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "triage_ec2_pg_in_priv_ipv4" {
  security_group_id = aws_security_group.triage_ec2_pg_sg.id
  description       = "Local ATS database access"
  cidr_ipv4         = aws_vpc.triage_ec2_vpc.cidr_block
  from_port         = 1475
  ip_protocol       = "tcp"
  to_port           = 1475

  tags = {
    Name = "${lower(var.agency_secret)}-triage-ec2-pg-in-priv-ipv4"
  }
}

resource "aws_vpc_security_group_egress_rule" "triage_ec2_outbound_pg_ipv4" {
  security_group_id = aws_security_group.triage_ec2_pg_sg.id
  description       = "Allow outbound on all protocols"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"

  tags = {
    Name = "${lower(var.agency_secret)}-triage-ec2-pg-out-all-ipv4"
  }
}

# 5C - HTTP - 80
resource "aws_security_group" "triage_ec2_http_sg" {
  name        = "${lower(var.agency_secret)}-triage-ec2-http-sg"
  description = "Allow HTTP local inbound traffic"
  vpc_id      = aws_vpc.triage_ec2_vpc.id

  tags = {
    Name = "${lower(var.agency_secret)}-triage-ec2-http-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "triage_ec2_http_in_priv_ipv4" {
  security_group_id = aws_security_group.triage_ec2_http_sg.id
  cidr_ipv4         = aws_vpc.triage_ec2_vpc.cidr_block
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80

  tags = {
    Name = "${lower(var.agency_secret)}-triage-ec2-http-in-priv-ipv4"
  }
}

resource "aws_vpc_security_group_ingress_rule" "triage_ec2_http_8000_in_priv_ipv4" {
  security_group_id = aws_security_group.triage_ec2_http_sg.id
  cidr_ipv4         = aws_vpc.triage_ec2_vpc.cidr_block
  from_port         = 8000
  ip_protocol       = "tcp"
  to_port           = 8000

  tags = {
    Name = "${lower(var.agency_secret)}-triage-ec2-http-in-priv-8000-ipv4"
  }
}

resource "aws_vpc_security_group_ingress_rule" "triage_ec2_http_8080_in_priv_ipv4" {
  security_group_id = aws_security_group.triage_ec2_http_sg.id
  cidr_ipv4         = aws_vpc.triage_ec2_vpc.cidr_block
  from_port         = 8080
  ip_protocol       = "tcp"
  to_port           = 8080

  tags = {
    Name = "${lower(var.agency_secret)}-triage-ec2-http-in-priv-8080-ipv4"
  }
}

resource "aws_vpc_security_group_egress_rule" "triage_ec2_http_out_all_ipv4" {
  security_group_id = aws_security_group.triage_ec2_http_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"

  tags = {
    Name = "${lower(var.agency_secret)}-triage-ec2-http-out-all-ipv4"
  }
}

# 5D - Application Load Balancer
resource "aws_security_group" "triage_alb_sg" {
  name        = "${lower(var.agency_secret)}-triage-ec2-alb-sg"
  description = "Application Load Balancer Traffic for ${lower(var.agency_secret)}"
  vpc_id      = aws_vpc.triage_ec2_vpc.id

  tags = {
    Name = "${lower(var.agency_secret)}-triage-ec2-alb-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "triage_ec2_alb_http" {
  security_group_id = aws_security_group.triage_alb_sg.id
  description       = "Allow inbound HTTP protocol"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80


  tags = {
    Name = "${lower(var.agency_secret)}-triage-ec2-alb-in-http"
  }
}

resource "aws_vpc_security_group_ingress_rule" "triage_ec2_alb_https" {
  security_group_id = aws_security_group.triage_alb_sg.id
  description       = "Allow inbound HTTPS protocol"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443


  tags = {
    Name = "${lower(var.agency_secret)}-triage-ec2-alb-in-https"
  }
}

resource "aws_vpc_security_group_egress_rule" "triage_ec2_alb_out_ipv4" {
  security_group_id = aws_security_group.triage_alb_sg.id
  description       = "Allow outbound on all protocol"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"

  tags = {
    Name = "${lower(var.agency_secret)}-triage-ec2-alb-out-all"
  }
}

/*
resource "aws_security_group" "triage_alb_back_sg" {
  name        = "${lower(var.agency_secret)}-triage-ec2-alb-back-sg"
  description = "Application Load Balancer Backend for ${lower(var.agency_secret)}"
  vpc_id      = aws_vpc.triage_ec2_vpc.id

  tags = {
    Name = "${lower(var.agency_secret)}-triage-ec2-alb-back-sg"
  }
}

resource "aws_vpc_security_group_egress_rule" "triage_ec2_alb_back_out_ipv4" {
  security_group_id = aws_security_group.triage_alb_back_sg.id
  description       = "Allow outbound on all protocol"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"

  tags = {
    Name = "${lower(var.agency_secret)}-triage-ec2-alb-back-out-all"
  }
}
*/

# 5D - Allow TLS within private subnet
resource "aws_security_group" "triage_ec2_vpce_sg" {
  name        = "${lower(var.agency_secret)}-triage-ec2-vpce-sg"
  description = "VPC Endpoint Security Group for ${lower(var.agency_secret)}"
  vpc_id      = aws_vpc.triage_ec2_vpc.id

  tags = {
    Name = "${lower(var.agency_secret)}-triage-ec2-vpc-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "triage_ec2_vpce_tls_in_priv_ipv4" {
  security_group_id = aws_security_group.triage_ec2_vpce_sg.id
  description       = "Allow TLS within the VPC"
  cidr_ipv4         = aws_vpc.triage_ec2_vpc.cidr_block
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443

  tags = {
    Name = "${lower(var.agency_secret)}-triage-ec2-vpce-tls-in-priv"
  }
}

resource "aws_vpc_security_group_egress_rule" "triage_ec2_vpce_tls_out_all_ipv4" {
  security_group_id = aws_security_group.triage_ec2_vpce_sg.id
  description       = "Allow outbound traffic"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"

  tags = {
    Name = "${lower(var.agency_secret)}-triage-ec2-vpce-tls-out-all"
  }
}

# 5E - Private to VPC Endpoint

resource "aws_security_group" "triage_ec2_priv_to_vpce_sg" {
  name        = "${lower(var.agency_secret)}-triage-ec2-priv-to-vpce-sg"
  description = "Private Subnet to VPC Endpoint Security Group for ${lower(var.agency_secret)}"
  vpc_id      = aws_vpc.triage_ec2_vpc.id

  tags = {
    Name = "${lower(var.agency_secret)}-triage-ec2-priv-to-vpce-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "triage_ec2_priv_to_vpce_smtp_in_priv_ipv4" {
  security_group_id = aws_security_group.triage_ec2_priv_to_vpce_sg.id
  description       = "Allow SMTP within the VPC"
  cidr_ipv4         = aws_vpc.triage_ec2_vpc.cidr_block
  ip_protocol       = "tcp"
  from_port         = 465
  to_port           = 465

  tags = {
    Name = "${lower(var.agency_secret)}-triage-ec2-priv-to-vpce-smtp-in-priv"
  }
}

resource "aws_vpc_security_group_egress_rule" "triage_ec2_priv_to_vpce_tls_out_tcp_ipv4" {
  security_group_id = aws_security_group.triage_ec2_priv_to_vpce_sg.id
  description       = "Allow TLS outbound traffic"
  cidr_ipv4         = aws_vpc.triage_ec2_vpc.cidr_block
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"

  tags = {
    Name = "${lower(var.agency_secret)}-triage-ec2-priv-to-vpce-tls-out-tcp"
  }
}

resource "aws_vpc_security_group_egress_rule" "triage_ec2_priv_to_vpce_tls_out_all_ipv4" {
  security_group_id = aws_security_group.triage_ec2_priv_to_vpce_sg.id
  description       = "Allow outbound traffic"
  cidr_ipv4         = aws_vpc.triage_ec2_vpc.cidr_block
  ip_protocol       = "-1"

  tags = {
    Name = "${lower(var.agency_secret)}-triage-ec2-priv-to-vpce-tls-out-all"
  }
}