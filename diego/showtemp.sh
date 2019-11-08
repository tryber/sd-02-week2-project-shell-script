#!/bin/bash

#capturando variável $CIDADE
CIDADE=$(zenity --entry --title="Showtemp " --width=350 --height=150 --text="Qual sua cidade?") 

#retornando: cidade não inserida
if [[ -z "$CIDADE" ]]; then 
    echo "Você não informou sua cidade :("
    exit 1
else 
    #buscando cidade na API
    API_KEY=aeffd8cd63ab104d34dbce1049722f15
    RESPONSE=`curl -s -G --data-urlencode "appid=$API_KEY" --data-urlencode "q=$CIDADE" http://api.openweathermap.org/data/2.5/weather`
    echo $RESPONSE
fi

#retornando a cidade e a temperatura ao usuário
#echo "A tempetura atual em $CIDADE é de $TEMPERATURA° Celsius!"
