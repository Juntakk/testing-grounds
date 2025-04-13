# Output variables

output "dynamodb_agency_name" {
  description = "Dynamo DB agency "
  #  value       = jsondecode(data.aws_dynamodb_table_item.ats_agency.item)
  value = var.subdomain
}

/*
output "triage_compute_public_ip" {
  description = "Triage Compute EC2 Public Ip"
  value       = aws_instance.triage_compute.public_ip
}
*/

output "triage_web_private_ip" {
  description = "Triage Web EC2 Private Ip"
  value       = aws_instance.triage_web.private_ip
}

/*
output "triage_agency_json" {
  description = "Agency Json received from API Url"
  value       = jsondecode(data.http.triage_agency_json.response_body)
}
*/