provider "aws" {
  region = var.region
}

resource "aws_cognito_user_pool" "fiap_tech_challenge_user_pool" {
  name = var.user_pool_name

  password_policy {
    minimum_length    = 8
    require_lowercase = true
    require_uppercase = true
    require_numbers   = true
    require_symbols   = true
  }

  schema {
    attribute_data_type = "String"
    name                = "cpf_fiap"
    required            = false  # Alterado para não obrigatório
    mutable             = true
    string_attribute_constraints {
      min_length = 11
      max_length = 11
    }
  }

  admin_create_user_config {
    allow_admin_create_user_only = true
  }
}

resource "aws_cognito_user_pool_client" "fiap_tech_challenge_user_pool_client" {
  name             = "meu_fiap_tech_challenge_user_pool_client"
  user_pool_id     = aws_cognito_user_pool.fiap_tech_challenge_user_pool.id
  generate_secret  = false
  explicit_auth_flows = ["ADMIN_NO_SRP_AUTH"]
}

resource "aws_cognito_user" "test_users" {
  count = 5  # Número de usuários de teste a serem criados
  user_pool_id = aws_cognito_user_pool.fiap_tech_challenge_user_pool.id
  username     = format("%011d", count.index + 1)  # Gera CPFs únicos para cada usuário
  attributes = {
    cpf_fiap = format("%011d", count.index + 1)  # Gera CPFs únicos para cada usuário
  }
  password = "Test@1234!"
  depends_on = [aws_cognito_user_pool.fiap_tech_challenge_user_pool]
}
