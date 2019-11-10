ls#!/bin/bash
echo "Digite o nome de uma cidade para saber a temperatura atual: "
read CIDADE
API_KEY=5ca155ba4d74debf88acb3fdc7f5128f

# if [ -z "$CIDADE" ]
# then
#     echo "Por gentileza, digite o nome de uma cidade."
# else
RESPONSE=$(curl -s -G --data-urlencode "appid=$API_KEY" --data-urlencode "q=$CIDADE" --data-urlencode "units=metric" http://api.openweathermap.org/data/2.5/weather) | cat > temperature.json | jq -r 'main.temp' 
echo $RESPONSE

# fi

rm temperature.json