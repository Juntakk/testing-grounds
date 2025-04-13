# Create SSL certificates

# ACM certificate request for ats-ibis.com domain
resource "aws_acm_certificate" "triage_ec2_cert" {
  provider = aws.acm

  domain_name               = aws_route53_zone.triage_ec2_zone.name
  subject_alternative_names = ["www.${aws_route53_zone.triage_ec2_zone.name}"]
  validation_method         = "DNS"

  validation_option {
    domain_name       = aws_route53_zone.triage_ec2_zone.name
    validation_domain = var.top_domain
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "${lower(var.agency_secret)}-triage-ec2-cert"
  }
}


# Route 53 record for certificate validation
resource "aws_route53_record" "triage_ec2_records" {
  for_each = {
    for dvo in aws_acm_certificate.triage_ec2_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.triage_ec2_zone.id
}

# Certificate validation
resource "aws_acm_certificate_validation" "triage_ec2_cert_validation" {
  provider                = aws.acm
  certificate_arn         = aws_acm_certificate.triage_ec2_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.triage_ec2_records : record.fqdn]
}


# ACM certificate request for ibisclearcase.com domain

resource "aws_acm_certificate" "triage_ec2_clearcase_cert" {
  provider = aws.lo-clearcase-lb

  domain_name = "${var.subdomain}.ibisclearcase.com"
  #  subject_alternative_names = ["*.${var.agency_name}.ibisclearcase.com"]
  validation_method = "DNS"

  validation_option {
    domain_name       = "${var.subdomain}.ibisclearcase.com"
    validation_domain = "ibisclearcase.com"
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "${lower(var.agency_secret)}-triage-ec2-cert"
  }

}

# Route 53 record for certificate validation
resource "aws_route53_record" "triage_ec2_clearcase_records" {
  provider = aws.lo-clearcase-lb

  for_each = {
    for dvo in aws_acm_certificate.triage_ec2_clearcase_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.ibisclearcase.zone_id

}

# Certificate validation
resource "aws_acm_certificate_validation" "triage_ec2_cert_clearcase_validation" {
  provider = aws.lo-clearcase-lb

  certificate_arn         = aws_acm_certificate.triage_ec2_clearcase_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.triage_ec2_clearcase_records : record.fqdn]

}