#!/bin/bash
clear
echo "Onde você deseja verificar o tempo hoje?"
echo "Digite o nome da cidade:"
    read -r CIDADE

if [ -z "$CIDADE" ]
    then
        echo "Você precisa inserir o nome de uma cidade para continuar"
        exit 1
fi
if [ ! -e "$CIDADE" ]
    then
        API_KEY=623af31f846719c17b41e27a8865eb1c
        RESPONSE=`curl -s -G --data-urlencode "appid=$API_KEY" --data-urlencode "q=$CIDADE" http://api.openweathermap.org/data/2.5/weather`
          echo  "$RESPONSE" | cat > resultado.txt
                resulTemp=$(cat resultado.txt | grep -o -E '"main":{"temp":[^,]+' | grep -o -E "[^:]+$")
                conversaoCelsius=`echo "scale=2; ($resulTemp-273.15)" | bc`
    if [ $conversaoCelsius = -273.15 ]
    then
    echo "A cidade que você inseriu não existe, insira o nome corretamente"
    exit
    fi
                echo "A temperatura em "$CIDADE" neste exato momento é de "$conversaoCelsius"º Celius"
fi

rm -rf resultado.txt

        