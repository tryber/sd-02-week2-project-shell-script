#!/bin/bash

API_KEY=434d61d332b71d8b17a8bf7246f78d7e

RESPONSE=$(curl -s -G --data-urlencode "appid=$API_KEY" --data-urlencode "q=$*" --data-urlencode "units=metric" http://api.openweathermap.org/data/2.5/weather)

echo $RESPONSE