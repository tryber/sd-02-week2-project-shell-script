#!/bin/bash

ping openweathermap.org -c 1 >/dev/null;
if [ "$?" = "0" ] ;
then
   echo "Você está conectado à internet!";
else
   echo "Opa! Você não está conectado à internet! Conecte-se a uma rede para conseguir prosseguir com essa operação."
   exit 1
fi

read -p "Você quer saber a temperatura de que cidade? " CIDADE
API_KEY=5e1079cbcc7c63d589ae54a155cf9c84

RESPONSE=`curl -s -G --data-urlencode "appid=$API_KEY" --data-urlencode "q=$CIDADE" http://api.openweathermap.org/data/2.5/weather`
TEMPERATURA=$(echo $RESPONSE | jq '.main.temp' )

if [ -z "$CIDADE" ]
then
    echo "Você deve digitar o nome de alguma cidade para validar!"
exit 1
elif 
    [ $TEMPERATURA = null ]
then
    echo "EPA! Não encontrei a temperatura dessa cidade!"
exit 1
else
    TEMPERATURA=$(echo "scale=0; $TEMPERATURA - 273.15" | bc)
    echo "A temperatura em $CIDADE é de $TEMPERATURA graus Celsius."
fi