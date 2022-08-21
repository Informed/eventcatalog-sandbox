###
### Set up the Terraform state file and providers.

###
### Using locals to form variables by concatinating input variables
### Unfortunately can not do that in variables.tf or <env>.tfvars
###
locals {
  fqdn = "${var.app_name}-${var.project_name}.${var.environment}.${var.base_domain_name}"
  # alt_fqdns a placeholder for now. May want to make alt_fqds a variable. It
  # needs to be a list of strings Used by cloudfront.tf to specify aliases for
  # the certificate and DNS but its kind of hard to support that with the sso
  # callback
  alt_fqdns   = []
  zone_name   = "${var.environment}.${var.base_domain_name}"
  lambda_name = "${var.environment}-${var.project_name}-${var.app_name}-${var.lambda_name_suffix}"
}

terraform {
  required_version = ">= 1.2.0"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      # Need to use version < 4.0.0 to work with cloudposse/cloudfront-s3-cdn
      version = ">= 3.75.2"
    }
  }
  # You should use a different state management than local
  backend "local" {}
}

provider "aws" {
  region  = var.region
  profile = var.profile
}
