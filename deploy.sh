#!/bin/bash

echo "Script iniciado."

# Define as variáveis
LAMBDA_NAME="lambda-sucesso"
# LAMBDA_ROLE = secret do github
ZIP_FILE="lambda_function.zip"
SRC_FILE="src/lambda_function.py"

# Verifica se o AWS CLI está configurado
if ! aws sts get-caller-identity &> /dev/null; then
    echo "O AWS CLI não foi configurado corretamente."
    exit 1
fi

# Empacota o código fonte em um arquivo zip
echo "Empacotando código fonte..."
zip -j $ZIP_FILE $SRC_FILE

# Atualiza a lambda (faz deploy também)
echo "Enviando o código para a AWS..."
aws lambda update-function-code \
    --function-name $LAMBDA_NAME \
    --zip-file fileb://$ZIP_FILE \
    >/dev/null 2>&1

echo "Deploy realizado com sucesso!"

# Apaga o arquivo zip
rm $ZIP_FILE

echo "Script finalizado."