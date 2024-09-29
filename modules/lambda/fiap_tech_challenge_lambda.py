import boto3
import json
import os
import logging

# Configuração do logger
logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    cpf_fiap = event.get('cpf_fiap')
    password = event.get('password')
    
    if not cpf_fiap or not password:
        return {
            'statusCode': 400,
            'body': json.dumps('CPF e senha são obrigatórios.')
        }
    
    if len(cpf_fiap) != 11 or len(password) < 8:
        return {
            'statusCode': 400,
            'body': json.dumps('CPF deve ter 11 caracteres e a senha deve ter no mínimo 8 caracteres.')
        }
    
    client = boto3.client('cognito-idp')
    
    try:
        response = client.admin_initiate_auth(
            UserPoolId=os.environ['USER_POOL_ID'],
            ClientId=os.environ['USER_POOL_CLIENT_ID'],
            AuthFlow='ADMIN_NO_SRP_AUTH',
            AuthParameters={
                'USERNAME': cpf_fiap,
                'PASSWORD': password
            }
        )
        logger.info('Autenticação bem-sucedida para o usuário: %s', cpf_fiap)
        return {
            'statusCode': 200,
            'body': json.dumps('Autenticação bem-sucedida.')
        }
    except client.exceptions.NotAuthorizedException:
        logger.warning('Credenciais inválidas para o usuário: %s', cpf_fiap)
        return {
            'statusCode': 401,
            'body': json.dumps('Credenciais inválidas.')
        }
    except client.exceptions.UserNotFoundException:
        logger.warning('Usuário não encontrado: %s', cpf_fiap)
        return {
            'statusCode': 404,
            'body': json.dumps('Usuário não encontrado.')
        }
    except Exception as e:
        logger.error('Erro no servidor: %s', str(e))
        return {
            'statusCode': 500,
            'body': json.dumps(f'Erro no servidor: {str(e)}')
        }
