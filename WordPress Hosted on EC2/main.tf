terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    docker = {
      source = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

provider "aws" {
  region = var.primary_region
}

provider "docker" {
  version = "~> 3.0.2"
  host    = "unix:///var/run/docker.sock"
}

module "template_files" {
  source   = "hashicorp/dir/template"
  base_dir = "${path.module}/website-resources"
}
