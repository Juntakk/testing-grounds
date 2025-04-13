# This file will include any data read or generated from the terraform plan

# 00 - AWS - general account data retrieval
# data "aws_partition" "current" {}
data "aws_caller_identity" "current" {}

data "aws_route53_zone" "ats_ibis" {
  provider = aws.TRIAGEINIT

  name         = "${var.top_domain}."
  private_zone = false
}

data "aws_route53_zone" "ibisclearcase" {
  provider = aws.lo-clearcase-lb

  name         = "ibisclearcase.com."
  private_zone = false
}

/*
data "aws_dynamodb_table" "ats_dynamodb" {
  provider = aws.TRIAGEINIT

  name = "ats_agencies"
}

data "aws_dynamodb_table_item" "ats_agency" {
  provider = aws.TRIAGEINIT

  table_name = data.aws_dynamodb_table.ats_dynamodb.name
  key        = <<KEY
    { 
      "id": {"N": "${var.agency_id}"}
      }
  KEY
}
*/

# 02 - AWS - Specific resource retrieval
# 02A - Route53 CloudWatch Log Group
data "aws_cloudwatch_log_group" "triage_route53_log_grp" {
  name = "/aws/route53/resolver"

}

data "aws_route53_resolver_query_log_config" "triage_org_resolver_log_cfg" {
  filter {
    name   = "Name"
    values = ["lo-logging"]
  }
}

# 03 - LO-ClearCase-ALB
data "aws_lb" "lo_clearcase_lb" {
  provider = aws.lo-clearcase-lb

  name = "LO-Clearcase-Redirect"
}

data "aws_lb_listener" "lo_clearcase_lb_https_listener" {
  provider = aws.lo-clearcase-lb

  load_balancer_arn = data.aws_lb.lo_clearcase_lb.arn
  port              = 443
}
