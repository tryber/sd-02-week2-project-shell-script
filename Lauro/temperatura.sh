#!/bin/bash
CIDADE="$@"
if [[ -z "$@" ]];
then
   echo "Digite o nome de uma cidade"
   exit 1
fi
API_KEY=616fd59e4b01e12189c8ece172993dbd
RESPONSE=`curl -s -G --data-urlencode "appid=$API_KEY" --data-urlencode "q=$CIDADE" http://api.openweathermap.org/data/2.5/weather`
echo $RESPONSE > response.txt
MAIN=`awk -F "," '{print $8;}' response.txt`
echo $MAIN > main.txt
TEMP=`awk -F ":" '{print $3;}' main.txt`
novaTEMP=$(bc -l <<<"scale=0; $TEMP*1000/10")
if [[ $novaTEMP -lt 10000 ]]
then
    echo "Ops, não encontrei a temperatura para esta cidade!"
else
    CELSIUS=$(bc -l <<<"scale=0; $TEMP - 273.15")
    echo "A temperatura em $CIDADE é $CELSIUS°C"
fi
rm response.txt main.txt