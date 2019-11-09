#!/bin/bash

#capturando variável $TERMO
TERMO=$(zenity --entry --title="Pictures" --width=350 --height=150 --text="O que deseja baixar?")
if [[ -z "$TERMO" ]]; then 
    echo "Você não informou o que deseja baixar :("
    exit 1
fi

#capturando variável quantidade
QUANTIDADE=$(zenity --entry --title="Pictures" --width=350 --height=150 --text="Qual a quantidade de imagens?")
if [[ ($QUANTIDADE -lt 3) || ($QUANTIDADE -gt 200) ]]; then
    echo "A quantidade de resultados deve estar entre 3 e 200 :("
    exit 2
fi

#capturando se a pessoa quer compactar os arquivos
# ZIPAR=$(zenity --yesno --title="Pictures" --width=350 --height=150 --text="Deseja compactar os arquivos")

API_KEY=14222272-ffb471ea36ea7197b478c53d4
RESPONSE=`curl -s -G -L --data-urlencode "key=$API_KEY" --data-urlencode "q=$TERMO" --data-urlencode "image_type=photo" --data-urlencode "per_page=$QUANTIDADE" https://pixabay.com/api`
echo $RESPONSE
echo ""
cat > saida.txt echo $RESPONSE

# grep -o '"largeImageURL":"https://pixabay.com/get/' saida.txt