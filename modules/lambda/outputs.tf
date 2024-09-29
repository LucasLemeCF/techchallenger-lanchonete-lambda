output "lambda_function_name" {
  description = "Nome da função Lambda"
  value       = aws_lambda_function.tech_challenge_auth_lambda.function_name
}
