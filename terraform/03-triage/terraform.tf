terraform {
  cloud {
    organization = "aws-ueft-prod-ats"

    workspaces {
      name    = "ats-ec2-triage-<agency_subdomain>"
      project = "<agency_subdomain>"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.58.0"
    }

    template = {
      source  = "hashicorp/template"
      version = "~> 2.2.0"
    }
  }

  required_version = "~> 1.11.0"
}