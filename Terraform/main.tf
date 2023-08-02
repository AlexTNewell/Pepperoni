terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.primary_region
}

module "template_files" {
  source   = "hashicorp/dir/template"
  base_dir = "${path.module}/website-resources"
}
