###
### Set up the Terraform state file and providers.
terraform {
  required_version = ">= 1.2.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.75.2"
    }
  }
  backend "local" {}
}

provider "aws" {
  region  = var.region
  profile = var.profile
}

