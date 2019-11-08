#!/bin/bash

API_KEY=623af31f846719c17b41e27a8865eb1c

echo "Digite o nome da cidade:"
read CIDADE

RESPONSE=`curl -s -G --data-urlencode "appid=$API_KEY" --data-urlencode "q=$CIDADE" http://api.openweathermap.org/data/2.5/weather`
echo $RESPONSE | cat >> resultado.txt