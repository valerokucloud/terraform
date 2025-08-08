terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.4.0"
    }
    random = {
      source = "hashicorp/random"
      version = "3.7.2"
    }
  }
  required_version = "~>1.12.0"
}

// Declaración de zonas:
provider "aws" {
  region = "eu-west-3"
  default_tags {
    tags = var.tags
  }
}

provider "aws" {
  region = "eu-west-2"
  alias  = "London"
}