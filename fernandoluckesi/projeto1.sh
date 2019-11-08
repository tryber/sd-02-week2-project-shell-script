#!/bin/bash

#API KEY 6dc812e2b1193752da65422abf82478b


API_KEY=6dc812e2b1193752da65422abf82478b
CIDADE=$1
RESPONSE=`curl -s -G --data-urlencode "appid=$API_KEY" --data-urlencode "q=$CIDADE" http://api.openweathermap.org/data/2.5/weather`
TEMPERATURA=$(echo $RESPONSE | jq '.main.temp')
ERRO_MSG=$(echo $RESPONSE | jq '.cod')



if [ -z "$1" ];then
    echo "Ops, você precisa passar o nome de uma cidade como argumento!"
    exit 1
elif [[ "$ERRO_MSG" == "\"404\"" ]];then
    echo "Ops, não encontrei a temperatura para esta cidade!" 
else
    TEMPERATURA=$(echo "scale=0; $TEMPERATURA - 273.15" | bc)
    echo "A temperatuda da cidade de $CIDADE é $TEMPERATURA graus Celsius." 
fi

#T(°C) = T(K) - 273.15 formulda de transformar graus Celsius em graus Kelvin