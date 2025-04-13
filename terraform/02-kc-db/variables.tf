# AWS -->
# AWS Profile to use when using the aws provider
/*
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

# <-- AWS

# ** IBIS Clear Case Agency ** 
# Agency Id
variable "agency_id" {
  type    = string
  default = "1"
}

# Key pair
variable "key_pair" {
  type    = string
  default = "soft-dev"
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

# Keycloak Admin Secret
variable "admin_secret" {
  type    = string
  default = ""
}

# Keycloak Client Secret
variable "client_secret" {
  type    = string
  default = ""
}


# Top domain
variable "top_domain" {
  type    = string
  default = "ats-ibis.com"
}

# ATS Version line-up
variable "ats_version" {
  type    = string
  default = "1.1.1"
}

# Ubuntu LTS version
variable "ubuntu_lts" {
  type    = string
  default = "24.04"
}

# ** Environment values ** 

# Initials
# variable "initials" {
#   type = string
# }

# region / hub surname
# variable "country" {
#   type = string
# }

# Environment / Department Name
variable "environment" {
  type = string
}

variable "email" {
  type = string
}

variable "project" {
  type    = string
  default = "ATS"
}

variable "production" {
  type    = string
  default = "True"
}