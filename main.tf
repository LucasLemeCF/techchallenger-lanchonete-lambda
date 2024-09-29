# Define o provedor AWS e a região
provider "aws" {
  region = "sa-east-1"
}

# Módulo Cognito
module "cognito" {
  source = "./modules/cognito"
  region = "sa-east-1"
}

# Módulo Lambda
module "lambda" {
  source = "./modules/lambda"
  region = "sa-east-1"
  source_dir = "./modules/lambda"
  user_pool_id = module.cognito.user_pool_id
  user_pool_client_id = module.cognito.user_pool_client_id
}