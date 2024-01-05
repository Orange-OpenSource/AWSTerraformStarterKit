terraform {
  required_version = "~> 1.4.0"
  required_providers {
    aws = ">= 5.0"
    random = {
      source  = "hashicorp/random"
      version = "~> 3.4"
    }
  }
}
