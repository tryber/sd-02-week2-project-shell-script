#!/bin/bash

#API KEY 6dc812e2b1193752da65422abf82478b


API_KEY=6dc812e2b1193752da65422abf82478b
CIDADE=$1
RESPONSE=`curl -s -G --data-urlencode "appid=$API_KEY" --data-urlencode "q=$CIDADE" http://api.openweathermap.org/data/2.5/weather`
echo $RESPONSE > texto.txt
#cat texto.txt
                       #"temp":[\d]*
                      #"cod":"[\d]* 


if [ -z "$1" ];then
    echo "Ops, você precisa passar o nome de uma cidade como argumento!"
    exit 1
fi

