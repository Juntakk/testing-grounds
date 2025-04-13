# Private Zone - to resolve outbound queries to public instead of NAT GW + EIP -- see François

# 3 - VPC Endpoints
# 3A - S3 Gateway Endpoint
data "aws_iam_policy_document" "triage_ec2_vpc_s3_endpoint" {
  statement {
    effect    = "Allow"
    actions   = ["*"]
    resources = ["*"]
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }
}

resource "aws_vpc_endpoint" "triage_ec2_vpc_s3_endpoint" {
  vpc_id            = aws_vpc.triage_ec2_vpc.id
  service_name      = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_type = "Gateway"

  # ip_address_type = "ipv4"
  # private_dns_enabled = true

  route_table_ids = [aws_route_table.triage_ec2_private_route.id]

  policy = data.aws_iam_policy_document.triage_ec2_vpc_s3_endpoint.json

  /*
  subnet_configuration {
    ipv4      = "172.16.0.10"
    subnet_id = aws_subnet.triage_ec2_subnet_priv_a.id
  }

  subnet_configuration {
    ipv4      = "172.16.1.10"
    subnet_id = aws_subnet.triage_ec2_subnet_priv_b.id
  }

  subnet_ids = [aws_subnet.triage_ec2_subnet_priv_a.id, aws_subnet.triage_ec2_subnet_priv_b.id]
*/

  tags = {
    Name = "${lower(var.agency_secret)}-triage-ec2-s3-endpoint"
  }
}


# 3B - SES / SMTP Interface Endpoint
resource "aws_vpc_endpoint" "triage_ec2_vpc_smtp_endpoint" {
  vpc_id       = aws_vpc.triage_ec2_vpc.id
  service_name = "com.amazonaws.${var.aws_region}.email-smtp"
  # service_name      = "com.amazonaws.us-east-1.email-smtp"
  vpc_endpoint_type = "Interface"

  private_dns_enabled = true
  /*
  dns_options {
    dns_record_ip_type                             = "ipv4"
    private_dns_only_for_inbound_resolver_endpoint = true
  }
*/
  ip_address_type = "ipv4"

  subnet_configuration {
    ipv4      = "172.16.0.11"
    subnet_id = aws_subnet.triage_ec2_subnet_priv_a.id
  }

  subnet_configuration {
    ipv4      = "172.16.1.11"
    subnet_id = aws_subnet.triage_ec2_subnet_priv_b.id
  }

  subnet_ids = [aws_subnet.triage_ec2_subnet_priv_a.id, aws_subnet.triage_ec2_subnet_priv_b.id]

  security_group_ids = [aws_security_group.triage_ec2_vpce_sg.id, aws_security_group.triage_ec2_priv_to_vpce_sg.id]
  # , "sg-0122aa07aff87fb1b"

  tags = {
    Name = "${lower(var.agency_secret)}-triage-ec2-smtp-endpoint"
  }
}

# 3C - SSM Interface Endpoint
resource "aws_vpc_endpoint" "triage_ec2_vpc_ssm_endpoint" {
  vpc_id            = aws_vpc.triage_ec2_vpc.id
  service_name      = "com.amazonaws.${var.aws_region}.ssm"
  vpc_endpoint_type = "Interface"

  private_dns_enabled = true

  /*
  dns_options {
    dns_record_ip_type                             = "ipv4"
    private_dns_only_for_inbound_resolver_endpoint = true
  }
*/

  ip_address_type = "ipv4"

  subnet_configuration {
    ipv4      = "172.16.0.12"
    subnet_id = aws_subnet.triage_ec2_subnet_priv_a.id
  }

  subnet_configuration {
    ipv4      = "172.16.1.12"
    subnet_id = aws_subnet.triage_ec2_subnet_priv_b.id
  }

  subnet_ids = [aws_subnet.triage_ec2_subnet_priv_a.id, aws_subnet.triage_ec2_subnet_priv_b.id]

  security_group_ids = [aws_security_group.triage_ec2_vpce_sg.id]

  tags = {
    Name = "${lower(var.agency_secret)}-triage-ec2-ssm-endpoint"
  }
}

# 3D - SSM Messages Interface Endpoint
resource "aws_vpc_endpoint" "triage_ec2_vpc_ssmmsg_endpoint" {
  vpc_id            = aws_vpc.triage_ec2_vpc.id
  service_name      = "com.amazonaws.${var.aws_region}.ssmmessages"
  vpc_endpoint_type = "Interface"

  private_dns_enabled = true

  /*    
  dns_options {
    dns_record_ip_type                             = "ipv4"
    private_dns_only_for_inbound_resolver_endpoint = true
  }
*/

  ip_address_type = "ipv4"

  subnet_configuration {
    ipv4      = "172.16.0.13"
    subnet_id = aws_subnet.triage_ec2_subnet_priv_a.id
  }

  subnet_configuration {
    ipv4      = "172.16.1.13"
    subnet_id = aws_subnet.triage_ec2_subnet_priv_b.id
  }

  subnet_ids = [aws_subnet.triage_ec2_subnet_priv_a.id, aws_subnet.triage_ec2_subnet_priv_b.id]

  security_group_ids = [aws_security_group.triage_ec2_vpce_sg.id]

  tags = {
    Name = "${lower(var.agency_secret)}-triage-ec2-ssmmsg-endpoint"
  }
}

# 3E - SSM Messages Interface Endpoint
resource "aws_vpc_endpoint" "triage_ec2_vpc_ssmqs_endpoint" {
  vpc_id            = aws_vpc.triage_ec2_vpc.id
  service_name      = "com.amazonaws.${var.aws_region}.ssm-quicksetup"
  vpc_endpoint_type = "Interface"

  private_dns_enabled = true

  /*    
  dns_options {
    dns_record_ip_type                             = "ipv4"
    private_dns_only_for_inbound_resolver_endpoint = true
  }
*/

  ip_address_type = "ipv4"

  subnet_configuration {
    ipv4      = "172.16.0.14"
    subnet_id = aws_subnet.triage_ec2_subnet_priv_a.id
  }

  subnet_configuration {
    ipv4      = "172.16.1.14"
    subnet_id = aws_subnet.triage_ec2_subnet_priv_b.id
  }

  subnet_ids = [aws_subnet.triage_ec2_subnet_priv_a.id, aws_subnet.triage_ec2_subnet_priv_b.id]

  security_group_ids = [aws_security_group.triage_ec2_vpce_sg.id]

  tags = {
    Name = "${lower(var.agency_secret)}-triage-ec2-ssm-qs-endpoint"
  }
}


# 3F - EC2 Interface Endpoint
resource "aws_vpc_endpoint" "triage_ec2_vpc_ec2_endpoint" {
  vpc_id            = aws_vpc.triage_ec2_vpc.id
  service_name      = "com.amazonaws.${var.aws_region}.ec2"
  vpc_endpoint_type = "Interface"

  private_dns_enabled = true

  /*
  dns_options {
    dns_record_ip_type                             = "ipv4"
    private_dns_only_for_inbound_resolver_endpoint = true
  }
*/
  ip_address_type = "ipv4"

  subnet_configuration {
    ipv4      = "172.16.0.15"
    subnet_id = aws_subnet.triage_ec2_subnet_priv_a.id
  }

  subnet_configuration {
    ipv4      = "172.16.1.15"
    subnet_id = aws_subnet.triage_ec2_subnet_priv_b.id
  }

  subnet_ids = [aws_subnet.triage_ec2_subnet_priv_a.id, aws_subnet.triage_ec2_subnet_priv_b.id]

  security_group_ids = [aws_security_group.triage_ec2_vpce_sg.id]

  tags = {
    Name = "${lower(var.agency_secret)}-triage-ec2-ec2-endpoint"
  }
}

# 3F - EC2 Messages Interface Endpoint
resource "aws_vpc_endpoint" "triage_ec2_vpc_ec2msg_endpoint" {
  vpc_id            = aws_vpc.triage_ec2_vpc.id
  service_name      = "com.amazonaws.${var.aws_region}.ec2messages"
  vpc_endpoint_type = "Interface"

  private_dns_enabled = true

  /*  
  dns_options {
    dns_record_ip_type                             = "ipv4"
    private_dns_only_for_inbound_resolver_endpoint = true
  }
*/

  ip_address_type = "ipv4"

  subnet_configuration {
    ipv4      = "172.16.0.16"
    subnet_id = aws_subnet.triage_ec2_subnet_priv_a.id
  }

  subnet_configuration {
    ipv4      = "172.16.1.16"
    subnet_id = aws_subnet.triage_ec2_subnet_priv_b.id
  }

  subnet_ids = [aws_subnet.triage_ec2_subnet_priv_a.id, aws_subnet.triage_ec2_subnet_priv_b.id]

  security_group_ids = [aws_security_group.triage_ec2_vpce_sg.id]

  tags = {
    Name = "${lower(var.agency_secret)}-triage-ec2-ec2msg-endpoint"
  }
}

# 3G - KMS Interface Endpoint
resource "aws_vpc_endpoint" "triage_ec2_vpc_kms_endpoint" {
  vpc_id            = aws_vpc.triage_ec2_vpc.id
  service_name      = "com.amazonaws.${var.aws_region}.kms"
  vpc_endpoint_type = "Interface"

  private_dns_enabled = true

  /*
  dns_options {
    dns_record_ip_type                             = "ipv4"
    private_dns_only_for_inbound_resolver_endpoint = true
  }
*/

  ip_address_type = "ipv4"

  subnet_configuration {
    ipv4      = "172.16.0.17"
    subnet_id = aws_subnet.triage_ec2_subnet_priv_a.id
  }

  subnet_configuration {
    ipv4      = "172.16.1.17"
    subnet_id = aws_subnet.triage_ec2_subnet_priv_b.id
  }

  subnet_ids = [aws_subnet.triage_ec2_subnet_priv_a.id, aws_subnet.triage_ec2_subnet_priv_b.id]

  security_group_ids = [aws_security_group.triage_ec2_vpce_sg.id]

  tags = {
    Name = "${lower(var.agency_secret)}-triage-ec2-kms-endpoint"
  }
}

# 3H - Logs Interface Endpoint
resource "aws_vpc_endpoint" "triage_ec2_vpc_logs_endpoint" {
  vpc_id            = aws_vpc.triage_ec2_vpc.id
  service_name      = "com.amazonaws.${var.aws_region}.logs"
  vpc_endpoint_type = "Interface"

  private_dns_enabled = true

  /*
  dns_options {
    dns_record_ip_type                             = "ipv4"
    private_dns_only_for_inbound_resolver_endpoint = true
  }
*/

  ip_address_type = "ipv4"

  subnet_configuration {
    ipv4      = "172.16.0.18"
    subnet_id = aws_subnet.triage_ec2_subnet_priv_a.id
  }

  subnet_configuration {
    ipv4      = "172.16.1.18"
    subnet_id = aws_subnet.triage_ec2_subnet_priv_b.id
  }

  subnet_ids = [aws_subnet.triage_ec2_subnet_priv_a.id, aws_subnet.triage_ec2_subnet_priv_b.id]

  security_group_ids = [aws_security_group.triage_ec2_vpce_sg.id]

  tags = {
    Name = "${lower(var.agency_secret)}-triage-ec2-logs-endpoint"
  }
}

# 3H - Logs Interface Endpoint
resource "aws_vpc_endpoint" "triage_ec2_vpc_monitoring_endpoint" {
  vpc_id            = aws_vpc.triage_ec2_vpc.id
  service_name      = "com.amazonaws.${var.aws_region}.monitoring"
  vpc_endpoint_type = "Interface"

  private_dns_enabled = true

  /*
  dns_options {
    dns_record_ip_type                             = "ipv4"
    private_dns_only_for_inbound_resolver_endpoint = true
  }
*/

  ip_address_type = "ipv4"

  subnet_configuration {
    ipv4      = "172.16.0.19"
    subnet_id = aws_subnet.triage_ec2_subnet_priv_a.id
  }

  subnet_configuration {
    ipv4      = "172.16.1.19"
    subnet_id = aws_subnet.triage_ec2_subnet_priv_b.id
  }

  subnet_ids = [aws_subnet.triage_ec2_subnet_priv_a.id, aws_subnet.triage_ec2_subnet_priv_b.id]

  security_group_ids = [aws_security_group.triage_ec2_vpce_sg.id]

  tags = {
    Name = "${lower(var.agency_secret)}-triage-ec2-monitoring-endpoint"
  }
}

# Adding missing route tables association