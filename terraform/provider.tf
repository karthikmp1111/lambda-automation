provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {
    bucket         = "bg-kar-terraform-state"
    key            = "multi-lambda/terraform.tfstate"
    region         = "us-west-1"
    encrypt        = true
  }
}