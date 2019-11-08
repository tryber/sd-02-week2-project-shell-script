 #!/usr/bin/env bash

if [ -z "$1" ]; then
    echo -e "\nOps, você precisa passar o nome de uma cidade como argumento!\n"
    exit 1
fi

API_KEY=5e8a6e52b5222bb9dfad4fd02077c129
API_URL=http://api.openweathermap.org/data/2.5/weather
CITY=$1

ping -q -W1 -c1 google.com &> /dev/null

if [ $? -eq 0 ]; then
  RESPONSE=`curl -s -G --data-urlencode "appid=$API_KEY" --data-urlencode "q=$CITY" $API_URL`

  NOT_FOUND_REGEXP="\"cod\":\"404\""

  if [[ $RESPONSE =~ $NOT_FOUND_REGEXP ]]; then
    echo -e "\nOps, não encontrei a temperatura para esta cidade!\n"
    exit 1
  else
    TEMPERATURE=`echo $RESPONSE | egrep -o '"temp":\d+.\d+' | cut -d ":" -f2`

    TEMP_CELSIUS=`echo "scale=2;$TEMPERATURE - 273.15" | bc -l` # subtract 273.15 from Kelvin value to get it in Celsius

    echo -e "\nEm $CITY, a temperatura é de $TEMP_CELSIUS º Celsius."
  fi
else
  echo "Ops, parece que você está sem internet!"
  exit 2
fi
