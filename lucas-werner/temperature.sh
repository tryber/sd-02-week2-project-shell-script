#!/bin/bash

echo "Digite o nome de uma cidade para saber a temperatura atual: "
read CIDADE
API_KEY=434d61d332b71d8b17a8bf7246f78d7e

if [ -z "$CIDADE" ]
then
    echo "Por gentileza, digite o nome de uma cidade!"
    exit 1 #acaba o programa
else

RESPONSE=$(curl -s -G --data-urlencode "appid=$API_KEY" --data-urlencode "q=$CIDADE" --data-urlencode "units=metric" http://api.openweathermap.org/data/2.5/weather)
echo $RESPONSE #regex para tratar a response

fi