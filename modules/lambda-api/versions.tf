terraform {
  required_version = ">= 1.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.31"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.6"
    }
  }
}