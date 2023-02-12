terraform {
  required_version = "~> 1.0.4"

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  backend "s3" {
    bucket = "tjw-terraform"
    key = "kinesis_lambda_tutorial/terraform.tfstate"
    region = "us-east-1"
    profile = "tylerw"
  }
}

provider "aws" {
  region = "us-east-1"
  profile = "tylerw"
}


