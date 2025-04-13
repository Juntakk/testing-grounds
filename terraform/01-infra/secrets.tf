# KMS resource creation
# One KMS per agency to encrypt both EBS and S3 bucket and SSM

data "aws_iam_policy_document" "triage_ec2_kms_policy_doc" {
  statement {
    effect    = "Allow"
    actions   = ["kms:*"]
    resources = ["*"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }
  statement {
    effect = "Allow"
    sid    = "Allow access for Key Administrators"
    actions = [
      "kms:Create*",
      "kms:Describe*",
      "kms:Enable*",
      "kms:List*",
      "kms:Put*",
      "kms:Update*",
      "kms:Revoke*",
      "kms:Disable*",
      "kms:Get*",
      "kms:Delete*",
      "kms:TagResource",
      "kms:UntagResource",
      "kms:ScheduleKeyDeletion",
      "kms:CancelKeyDeletion"
    ]
    resources = ["*"]
    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-controltower-AdministratorExecutionRole",
        #       "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-reserved/sso.amazonaws.com/AWSReservedSSO_AWSAdministratorAccess_e67b525e07f96f3e"
        #"arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-reserved/sso.amazonaws.com/AWSReservedSSO_AWSAdministratorAccess_aefecc289a5d9199"
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-reserved/sso.amazonaws.com/${var.admin_access_id}",
      ]
    }
  }

  statement {
    sid    = "Allow use of the key"
    effect = "Allow"
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    resources = ["*"]
    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/ssm.amazonaws.com/AWSServiceRoleForAmazonSSM",
        #        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-reserved/sso.amazonaws.com/AWSReservedSSO_AWSAdministratorAccess_e67b525e07f96f3e",
        #        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-reserved/sso.amazonaws.com/AWSReservedSSO_AWSPowerUserAccess_e1d454ff4dff9c2c",
        #"arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-reserved/sso.amazonaws.com/AWSReservedSSO_AWSAdministratorAccess_aefecc289a5d9199",
        #"arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-reserved/sso.amazonaws.com/AWSReservedSSO_AWSPowerUserAccess_5f5eb85d24f40277",
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-reserved/sso.amazonaws.com/${var.admin_access_id}",
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-reserved/sso.amazonaws.com/${var.power_access_id}",
        aws_iam_role.s3_access_role.arn
        #        "arn:aws:iam::366960679739:root"
      ]
    }
  }

  statement {
    sid    = "Allow attachment of persistent resources"
    effect = "Allow"
    actions = [
      "kms:CreateGrant",
      "kms:ListGrants",
      "kms:RevokeGrant"
    ]
    resources = ["*"]
    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/ssm.amazonaws.com/AWSServiceRoleForAmazonSSM",
        #        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-reserved/sso.amazonaws.com/AWSReservedSSO_AWSAdministratorAccess_e67b525e07f96f3e",
        #        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-reserved/sso.amazonaws.com/AWSReservedSSO_AWSPowerUserAccess_e1d454ff4dff9c2c",
        #"arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-reserved/sso.amazonaws.com/AWSReservedSSO_AWSAdministratorAccess_aefecc289a5d9199",
        #"arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-reserved/sso.amazonaws.com/AWSReservedSSO_AWSPowerUserAccess_5f5eb85d24f40277",
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-reserved/sso.amazonaws.com/${var.admin_access_id}",
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-reserved/sso.amazonaws.com/${var.power_access_id}"
        #        "arn:aws:iam::366960679739:root"
      ]
    }
    condition {
      test     = "Bool"
      variable = "kms:GrantIsForAWSResource"
      values   = ["true"]
    }
  }
}

resource "aws_kms_key" "triage_ec2_kms_key" {
  description = "key for ${var.agency_secret} agency"

  deletion_window_in_days = 7

  tags = {
    Name = "${lower(var.agency_secret)}-triage-ec2-key"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_kms_key_policy" "triage_ec2_kms_key_policy" {
  key_id = aws_kms_key.triage_ec2_kms_key.key_id
  policy = data.aws_iam_policy_document.triage_ec2_kms_policy_doc.json
}

resource "aws_kms_alias" "triage_ec2_kms_alias" {
  name          = "alias/${lower(var.agency_secret)}-triage-ec2"
  target_key_id = aws_kms_key.triage_ec2_kms_key.key_id
}