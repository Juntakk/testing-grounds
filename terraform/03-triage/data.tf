# This file will include any data read or generated from the terraform plan

# 00 - AWS - general account data retrieval
# data "aws_partition" "current" {}
# data "aws_caller_identity" "current" {}

data "aws_route53_zone" "triage_ec2_zone" {
  name         = "${var.subdomain}.${var.top_domain}"
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

data "http" "triage_agency_json" {
  url          = "https://k90lg7ir9g.execute-api.us-east-1.amazonaws.com/service/data"
  method       = "POST"
  request_body = "{ \"code\": \"${var.agency_secret}\" }"
}

# 01 - AWS - Retrieve all the needed AMIs
# 01A - triage_compute AMI on ${var.ubuntu_lts}
data "aws_ami" "triage_compute" {
  #  provider = aws

  filter {
    name   = "name"
    values = ["ATS-${var.ats_version}-COMPUTE-${var.ubuntu_lts}*"]
  }

  owners = ["397286250265"] # Development AWS ID 

  most_recent = true
}

# 01D - triage_web (apache and fastapi) on 22.04 - issue with one apache module
data "aws_ami" "triage_web" {
  #  provider = aws

  filter {
    name   = "name"
    values = ["ATS-${var.ats_version}-WEB-${var.ubuntu_lts}*"]
  }

  owners = ["397286250265"] # Development AWS ID 

  most_recent = true
}

# 2 - AWS IAM Instance Profile
data "aws_iam_instance_profile" "triage_ec2_instance_profile" {
  #  provider = aws

  name = "${lower(var.agency_secret)}-triage-ec2-s3-rw-instance"

}

# 3 - Triage database and keycloak instance

data "aws_instance" "triage_database" {
  #  provider = aws

  instance_tags = {
    Name = "${lower(var.agency_secret)}-triage-database"
  }

}

data "aws_instance" "triage_keycloak" {
  #  provider = aws

  instance_tags = {
    Name = "${lower(var.agency_secret)}-triage-keycloak"
  }

}
