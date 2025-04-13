# Will define all the network access list for the deployed VPC
# 01 - Configure/Replace default NACL for the VPC
resource "aws_default_network_acl" "triage_ec2_default_nacl" {
  default_network_acl_id = aws_vpc.triage_ec2_vpc.default_network_acl_id

  tags = {
    Name = "${lower(var.agency_secret)}-triage-ec2-default-nacl"
  }

  lifecycle {
    ignore_changes = [subnet_ids]
  }
}

# 02 - Public NACL to be used by public subnets
resource "aws_network_acl" "triage_ec2_pub_nacl" {
  vpc_id = aws_vpc.triage_ec2_vpc.id

  tags = {
    Name = "${lower(var.agency_secret)}-triage-ec2-pub-nacl"
  }
}

# 02A - Public NACL rules
# HTTPS/TLS (443) in
resource "aws_network_acl_rule" "triage_ec2_pub_nacl_tls_in" {
  network_acl_id = aws_network_acl.triage_ec2_pub_nacl.id
  rule_number    = 100
  egress         = false
  protocol       = "tcp"
  from_port      = 443
  to_port        = 443
  cidr_block     = "0.0.0.0/0"
  #  cidr_block = "104.156.72.34/32"
  rule_action = "allow"
}

/*
resource "aws_network_acl_rule" "triage_ec2_pub_nacl_tls_vpn_in" {
  network_acl_id = aws_network_acl.triage_ec2_pub_nacl.id
  rule_number    = 101
  egress         = false
  protocol       = "tcp"
  from_port      = 443
  to_port        = 443
  cidr_block     = "0.0.0.0/0"
  # cidr_block = "172.19.10.0/24"
  rule_action    = "allow"
}
*/

# HTTP local
resource "aws_network_acl_rule" "triage_ec2_pub_nacl_http_in" {
  network_acl_id = aws_network_acl.triage_ec2_pub_nacl.id
  rule_number    = 110
  egress         = false
  protocol       = "tcp"
  from_port      = 80
  to_port        = 80
  cidr_block     = aws_vpc.triage_ec2_vpc.cidr_block
  rule_action    = "allow"
}


# Ephemeral ports - in
resource "aws_network_acl_rule" "triage_ec2_pub_nacl_eph_in" {
  network_acl_id = aws_network_acl.triage_ec2_pub_nacl.id
  rule_number    = 400
  egress         = false
  protocol       = "tcp"
  from_port      = 1024
  to_port        = 65535
  #  cidr_block     = aws_vpc.triage_ec2_vpc.cidr_block
  cidr_block  = "0.0.0.0/0"
  rule_action = "allow"
}


# HTTPS out
resource "aws_network_acl_rule" "triage_ec2_pub_nacl_https_out" {
  network_acl_id = aws_network_acl.triage_ec2_pub_nacl.id
  rule_number    = 100
  egress         = true
  protocol       = "tcp"
  from_port      = 443
  to_port        = 443
  cidr_block     = "0.0.0.0/0"
  rule_action    = "allow"
}

resource "aws_network_acl_rule" "triage_ec2_pub_nacl_http_out" {
  network_acl_id = aws_network_acl.triage_ec2_pub_nacl.id
  rule_number    = 101
  egress         = true
  protocol       = "tcp"
  from_port      = 80
  to_port        = 80
  cidr_block     = "0.0.0.0/0"
  rule_action    = "allow"
}

# HTTP out - local
resource "aws_network_acl_rule" "triage_ec2_pub_nacl_priv_http_out" {
  network_acl_id = aws_network_acl.triage_ec2_pub_nacl.id
  rule_number    = 110
  egress         = true
  protocol       = "tcp"
  from_port      = 80
  to_port        = 80
  cidr_block     = aws_vpc.triage_ec2_vpc.cidr_block
  rule_action    = "allow"
}

# HTTP 8000 out - local
resource "aws_network_acl_rule" "triage_ec2_pub_nacl_priv_8000_out" {
  network_acl_id = aws_network_acl.triage_ec2_pub_nacl.id
  rule_number    = 111
  egress         = true
  protocol       = "tcp"
  from_port      = 8000
  to_port        = 8000
  cidr_block     = aws_vpc.triage_ec2_vpc.cidr_block
  rule_action    = "allow"
}

/*
# HTTP 8080 - local
resource "aws_network_acl_rule" "triage_ec2_pub_nacl_http_8080_out" {
  network_acl_id = aws_network_acl.triage_ec2_pub_nacl.id
  rule_number    = 130
  egress         = true
  protocol       = "tcp"
  from_port      = 8080
  to_port        = 8080
  cidr_block     = aws_vpc.triage_ec2_vpc.cidr_block
  rule_action    = "allow"
}
*/

# SMTPS out
resource "aws_network_acl_rule" "triage_ec2_pub_nacl_smtps_out" {
  network_acl_id = aws_network_acl.triage_ec2_pub_nacl.id
  rule_number    = 200
  egress         = true
  protocol       = "tcp"
  from_port      = 465
  to_port        = 465
  cidr_block     = "0.0.0.0/0"
  rule_action    = "allow"
}

/*
# PostgreSQL 1475 out - local
resource "aws_network_acl_rule" "triage_ec2_pub_nacl_pg_out" {
  network_acl_id = aws_network_acl.triage_ec2_pub_nacl.id
  rule_number    = 300
  egress         = true
  protocol       = "tcp"
  from_port      = 1475
  to_port        = 1475
  cidr_block     = aws_vpc.triage_ec2_vpc.cidr_block
  rule_action    = "allow"
}
*/

# Ephemeral ports out
resource "aws_network_acl_rule" "triage_ec2_pub_nacl_eph_out" {
  network_acl_id = aws_network_acl.triage_ec2_pub_nacl.id
  rule_number    = 400
  egress         = true
  protocol       = "tcp"
  from_port      = 32768
  to_port        = 65535
  cidr_block     = "0.0.0.0/0"
  rule_action    = "allow"
}

# Ephemeral ports out
resource "aws_network_acl_rule" "triage_ec2_pub_nacl_priv_eph_out" {
  network_acl_id = aws_network_acl.triage_ec2_pub_nacl.id
  rule_number    = 401
  egress         = true
  protocol       = "tcp"
  from_port      = 1024
  to_port        = 65535
  # cidr_block     = aws_vpc.triage_ec2_vpc.cidr_block
  cidr_block  = "0.0.0.0/0"
  rule_action = "allow"
}


# 03 - Private NACL to used by private subnets
resource "aws_network_acl" "triage_ec2_priv_nacl" {
  vpc_id = aws_vpc.triage_ec2_vpc.id

  tags = {
    Name = "${lower(var.agency_secret)}-triage-ec2-priv-nacl"
  }
}

# HTTPS in
resource "aws_network_acl_rule" "triage_ec2_priv_nacl_https_in" {
  network_acl_id = aws_network_acl.triage_ec2_priv_nacl.id
  rule_number    = 100
  egress         = false
  protocol       = "tcp"
  from_port      = 443
  to_port        = 443
  cidr_block     = "0.0.0.0/0"
  rule_action    = "allow"
}

# HTTP in - local
resource "aws_network_acl_rule" "triage_ec2_priv_nacl_http_in" {
  network_acl_id = aws_network_acl.triage_ec2_priv_nacl.id
  rule_number    = 110
  egress         = false
  protocol       = "tcp"
  from_port      = 80
  to_port        = 80
  cidr_block     = "0.0.0.0/0"
  rule_action    = "allow"
}

# HTTP 8000 in - local
resource "aws_network_acl_rule" "triage_ec2_priv_nacl_http_8000_in" {
  network_acl_id = aws_network_acl.triage_ec2_priv_nacl.id
  rule_number    = 120
  egress         = false
  protocol       = "tcp"
  from_port      = 8000
  to_port        = 8000
  cidr_block     = "0.0.0.0/0"
  rule_action    = "allow"
}

/*
# HTTP 8080 in - local
resource "aws_network_acl_rule" "triage_ec2_priv_nacl_http_8080_in" {
  network_acl_id = aws_network_acl.triage_ec2_priv_nacl.id
  rule_number    = 130
  egress         = false
  protocol       = "tcp"
  from_port      = 8080
  to_port        = 8080
  cidr_block     = aws_vpc.triage_ec2_vpc.cidr_block
  rule_action    = "allow"
}

# PostgreSQL 1475 in - local
resource "aws_network_acl_rule" "triage_ec2_priv_nacl_pg_in" {
  network_acl_id = aws_network_acl.triage_ec2_priv_nacl.id
  rule_number    = 300
  egress         = false
  protocol       = "tcp"
  from_port      = 1475
  to_port        = 1475
  cidr_block     = aws_vpc.triage_ec2_vpc.cidr_block
  rule_action    = "allow"
}
*/

# Ephemeral ports in
resource "aws_network_acl_rule" "triage_ec2_priv_nacl_eph_in" {
  network_acl_id = aws_network_acl.triage_ec2_priv_nacl.id
  rule_number    = 400
  egress         = false
  protocol       = "tcp"
  from_port      = 1024
  to_port        = 65535
  cidr_block     = "0.0.0.0/0"
  rule_action    = "allow"
}


# HTTPS out
resource "aws_network_acl_rule" "triage_ec2_priv_nacl_tls_out" {
  network_acl_id = aws_network_acl.triage_ec2_priv_nacl.id
  rule_number    = 100
  egress         = true
  protocol       = "tcp"
  from_port      = 443
  to_port        = 443
  # cidr_block     = aws_vpc.triage_ec2_vpc.cidr_block
  cidr_block  = "0.0.0.0/0"
  rule_action = "allow"
}

# HTTP out - local
resource "aws_network_acl_rule" "triage_ec2_priv_nacl_http_out" {
  network_acl_id = aws_network_acl.triage_ec2_priv_nacl.id
  rule_number    = 110
  egress         = true
  protocol       = "tcp"
  from_port      = 80
  to_port        = 80
  # cidr_block     = aws_vpc.triage_ec2_vpc.cidr_block
  cidr_block  = "0.0.0.0/0"
  rule_action = "allow"
}

/*
# HTTP 8000 out - local
resource "aws_network_acl_rule" "triage_ec2_priv_nacl_http_8000_out" {
  network_acl_id = aws_network_acl.triage_ec2_priv_nacl.id
  rule_number    = 120
  egress         = true
  protocol       = "tcp"
  from_port      = 8000
  to_port        = 8000
  cidr_block     = aws_vpc.triage_ec2_vpc.cidr_block
  rule_action    = "allow"
}

# HTTP 8080 out - local 
resource "aws_network_acl_rule" "triage_ec2_priv_priv_nacl_http_8080_out" {
  network_acl_id = aws_network_acl.triage_ec2_priv_nacl.id
  rule_number    = 130
  egress         = true
  protocol       = "tcp"
  from_port      = 8080
  to_port        = 8080
  cidr_block     = aws_vpc.triage_ec2_vpc.cidr_block
  rule_action    = "allow"
}


# PostgreSQL 8000 out - local
resource "aws_network_acl_rule" "triage_ec2_priv_nacl_pg_out" {
  network_acl_id = aws_network_acl.triage_ec2_priv_nacl.id
  rule_number    = 300
  egress         = true
  protocol       = "tcp"
  from_port      = 1475
  to_port        = 1475
  cidr_block     = aws_vpc.triage_ec2_vpc.cidr_block
  rule_action    = "allow"
}
*/

# SMTPS out
resource "aws_network_acl_rule" "triage_ec2_priv_nacl_smtps_out" {
  network_acl_id = aws_network_acl.triage_ec2_priv_nacl.id
  rule_number    = 200
  egress         = true
  protocol       = "tcp"
  from_port      = 465
  to_port        = 465
  cidr_block     = aws_vpc.triage_ec2_vpc.cidr_block
  rule_action    = "allow"
}

# Ephemeral out
resource "aws_network_acl_rule" "triage_ec2_priv_nacl_eph_out" {
  network_acl_id = aws_network_acl.triage_ec2_priv_nacl.id
  rule_number    = 400
  egress         = true
  protocol       = "tcp"
  from_port      = 1024
  to_port        = 65535
  # cidr_block     = aws_vpc.triage_ec2_vpc.cidr_block
  cidr_block  = "0.0.0.0/0"
  rule_action = "allow"
}

# Subnet association
resource "aws_network_acl_association" "triage_ec2_priv_nacl_ass_a" {
  network_acl_id = aws_network_acl.triage_ec2_priv_nacl.id
  subnet_id      = aws_subnet.triage_ec2_subnet_priv_a.id
}

resource "aws_network_acl_association" "triage_ec2_priv_nacl_ass_b" {
  network_acl_id = aws_network_acl.triage_ec2_priv_nacl.id
  subnet_id      = aws_subnet.triage_ec2_subnet_priv_b.id
}

resource "aws_network_acl_association" "triage_ec2_pub_nacl_ass_a" {
  network_acl_id = aws_network_acl.triage_ec2_pub_nacl.id
  subnet_id      = aws_subnet.triage_ec2_subnet_pub_a.id
}

resource "aws_network_acl_association" "triage_ec2_pub_nacl_ass_b" {
  network_acl_id = aws_network_acl.triage_ec2_pub_nacl.id
  subnet_id      = aws_subnet.triage_ec2_subnet_pub_b.id
}