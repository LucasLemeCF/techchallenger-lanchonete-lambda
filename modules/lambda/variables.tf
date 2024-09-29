variable "region" {
  description = "A região AWS onde os recursos serão criados"
  type        = string
  default     = "sa-east-1"
}

variable "source_dir" {
  description = "Diretório fonte da função Lambda"
  type        = string
  default     = "./modules/lambda"
}

variable "function_name" {
  description = "Nome da função Lambda"
  type        = string
  default     = "fiap_tech_challenge_lambda"
}

variable "handler" {
  description = "Handler da função Lambda"
  type        = string
  default     = "fiap_tech_challenge_lambda.lambda_handler"  # Ajuste o handler para refletir o nome do arquivo e da função
}

variable "runtime" {
  description = "Runtime da função Lambda"
  type        = string
  default     = "python3.8"
}

# Variável para o ID do User Pool do Cognito
variable "user_pool_id" {
  description = "ID do User Pool do Cognito"
  type        = string
}

# Variável para o ID do cliente do User Pool do Cognito
variable "user_pool_client_id" {
  description = "ID do cliente do User Pool do Cognito"
  type        = string
}
