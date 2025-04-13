# This project will create the infrastructure needed to host IBIS ClearCase backend on EC2 instances

# 00 -> AWS general info and AMI retrieval --> see data.tf

/*
locals {
  agency_info = jsondecode(data.aws_dynamodb_table_item.ats_agency.item)
}

locals {
  subdomain     = local.agency_info.subdomain.S
  agency_secret = local.agency_info.secret.S
  # client_secret = local.agency_info.client_secret.S
  # admin_secret  = local.agency_info.admin_secret.S
  # agency_email  = local.agency_info.contact.M.email.S
}
*/
