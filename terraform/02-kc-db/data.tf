# This file will include any data read or generated from the terraform plan

# 00 - AWS - general account data retrieval
# data "aws_partition" "current" {}
# data "aws_caller_identity" "current" {}

/*
data "aws_route53_zone" "ats_ibis" {
  name         = "${var.top_domain}."
  private_zone = false
  provider     = aws.prod-ats
}
*/

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

# 01 - AWS - Retrieve all the needed AMIs

# 01B - triage_db AMI on ${var.ubuntu_lts}
data "aws_ami" "triage_db" {
  #  provider = aws

  filter {
    name   = "name"
    values = ["ATS-${var.ats_version}-DB-*-${var.ubuntu_lts}*"]
  }

  owners = ["397286250265"] # Development AWS ID 

  most_recent = true

}

# 01C - triage_keycloak on ${var.ubuntu_lts}
data "aws_ami" "triage_keycloak" {
  #  provider = aws

  filter {
    name   = "name"
    values = ["ATS-${var.ats_version}-KC-*-${var.ubuntu_lts}*"]
  }

  owners = ["397286250265"] # Development AWS ID 

  most_recent = true
}

# 02 - AWS IAM instance profile
data "aws_iam_instance_profile" "triage_ec2_instance_profile" {
  #  provider = aws

  name = "${lower(var.agency_secret)}-triage-ec2-s3-rw-instance"
}

# 03 - AWS KMS key
data "aws_kms_key" "triage_ec2_kms_key" {
  key_id = "alias/${lower(var.agency_secret)}-triage-ec2"
}

/*
data "aws_kms_key" "ebs_kms_key" {
  key_id = "alias/EBS-Default-Encryption"
}
*/

