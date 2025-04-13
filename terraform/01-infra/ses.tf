# Create AWS SES related resources
/*
resource "aws_ses_domain_identity" "triage_ec2_ses_domain_id" {
  domain = "${local.agency_name}.${var.top_domain}"
}

resource "aws_route53_record" "triage_ec2_ses_route53_record" {
  zone_id = aws_route53_zone.triage_ec2_zone.id
  name    = "_amazonses.${local.agency_name}.${var.top_domain}"
  type    = "TXT"
  ttl     = 600
  records = [aws_ses_domain_identity.triage_ec2_ses_domain_id.verification_token]
}

resource "aws_ses_domain_identity_verification" "triage_ec2_ses_domain_id_verif" {
  domain = aws_ses_domain_identity.triage_ec2_ses_domain_id.id

  depends_on = [aws_route53_record.triage_ec2_ses_route53_record]
}

resource "aws_ses_domain_dkim" "triage_ec2_ses_domain_dkim" {
  domain = aws_ses_domain_identity.triage_ec2_ses_domain_id.domain
}

resource "aws_route53_record" "triage_ec2_ses_route53_dkim_record" {
  count   = 3
  zone_id = aws_route53_zone.triage_ec2_zone.id
  name    = "${aws_ses_domain_dkim.triage_ec2_ses_domain_dkim.dkim_tokens[count.index]}._domainkey"
  type    = "CNAME"
  ttl     = "600"
  records = ["${aws_ses_domain_dkim.triage_ec2_ses_domain_dkim.dkim_tokens[count.index]}.dkim.amazonses.com"]
}
*/