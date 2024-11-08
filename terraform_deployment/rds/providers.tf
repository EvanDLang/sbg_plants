terraform {
  required_providers {

    aws = {
      source  = "hashicorp/aws"
    }

    postgresql = {
      source  = "cyrilgdn/postgresql"
    }
  }
}

provider "aws" {
    region = "us-west-2"
}