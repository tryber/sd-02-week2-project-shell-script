#!/bin/bash

# (
# echo "10" ; sleep 1
# echo "# Updating mail logs" ; sleep 1
# echo "20" ; sleep 1
# echo "# Resetting cron jobs" ; sleep 1
# echo "50" ; sleep 1
# echo "This line will just be ignored" ; sleep 1
# echo "75" ; sleep 1
# echo "# Rebooting system" ; sleep 1
# echo "100" ; sleep 1
# ) |
# zenity --progress \
#   --title="Update System Logs" \
#   --text="Scanning mail logs..." \
#   --percentage=0

# if [ "$?" = -1 ] ; then
#         zenity --error \
#           --text="Update canceled."
# fi

#capturando var iável $CIDADE
CIDADE=$(zenity --entry --title="ShowTemp" --width=350 --height=150 --text="Qual sua cidade?")

#retornando: cidade não inserida
if [[ -z "$CIDADE" ]]; then 
    echo "Você não informou sua cidade :("
    exit 1
else 
    #buscando cidade na API
    API_KEY=aeffd8cd63ab104d34dbce1049722f15
    RESPONSE=`curl -s -G --data-urlencode "appid=$API_KEY" --data-urlencode "q=$CIDADE" http://api.openweathermap.org/data/2.5/weather | jq '.main["temp"]'`
    echo $RESPONSE
    
    TEMPERATURA=`echo "scale=2; ($RESPONSE-273.15)" | bc`
fi

#retornando a cidade e a temperatura ao usuário
zenity --info --title="ShowTemp" --width=350 --height=150 --text="Sua temperatura é $TEMPERATURA°C"