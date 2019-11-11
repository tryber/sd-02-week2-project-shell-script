#!/bin/bash
CIDADE="$@"

wget -q --spider http://google.com

if [ $? != 0 ]; then
    echo "você está offline"
    exit 1
fi

if [[ -z "$@" ]];
then
   echo "Ops, você precisa passar o nome de uma cidade como argumento!"
   exit 1
fi

API_KEY=616fd59e4b01e12189c8ece172993dbd
RESPONSE=`curl -s -G --data-urlencode "appid=$API_KEY" --data-urlencode "q=$CIDADE" http://api.openweathermap.org/data/2.5/weather | jq .main.temp`

if [[ $RESPONSE = null ]]; then
    echo "Ops, não encontrei a temperatura para esta cidade!"
else
    CELSIUS=$(bc -l <<< "scale=0; $RESPONSE - 273.15")
    echo "A temperatura em $CIDADE é $CELSIUS°C"
fi