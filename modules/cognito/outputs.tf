output "user_pool_id" {
  description = "ID do User Pool do Cognito"
  value       = aws_cognito_user_pool.fiap_tech_challenge_user_pool.id
}

output "user_pool_client_id" {
  description = "ID do cliente do User Pool do Cognito"
  value       = aws_cognito_user_pool_client.fiap_tech_challenge_user_pool_client.id
}
