#!/bin/bash
API_KEY=14226934-e6bc1f36fa5e1560bf098247e
SEARCH_TERM="$1"
QTY_RESULTS="$2"
    if [ -z "$QTY_RESULTS" ]; then
        QTY_RESULTS=3
        echo $QTY_RESULTS
        xcowsay --at=200,250 $'Como não foi passado nenhum valor, baixaremos 3 fotos.'
    fi
RESPONSE=$(curl -s -G -L --data-urlencode "key=$API_KEY" --data-urlencode "q=$SEARCH_TERM" --data-urlencode "image_type=photo" --data-urlencode "per_page=$QTY_RESULTS" https://pixabay.com/api)
echo $RESPONSE
