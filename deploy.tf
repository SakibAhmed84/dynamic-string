# Setup AWS provider
terraform {
    required_providers {
      aws = {
        source = "hashicorp/aws"
        version = "~> 5.20.0"
      }
    }
}

provider "aws" {
    region = "eu-west-2"
    access_key = var.access_key # defined in secrets.tf
    secret_key = var.secret_key # defined in secrets.tf
}

# Create an IAM Role that will let lambda to access DynamoDB
resource "aws_iam_role" "lambda_dynamodb_access_role" {
  name = "LambdaDynamoDBAccessRole" 
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com" 
        }
      }
    ]
  })
}

# Attach an existing DynamoDB Full Access Policy to the IAM role
resource "aws_iam_policy_attachment" "dynamodb_full_access_attachment" {
  name       = "DynamoDBFullAccessAttachment"
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
  roles      = [aws_iam_role.lambda_dynamodb_access_role.name]
}

# Create DynamoDB Table 
resource "aws_dynamodb_table" "db-dynamic-string" {
  name           = "db-dynamic-string" 
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "id" 

  attribute {
    name = "id"
    type = "S" # S for string, N for number, B for binary
  }
}

# Create Lambda Function with a Function URL to Read the Dynamic Text and Display as HTML
resource "aws_lambda_function" "dynamic_string_html" {
  filename         = "packages/dynamic-string-html/dynamic-string-html.zip"
  function_name    = "dynamic-string-html"
  role             = aws_iam_role.lambda_dynamodb_access_role.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.11"
}

resource "aws_lambda_function_url" "dynamic_string_html_url" {
  function_name      = aws_lambda_function.dynamic_string_html.arn
  authorization_type = "NONE"
}

# Create Lambda Function with a Function URL to Write to the DynamoDB Table to Change the String Variable
resource "aws_lambda_function" "dynamic_string_updater" {
  filename         = "packages/dynamic-string-updater/dynamic-string-updater.zip"
  function_name    = "dynamic-string-updater"
  role             = aws_iam_role.lambda_dynamodb_access_role.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.11"
}

resource "aws_lambda_function_url" "dynamic_string_updater_url" {
  function_name      = aws_lambda_function.dynamic_string_updater.arn
  authorization_type = "NONE"
}

# Output the Dynamic String HTML Page URL
output "output_dynamic_string_html_url" {
  value = aws_lambda_function_url.dynamic_string_html_url.function_url
}

# Output the Dynamic String Updater URL
output "output_dynamic_string_updater_url" {
  value = aws_lambda_function_url.dynamic_string_updater_url.function_url
}


