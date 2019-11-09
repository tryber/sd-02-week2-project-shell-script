#!/bin/bash

CIDADE=$* #passamos argumento * para não ser necessário digitar entre aspas, caso a cidade tenha mais de um nome
API_KEY=434d61d332b71d8b17a8bf7246f78d7e
TMP_FILE=tmp_file.txt

ping -w 1 8.8.8.8 >/dev/null 2>&1 #sumindo com a resposta do PING - Johnatas

if [ $? != 0 ]; then #como teste, é válido esse tipo de PING, porém caso acontecesse uma falha nos servers de DNS do Google, o script retornaria sem Internet erroneamente.
    echo "Ops, parece que você está sem internet! Ou o site que o script envia pacotes ICMP está fora do ar."
else 

    if [ -z "$CIDADE" ]; then
        echo "Ops, você precisa passar o nome de uma cidade como argumento!"
    else

        RESPONSE=$(curl -s -G --data-urlencode "appid=$API_KEY" --data-urlencode "q=$CIDADE" --data-urlencode "units=metric" http://api.openweathermap.org/data/2.5/weather)
        echo $RESPONSE
        echo $RESPONSE > $TMP_FILE
        NOT_FOUND_ERROR=$(grep -o -E "\"cod\":\"404\"" $TMP_FILE)

        if [ $NOT_FOUND_ERROR == '"cod":"404"' ] 2> /dev/null; then  #resolvendo mensagem de falha de operador unário - Johnatas
            echo "Ops, não encontrei a temperatura para esta cidade! A grafia está correta?"
        else
            CIDADE_TEMP=$(grep -o -E '"temp":[^,]+' $TMP_FILE | grep -o -E "[^:]+$")
            TEMPERATURA_TR=$(echo $CIDADE_TEMP | tr . ,) #tr no ., porque no Brasil utilizamos ',' como separador de decimais - Johnatas
            echo "Em $CIDADE, a temperatura é de $TEMPERATURA_TRºC."
        fi
        rm tmp_file.txt #para apagar o arquivo temporário após utilizar o script - Johnatas
    fi
fi