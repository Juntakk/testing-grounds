# Output variables
output "triage_ec2_route53_zone_id" {
  description = "Route 53 zone id"
  value       = aws_route53_zone.triage_ec2_zone.zone_id
}

output "dynamodb_subdomain" {
  description = "Dynamo DB agency "
  #  value       = jsondecode(data.aws_dynamodb_table_item.ats_agency.item)
  value = var.subdomain
}

output "triage_ec2_elb_dns" {
  description = "Application Load-Balancer DNS"
  value       = aws_lb.triage_ec2_alb.dns_name
}

output "triage_ec2_acm_cert_arn" {
  description = "ACM certificate ARN"
  value       = aws_acm_certificate.triage_ec2_cert.arn
}
