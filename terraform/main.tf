###
### Set up the Terraform state file and providers.

locals {
  fqdn        = "${var.app_name}-${var.project_name}.${var.environment}.${var.base_domain_name}"
  alt_fqdn    = "${var.app_name}.${var.environment}.${var.base_domain_name}"
  zone_name   = "${var.environment}.${var.base_domain_name}"
  lambda_name = "${var.app_name}_${var.environment}_000"
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
