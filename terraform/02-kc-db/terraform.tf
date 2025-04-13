terraform {
  cloud {
    organization = "aws-ueft-prod-ats"

    workspaces {
      name    = "ats-ec2-kc-db-<agency_subdomain>"
      project = "<agency_subdomain>"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.58.0"
    }

    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "~> 2.3.5"
    }

    template = {
      source  = "hashicorp/template"
      version = "~> 2.2.0"
    }
  }

  required_version = "~> 1.11.0"
}