# Output variables
output "dynamodb_agency_name" {
  description = "Dynamo DB agency "
  #  value       = jsondecode(data.aws_dynamodb_table_item.ats_agency.item)
  value = var.subdomain
}

output "triage_database_private_ip" {
  description = "Triage Database EC2 Private Ip"
  value       = aws_instance.triage_database.private_ip
}

output "triage_keycloak_private_ip" {
  description = "Triage Compute EC2 Private Ip"
  value       = aws_instance.triage_keycloak.private_ip
}

/*
output "cloudinit_cfg" {
  description = "Triage Database user data"
  value       = data.cloudinit_config.triage_database_cloudinit_cfg.rendered
}
*/