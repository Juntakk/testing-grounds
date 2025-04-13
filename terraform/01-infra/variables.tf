# AWS -->
/*
# AWS Profile to use when using the aws provider
variable "aws_profile" {
  type    = string
  default = "default"
}
*/

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

# Dynamic credentials block for multiple configurations on the same provider
variable "tfc_aws_dynamic_credentials" {
  description = "Object containing AWS dynamic credentials configuration"
  type = object({
    default = object({
      shared_config_file = string
    })
    aliases = map(object({
      shared_config_file = string
    }))
  })

  ephemeral = true
}

variable "triage_bucket_policy" {
  type    = string
  default = "UEFTS3TriageDataReadWrite"
}

# <-- AWS

# ** IBIS Clear Case Agency ** 
# Agency Id
variable "agency_id" {
  type    = string
  default = "1"
}

# Agency subdomain
variable "subdomain" {
  type    = string
  default = "demo"
}

# Agency Secret
variable "agency_secret" {
  type    = string
  default = ""
}

# Top domain
variable "top_domain" {
  type    = string
  default = "ats-ibis.com"
}

# ATS Version line-up
/*
variable "ats_version" {
  type    = string
  default = "1.0.0"
}

# Ubuntu LTS version
variable "ubuntu_lts" {
  type    = string
  default = "24.04"
}
*/

# ** Environment values ** 

# Initials
# variable "initials" {
#   type = string
# }

# region / hub surname
# variable "country" {
#   type = string
# }

# AWS / ARN
variable "admin_access_id" {
  type    = string
  default = "AWSReservedSSO_AWSAdministratorAccess_e67b525e07f96f3e"
}

variable "power_access_id" {
  type    = string
  default = "AWSReservedSSO_AWSPowerUserAccess_e1d454ff4dff9c2c"
}

# Environment / Department Name
variable "environment" {
  type = string
}

variable "email" {
  type = string
}

variable "production" {
  type    = string
  default = "True"
}

variable "project" {
  type    = string
  default = "ATS"
}