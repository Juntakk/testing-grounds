# This project will create the infrastructure needed to host IBIS ClearCase backend on EC2 instances

# 00 -> AWS general info and AMI retrieval --> see data.tf

/*
locals {
  agency_info = jsondecode(data.aws_dynamodb_table_item.ats_agency.item)
}

locals {
  subdomain   = local.agency_info.subdomain.S
  agency_secret = local.agency_info.secret.S
  # client_secret = local.agency_info.client_secret.S
  # admin_secret  = local.agency_info.admin_secret.S
  # agency_email  = local.agency_info.contact.M.email.S
}
*/

# 02 - Triage database instantiation
# 02A - User data
# 02A - Template configuration
data "template_file" "triage_database_template" {
  template = file("./templates/database.yaml")

  vars = {
    pgbackrest_cfg  = base64encode(templatefile("./templates/pgbackrest.tftpl", { agency = var.subdomain }))
    pgbackrest_cron = base64encode(templatefile("./templates/pgbackrest.cron.tftpl", { agency = var.subdomain }))
    # setup_pgbackrest = base64encode(file("../files/setup_pgbackrest.sh"))
  }
}

# 02A - Cloud Init configuration
data "cloudinit_config" "triage_database_cloudinit_cfg" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/cloud-config"
    content      = data.template_file.triage_database_template.rendered
  }
}


# 02B - Spawn the triage database instance
resource "aws_instance" "triage_database" {
  ami           = data.aws_ami.triage_db.id
  instance_type = "t3a.medium"
  # instance_type = "t3.medium"

  #  key_name = var.key_pair

  iam_instance_profile = data.aws_iam_instance_profile.triage_ec2_instance_profile.name

  subnet_id              = data.aws_subnet.triage_ec2_subnet_priv_a.id
  vpc_security_group_ids = [data.aws_security_group.triage_ec2_pg_sg.id, data.aws_security_group.triage_ec2_priv_to_vpce_sg.id]

  private_ip = "172.16.0.75"

  associate_public_ip_address = false

  /*  
  root_block_device {
    encrypted  = true
    kms_key_id = data.aws_kms_key.ebs_kms_key.arn
  }
  
  ebs_block_device {
    device_name = "/dev/sdb"
    encrypted  = true
    kms_key_id = data.aws_kms_key.ebs_kms_key.arn
  }
*/

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  user_data = data.cloudinit_config.triage_database_cloudinit_cfg.rendered

  tags = {
    Name = "${lower(var.agency_secret)}-triage-database"
  }

  volume_tags = {
    Name = "${lower(var.agency_secret)}-triage-database"
  }
}

# 03 - Triage keycloak instantiation
# 03A - Template configuration
data "template_file" "triage_keycloak_template" {
  template = file("./templates/keycloak.yaml")

  vars = {
    triage_db   = aws_instance.triage_database.private_ip
    agency_name = var.subdomain
  }
}

# 02A - Cloud Init configuration
data "cloudinit_config" "triage_keycloak_cloudinit_cfg" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/cloud-config"
    content      = data.template_file.triage_keycloak_template.rendered
  }
}


# 03B - Spawn the triage keycloak instance
resource "aws_instance" "triage_keycloak" {
  ami           = data.aws_ami.triage_keycloak.id
  instance_type = "t3a.small"
  # instance_type = "t3.small"

  #  key_name = var.key_pair

  iam_instance_profile = data.aws_iam_instance_profile.triage_ec2_instance_profile.name

  # subnet_id              = data.aws_subnet.triage_ec2_subnet_priv_a.id
  subnet_id              = data.aws_subnet.triage_ec2_subnet_priv_a.id
  vpc_security_group_ids = [data.aws_security_group.triage_ec2_http_sg.id, data.aws_security_group.triage_ec2_priv_to_vpce_sg.id]

  private_ip = "172.16.0.60"

  associate_public_ip_address = false

  /*  
  root_block_device {
    encrypted  = true
    kms_key_id = data.aws_kms_key.ebs_kms_key.arn
  }
*/

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  user_data = data.cloudinit_config.triage_keycloak_cloudinit_cfg.rendered

  tags = {
    Name = "${lower(var.agency_secret)}-triage-keycloak"
  }

  volume_tags = {
    Name = "${lower(var.agency_secret)}-triage-keycloak"
  }
}
