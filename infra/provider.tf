###### root/provider.tf ######

terraform {
  required_version = "~> 1.11.4"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.9.5"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.1"
    }
  }
}

# AWS Provider Configuration
provider "aws" {
  region = var.region
}
