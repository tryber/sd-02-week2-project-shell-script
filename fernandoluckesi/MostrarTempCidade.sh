#!/bin/bash

read -p "Digite o nome de uma CIDADE: " CIDADE
API_KEY=9d8d84b43eb03ada9dc401099de941be
RESPONSE=$(curl -s -G --data-urlencode "appid=$API_KEY" --data-urlencode "q=$CIDADE" http://api.openweathermap.org/data/2.5/weather)
TEMPERATURA=`echo $RESPONSE | egrep -o "\"temp\":[0-9]*\.[0-9]*" | cut -s -d":" -f2`
ERRO_MSG=`echo $RESPONSE | egrep -o "\"cod\":\"[0-9]*\"" | cut -s -d":" -f2`
#TEMPERATURA_MAX=
#TEMPERATURA_MIN=
#TEMPERATURA=$(echo $RESPONSE | jq '.main.temp')
#ERRO_MSG=$(echo $RESPONSE | jq '.cod')


if [ -z "$CIDADE" ]; then
    echo "Não foi informada uma cidade."
    exit 1 
elif [[ "$ERRO_MSG" == "\"404\"" ]];then
    echo "Não foi encontrado a temperatura para a cidade $CIDADE.Confira se é um nome válido para cidade."
    exit 1
else  
   
    TEMPERATURA=$(echo "scale=0; $TEMPERATURA - 273.15" | bc)  
    echo "A temperatura de $CIDADE é $TEMPERATURA graus Celsius."
fi  
#T(°C) = T(K) - 273.15 formulda de transformar graus Celsius em graus Kelvin