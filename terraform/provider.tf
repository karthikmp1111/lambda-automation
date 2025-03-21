terraform {
  backend "s3" {
    bucket         = "bg-kar-terraform-state"
    key            = "lambda/state/terraform.tfstate"
    region         = "us-west-1"
    encrypt        = true
    dynamodb_table = "bg-kar-terraform-lock"
  }
}

provider "aws" {
  region = var.aws_region
}
