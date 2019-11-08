#!/bin/bash

API_KEY=434d61d332b71d8b17a8bf7246f78d7e
#RESPONSE=$(curl -s "http://api.openweathermap.org/data/2.5/weather?q=$1&units=metric&appid=$API_KEY")
RESPONSE=$(curl -s -G --data-urlencode "appid=$API_KEY" --data-urlencode "q=$*" --data-urlencode "units=metric" http://api.openweathermap.org/data/2.5/weather)
echo $RESPONSE