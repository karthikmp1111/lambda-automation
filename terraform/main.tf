terraform {
  backend "s3" {
    bucket         = "bg-kar-terraform-state"
    key            = "terraform.tfstate"
    region         = "us-west-1"
    dynamodb_table = "bg-kar-terraform-lock"
    encrypt        = true
  }
}

locals {
  lambda_files = { for name in var.lambda_names : name => filebase64sha256(abspath("${path.module}/../lambda-functions/${name}/package.zip")) }
}

resource "aws_lambda_function" "lambda" {
  for_each      = local.lambda_files
  function_name = each.key
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.lambda_handler"
  runtime       = "python3.8"

  filename         = abspath("${path.module}/../lambda-functions/${each.key}/package.zip")
  source_code_hash = each.value
  publish = true

  environment {
    variables = {
      ENV = "dev"
    }
  }
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda_execution_role_test"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "bg-kar-terraform-state"
}

resource "aws_s3_bucket_versioning" "terraform_state_versioning" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state_encryption" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_dynamodb_table" "terraform_lock" {
  name         = "bg-kar-terraform-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
