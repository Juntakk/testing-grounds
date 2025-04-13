# This project will create the infrastructure needed to host IBIS ClearCase backend on EC2 instances

# 00 -> AWS general info and AMI retrieval --> see data.tf
/*
locals {
  agency_info = jsondecode(data.aws_dynamodb_table_item.ats_agency.item)
}

locals {
  subdomain     = local.agency_info.subdomain.S
  agency_secret = local.agency_info.secret.S
  client_secret = local.agency_info.client_secret.S
  admin_secret  = local.agency_info.admin_secret.S
  jwt           = local.agency_info.jwt.S
  #  agency_email  = local.agency_info.contact.M.email.S
}
*/

# 01 - Triage compute instantiation
# 01A - Template configuration
data "template_file" "triage_compute_template" {
  template = file("./templates/compute.yaml")
}

# 01B - Spawn the triage compute instance
resource "aws_instance" "triage_compute" {
  ami           = data.aws_ami.triage_compute.id
  instance_type = var.compute_instance

  #  key_name = var.key_pair

  iam_instance_profile = data.aws_iam_instance_profile.triage_ec2_instance_profile.name

  # subnet_id = data.aws_subnet.triage_ec2_subnet_pub_a.id
  subnet_id              = data.aws_subnet.triage_ec2_subnet_priv_a.id
  vpc_security_group_ids = [data.aws_security_group.triage_ec2_ssh_sg.id, data.aws_security_group.triage_ec2_http_sg.id, data.aws_security_group.triage_ec2_vpce_sg.id, data.aws_security_group.triage_ec2_priv_to_vpce_sg.id]

  # private_ip = "172.16.2.50"
  private_ip = "172.16.0.50"

  associate_public_ip_address = false
  # associate_public_ip_address = true

  /*
  root_block_device {
    encrypted  = true
    kms_key_id = aws_kms_key.triage_ec2_kms_key.id
  }
  */

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  tags = {
    Name = "${lower(var.agency_secret)}-triage-compute"
  }

  volume_tags = {
    Name = "${lower(var.agency_secret)}-triage-compute"
  }

  user_data = data.template_file.triage_compute_template.rendered
}

# 04 - Triage web instantiation
# 04A - Template configuration
data "template_file" "triage_web_template" {
  template = file("./templates/web.yaml")

  vars = {
    web_cfg     = base64encode(templatefile("./templates/vhosts.tftpl", { subdomain = var.subdomain, client_secret = var.client_secret }))
    restapi_env = base64encode(templatefile("./templates/restapi-env.tftpl", { subdomain = var.subdomain, client_secret = var.client_secret }))
    #    agency_json     = base64encode(templatefile("./templates/agency.json.tftpl", { agency_id = var.agency_id, subdomain = var.agency_name, agency_secret = var.agency_secret, admin_secret = var.admin_secret, client_secret = var.client_secret, jwt = var.jwt }))
    agency_json     = data.http.triage_agency_json.response_body_base64
    triage_db       = data.aws_instance.triage_database.private_ip
    triage_keycloak = data.aws_instance.triage_keycloak.private_ip
  }
}

# 04B - Spawn the triage web instance
resource "aws_instance" "triage_web" {
  ami = data.aws_ami.triage_web.id
  # instance_type = "t3.small"
  instance_type = "t3a.small"

  #  key_name = var.key_pair

  iam_instance_profile = data.aws_iam_instance_profile.triage_ec2_instance_profile.name

  subnet_id              = data.aws_subnet.triage_ec2_subnet_priv_a.id
  vpc_security_group_ids = [data.aws_security_group.triage_ec2_http_sg.id, data.aws_security_group.triage_ec2_vpce_sg.id, data.aws_security_group.triage_ec2_priv_to_vpce_sg.id]

  private_ip = "172.16.0.80"

  associate_public_ip_address = false

  /*
  root_block_device {
    encrypted  = true
    kms_key_id = aws_kms_key.triage_ec2_kms_key.id
  }
*/

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  user_data = data.template_file.triage_web_template.rendered

  tags = {
    Name = "${lower(var.agency_secret)}-triage-web"
  }

  volume_tags = {
    Name = "${lower(var.agency_secret)}-triage-web"
  }
}
