terraform {
  required_providers {
    snowflake = {
      source  = "chanzuckerberg/snowflake"
      version = "0.23.0"
    }
  }
}

provider "snowflake" {
  region = "us-east-1"
}

provider "aws" {
  region = "us-east-1"
}

data "aws_caller_identity" "current" {}

data "aws_s3_bucket" "selected" {
  bucket = var.s3_bucket_name
}
