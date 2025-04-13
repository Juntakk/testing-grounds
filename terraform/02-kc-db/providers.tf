provider "aws" {

  region = var.aws_region

  shared_config_files = [var.tfc_aws_dynamic_credentials.default.shared_config_file]

  #  shared_config_files      = ["aws_config"]
  #  shared_credentials_files = ["aws_credentials"]
  #  profile                  = var.aws_profile

  default_tags {
    tags = {
      Environment    = var.environment
      E-Mail         = var.email
      Project        = var.project
      InstantiatedBy = "Terraform"
      Production     = var.production
      AgencyName     = replace(replace(local.agency_info.name.S, " & ", ""), " - ", "-")
    }
  }
}

provider "aws" {
  alias = "TRIAGEINIT"
  # region = var.aws_region
  region = "us-east-1"

  shared_config_files = [var.tfc_aws_dynamic_credentials.aliases["TRIAGEINIT"].shared_config_file]

  #  shared_config_files      = ["aws_config"]
  #  shared_credentials_files = ["aws_credentials"]
  #  profile                  = "production-ats"
}
