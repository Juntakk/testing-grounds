# Create the domain

# Create or retrieve the AWS Route 53 zone - top domain should include the NS entries
resource "aws_route53_zone" "triage_ec2_zone" {
  name = "${var.subdomain}.${var.top_domain}"

  tags = {
    Name = "${lower(var.agency_secret)}-triage-ec2-zone"
  }
}

# Create a record on the top domain zone to include NS entries
resource "aws_route53_record" "triage_ec2_record" {
  provider = aws.TRIAGEINIT

  zone_id = data.aws_route53_zone.ats_ibis.id
  name    = aws_route53_zone.triage_ec2_zone.name
  type    = "NS"
  ttl     = "30"
  records = aws_route53_zone.triage_ec2_zone.name_servers
}

resource "aws_route53_record" "triage_ec2_clearcase_record" {
  provider = aws.lo-clearcase-lb

  zone_id = data.aws_route53_zone.ibisclearcase.id
  name    = "${var.subdomain}.ibisclearcase.com"
  type    = "A"

  alias {
    name                   = "dualstack.${data.aws_lb.lo_clearcase_lb.dns_name}"
    zone_id                = data.aws_lb.lo_clearcase_lb.zone_id
    evaluate_target_health = true
  }
}

# Create a Route 53 resolver query log - see CLOUD-49 (https://srv-camtl-jira/jira/browse/CLOUD-49)
/* 
resource "aws_route53_resolver_query_log_config" "triage_ec2_r53_resolver_log_cfg" {
  name = "${lower(var.agency_secret)}-triage-ec2-resolver-cfg"
  destination_arn = data.aws_cloudwatch_log_group.triage_route53_log_grp.arn
}
*/

resource "aws_route53_resolver_query_log_config_association" "triage_ec2_r53_resolver_log_ass" {
  resolver_query_log_config_id = data.aws_route53_resolver_query_log_config.triage_org_resolver_log_cfg.id
  resource_id                  = aws_vpc.triage_ec2_vpc.id
}

