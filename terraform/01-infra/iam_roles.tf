# IAM Roles and Policy resources creation

# Policy document to allow EC2 Service the to-be defined role
data "aws_iam_policy_document" "triage_sts_assume" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = [
        "ec2.amazonaws.com"
      ]
    }
  }
}

# S3 Bucket Access policy document for triage-database and triage-compute instances
data "aws_iam_policy_document" "triage_s3_rw_policy" {
  statement {
    effect = "Allow"
    actions = [
      "kms:DescribeCustomKeyStores",
      "s3:ListAllMyBuckets"
    ]
    resources = ["*"]
  }

  /*
  statement {
    effect = "Allow"
    actions = [
      "s3:ListBucket"
    ]
    resources = [aws_s3_bucket.triage_ec2_s3_bucket.arn]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:PutObjectTagging",
      "s3:DeleteObject",
      "s3:GetEncryptionConfiguration"
    ]
    resources = ["${aws_s3_bucket.triage_ec2_s3_bucket.arn}/*"]
  }
  */

  statement {
    effect = "Allow"
    actions = [
      "kms:DescribeKey",
      "kms:Encrypt",
      "kms:GenerateDataKey*",
      "kms:Decrypt",
      "kms:ReEncrypt*"
    ]
    resources = [aws_kms_key.triage_ec2_kms_key.arn]
    #    ,"arn:aws:kms:us-east-1:656097659003:key/110d5990-0209-4c86-aaeb-b7f86192d089"]
  }
}

data "aws_iam_policy_document" "triage_ssm_priv_access_policy" {
  # Required for SSM VPC endpoint for SSM to correctly manage without a public IP address
  # See https://docs.aws.amazon.com/systems-manager/latest/userguide/setup-instance-permissions.html
  statement {
    effect  = "Allow"
    actions = ["s3:GetObject"]
    resources = [
      "arn:aws:s3:::aws-ssm-${var.aws_region}/*",
      "arn:aws:s3:::aws-windows-downloads-${var.aws_region}/*",
      "arn:aws:s3:::amazon-ssm-${var.aws_region}/*",
      "arn:aws:s3:::amazon-ssm-packages-${var.aws_region}/*",
      "arn:aws:s3:::${var.aws_region}-birdwatcher-prod/*",
      "arn:aws:s3:::aws-ssm-distributor-file-${var.aws_region}/*",
      "arn:aws:s3:::aws-ssm-document-attachments-${var.aws_region}/*",
      "arn:aws:s3:::patch-baseline-snapshot-${var.aws_region}/*",
      "arn:aws:s3:::aws-patchmanager-macos-${var.aws_region}/*"
    ]
  }

  /*
  statement {
    effect = "Allow"
    actions = [
      "ssm:UpdateInstanceInformation",
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel",
      "ec2:"
    ]
    resources = ["*"]
  }
*/

  statement {
    effect = "Allow"
    actions = [
      "kms:Encrypt",
      "kms:Decrypt"
    ]
    resources = [aws_kms_key.triage_ec2_kms_key.arn]
  }
}


# S3 Bucket access policy
resource "aws_iam_policy" "s3_pgbackrest_policy" {
  name        = "${lower(var.agency_secret)}-triage-ec2-s3-rw-policy"
  description = "IAM policy to allow access to S3 bucket"

  policy = data.aws_iam_policy_document.triage_s3_rw_policy.json

  tags = {
    Name = "${lower(var.agency_secret)}-triage-ec2-s3-rw-policy"
  }
}

resource "aws_iam_policy" "triage_ssm_priv_vpc_policy" {
  name        = "${lower(var.agency_secret)}-triage-ec2-ssm-vpc-policy"
  description = "IAM policy to allow SSM access from private VPC"

  policy = data.aws_iam_policy_document.triage_ssm_priv_access_policy.json

  tags = {
    Name = "${lower(var.agency_secret)}-triage-ec2-ssm-vpc-policy"
  }
}


// -- to be discussed --
/*
data "aws_iam_policy" "triage_prod_s3_rw_policy" {
  name = "LOS3TriageProdReadWrite"
}
*/


data "aws_iam_policy" "triage_data_s3_rw_policy" {
  name = var.triage_bucket_policy
}

data "aws_iam_policy" "triage_lo_offsite_policy" {
  name = "LOS3TriageOffsiteReadWrite"
}

data "aws_iam_policy" "triage_lo_ssm_agent_policy" {
  name = "LO-SSMManagedEC2Instance"
}

# IAM Role for S3 bucket access
resource "aws_iam_role" "s3_access_role" {
  name               = "${lower(var.agency_secret)}-triage-ec2-s3-rw-role"
  description        = "IAM Role to allow access to S3 bucket"
  assume_role_policy = data.aws_iam_policy_document.triage_sts_assume.json

  tags = {
    Name = "${lower(var.agency_secret)}-triage-ec2-s3-rw-role"
  }
}

resource "aws_iam_role_policy_attachment" "triage_s3_policy_att" {
  role       = aws_iam_role.s3_access_role.name
  policy_arn = aws_iam_policy.s3_pgbackrest_policy.arn
}

resource "aws_iam_role_policy_attachment" "triage_ec2_ssm_priv_policy_att" {
  role       = aws_iam_role.s3_access_role.name
  policy_arn = aws_iam_policy.triage_ssm_priv_vpc_policy.arn
}

/*
resource "aws_iam_role_policy_attachment" "triage_ec2_triage_prod_rw_att" {
  role       = aws_iam_role.s3_access_role.name
  policy_arn = data.aws_iam_policy.triage_prod_s3_rw_policy.arn
}
*/

resource "aws_iam_role_policy_attachment" "triage_ec2_triage_data_rw_att" {
  role       = aws_iam_role.s3_access_role.name
  policy_arn = data.aws_iam_policy.triage_data_s3_rw_policy.arn
}

resource "aws_iam_role_policy_attachment" "triage_ec2_triage_offsite_att" {
  role       = aws_iam_role.s3_access_role.name
  policy_arn = data.aws_iam_policy.triage_lo_offsite_policy.arn
}

resource "aws_iam_role_policy_attachment" "triage_ec2_ssm_policy_att" {
  role       = aws_iam_role.s3_access_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "triage_ec2_ssm_default_policy_att" {
  role       = aws_iam_role.s3_access_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedEC2InstanceDefaultPolicy"
}

resource "aws_iam_role_policy_attachment" "triage_ec2_ecr_reado" {
  role       = aws_iam_role.s3_access_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "triage_ec2_cw_policy_att" {
  role       = aws_iam_role.s3_access_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role_policy_attachment" "triage_ec2_lo_ssm_agent_att" {
  role       = aws_iam_role.s3_access_role.name
  policy_arn = data.aws_iam_policy.triage_lo_ssm_agent_policy.arn
}

# IAM Instance Profile for S3 bucket access
resource "aws_iam_instance_profile" "triage_ec2_instance_profile" {
  name = "${lower(var.agency_secret)}-triage-ec2-s3-rw-instance"
  role = aws_iam_role.s3_access_role.name

  tags = {
    Name = "${lower(var.agency_secret)}-triage-ec2-s3-rw-instance"
  }
}
