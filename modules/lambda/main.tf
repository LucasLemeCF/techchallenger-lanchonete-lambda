provider "aws" {
  region = var.region
}

data "aws_caller_identity" "current" {}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = var.source_dir
  output_path = "./modules/lambda/fiap_tech_challenge_lambda.zip"
}

resource "aws_iam_role" "tech_challenge_lambda_exec" {
  name = "tech_challenge_lambda_exec_role_${random_string.suffix.result}"

  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Effect": "Allow",
        "Principal": {
          "Service": "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

resource "aws_iam_role_policy_attachment" "tech_challenge_lambda_policy" {
  role       = aws_iam_role.tech_challenge_lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "aws_iam_policy_document" "cognito_policy" {
  statement {
    actions = [
      "cognito-idp:ListUsers",
      "cognito-idp:AdminGetUser",
      "cognito-idp:AdminCreateUser",
      "cognito-idp:AdminDeleteUser",
      "cognito-idp:AdminInitiateAuth"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "cognito_policy" {
  name        = "CognitoAccessPolicy"
  description = "Permissões para acessar o Amazon Cognito"
  policy      = data.aws_iam_policy_document.cognito_policy.json
}

resource "aws_iam_role_policy_attachment" "cognito_policy_attachment" {
  role       = aws_iam_role.tech_challenge_lambda_exec.name
  policy_arn = aws_iam_policy.cognito_policy.arn
}

resource "aws_lambda_function" "tech_challenge_auth_lambda" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = var.function_name
  role             = aws_iam_role.tech_challenge_lambda_exec.arn
  handler          = var.handler
  runtime          = var.runtime
  source_code_hash = filebase64sha256(data.archive_file.lambda_zip.output_path)

  environment {
    variables = {
      USER_POOL_ID         = var.user_pool_id
      USER_POOL_CLIENT_ID  = var.user_pool_client_id
    }
  }
}
