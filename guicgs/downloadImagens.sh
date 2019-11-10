#!/bin/bash 

API_Key=14225963-65f011eac0dcadc2019128ae2

echo -e "Digite um termo de busca para download de imagens:\n(somente em português)"
read termoBusca

if [[ -z "$termoBusca" ]]; then
    echo "Ops, você precisa digitar um termo de busca!"
    exit 1
fi

echo "Quantas imagens você deseja baixar?"
read qtdeResultados

if [[ -z "$qtdeResultados" ]]; then
    qtdePadrao=3
    echo "Por padrão, serão baixadas $qtdePadrao imagens!"
    RESPONSE=`curl -s -G -L --data-urlencode "key=$API_Key" --data-urlencode "q=$termoBusca" --data-urlencode "image_type=photo" --data-urlencode "lang=pt" --data-urlencode "per_page=$qtdePadrao" https://pixabay.com/api`
    echo $RESPONSE | egrep -o '"webformatURL":[^,]+' | egrep -o '(http[s]?|[s]?ftp[s]?)(:\/\/)([^\s,]+)([^"]+)' > lista.txt
    mkdir $termoBusca 
    mv lista.txt ./$termoBusca/
    cd $termoBusca
    wget -i lista.txt
    # echo "Suas fotos foram salvas na pasta "$termoBusca""
    exit 1
fi

RESPONSE=`curl -s -G -L --data-urlencode "key=$API_Key" --data-urlencode "q=$termoBusca" --data-urlencode "image_type=photo" --data-urlencode "per_page=$qtdeResultados" https://pixabay.com/api`
echo $RESPONSE