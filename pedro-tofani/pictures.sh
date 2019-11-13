#!/bin/bash

#capturando variável $TERMO
TERMO=$(zenity --entry --title="Pictures" --width=350 --height=150 --text="O que deseja baixar?")
if [[ -z "$TERMO" ]]; then 
    echo "Você não informou o que deseja baixar :("
    exit 1
fi

#capturando variável quantidade
QUANTIDADE=$(zenity --entry --title="Pictures" --width=350 --height=150 --text="Qual a quantidade de imagens?")
if [[ -z "$QUANTIDADE" ]]; then
    zenity --warning  --title="Pictures" --width=350 --height=150 --text="Você não informou a quantidade. Assumiremos 3 imagens."
    QUANTIDADE=3 
fi
if [[ ($QUANTIDADE -lt 3) || ($QUANTIDADE -gt 200) ]]; then
    echo "A quantidade de resultados deve estar entre 3 e 200 :("
    exit 2
fi

#capturando se a pessoa quer compactar os arquivos
ZIPAR=$(zenity --question --width 300 --text "Quer compactar o resultado?"; echo $?)
API_KEY=14222272-ffb471ea36ea7197b478c53d4
RESPONSE=`curl -s -G -L --data-urlencode "key=$API_KEY" --data-urlencode "q=$TERMO" --data-urlencode "image_type=photo" --data-urlencode "per_page=$QUANTIDADE" https://pixabay.com/api`
echo $RESPONSE > saida.txt

if [[ $RESPONSE = '{"totalHits":0,"hits":[],"total":0}' ]]; then
    zenity --warning  --title="Pictures" --width=350 --height=150 --text="Nenhum resultado encontrado."
    rm saida.txt
    exit 3
fi

grep -o -E 'webformatURL":"https://pixabay.com/get/\w+....' saida.txt | awk -F '":"' '{print $2}' | cat > downloads.txt

mkdir "$TERMO"
mv downloads.txt "./$TERMO"
cd "$TERMO"
cat downloads.txt | xargs wget
cd ..

if [ $ZIPAR == 0 ]; then
    cd "$TERMO"
    zip "$TERMO.zip" *
    mv "$TERMO.zip" ..
    rm *
    cd ..
    rmdir "$TERMO"
fi

rm saida.txt
