#!/bin/bash
CIDADE=$*
API_KEY=5ca155ba4d74debf88acb3fdc7f5128f
TMP_FILE=tmp_temperatura.txt
ping -w 1 8.8.8.8 >/dev/null 2>&1
LAST_SH=$?
if [ "$LAST_SH" -gt 0 ]; then
    xcowsay --at=100,250 $'Ops, parece que você está sem internet!\nOu o site que o script envia o PING para teste está fora do ar.'
    exit 1
elif [ -z "$CIDADE" ]; then
    xcowsay --at=100,250 $'Ops, você precisa passar o nome de uma cidade como argumento!\nVou fechar aqui, então chame o script novamente e digite a cidade ok?'
    exit 1
else
    RESPONSE=$(curl -s -G --data-urlencode "appid=$API_KEY" --data-urlencode "q=$CIDADE" --data-urlencode "units=metric" http://api.openweathermap.org/data/2.5/weather)
    echo "$RESPONSE" > "$TMP_FILE"
    NOT_FOUND_ERROR=$(grep -o -E '"cod":"404"' "$TMP_FILE")
    if [ "$NOT_FOUND_ERROR" == '"cod":"404"' ] 2> /dev/null; then
        xcowsay --at=100,250 $'Ops, não encontrei a temperatura para esta cidade! A grafia está correta?'
    else
        CIDADE_TEMP=$(grep -o -E '"temp":[^,]+' "$TMP_FILE" | grep -o -E '[^:]+$')
        TEMPERATURA_TR=$(echo "$CIDADE_TEMP" | tr . ,)
        PAIS=$(grep -o -E '"country\":[^,]+' "$TMP_FILE" | grep -o -E '[A-Z]{2}')
        xcowsay --at=100,250 $'Em '"$CIDADE"', '"$PAIS"', a temperatura é de '"$TEMPERATURA_TR"'ºC.'
    fi
    rm "$TMP_FILE"
fi
