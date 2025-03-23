#!/bin/bash

LAMBDA_NAME="lambda-sucesso"
# LAMBDA_ROLE = secret do github
ZIP_FILE="lambda_function.zip"
SRC_FILE="src/lambda_function.py"

echo "Script iniciado."

# Verifica se o AWS CLI está configurado
if ! aws sts get-caller-identity &> /dev/null; then
    echo "O AWS CLI não foi configurado corretamente."
    exit 1
fi

# Empacota o código fonte em um arquivo zip
echo "Empacotando código fonte..."
zip -j $ZIP_FILE $SRC_FILE

# Verifica se a Lambda já existe
EXISTS=$(aws lambda get-function --function-name $LAMBDA_NAME 2>/dev/null)

if [ -z "$EXISTS" ]; then
    # Cria a lambda caso não exista
    echo "Criando nova função Lambda..."
    aws lambda create-function \
        --function-name $LAMBDA_NAME \
        --runtime python3.9 \
        --role $LAMBDA_ROLE \
        --handler lambda.lambda_handler \
        --zip-file fileb://$ZIP_FILE \
        >/dev/null 2>&1

    echo "Função Lambda criada com sucesso!"
else
    # Atualiza a lambda existente
    echo "Atualizando código da função Lambda..."
    aws lambda update-function-code \
        --function-name $LAMBDA_NAME \
        --zip-file fileb://$ZIP_FILE \
        >/dev/null 2>&1

    echo "Lambda atualizada com sucesso!"
fi

# Apaga o arquivo zip
rm $ZIP_FILE
echo "Script finalizado."