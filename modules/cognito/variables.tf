variable "region" {
  description = "A região AWS onde os recursos serão criados"
  type        = string
  default     = "sa-east-1"
}

variable "user_pool_name" {
  description = "Nome do User Pool do Cognito"
  type        = string
  default     = "fiap_tech_challenge_user_pool"
}

variable "user_pool_client_name" {
  description = "Nome do cliente do User Pool do Cognito"
  type        = string
  default     = "fiap_tech_challenge_user_pool_client"
}
