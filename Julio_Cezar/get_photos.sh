#!/bin/bash

read -p "Digite um termo a ser pesquisado: " SEARCH_TERM
read -p "Digite a quantidade a ser pesquisada(Valor deve ser entre 3 e 200): " QTY_RESULTS
VALOR_CONTROLE_CUT=4;
API_KEY=14233525-d8aa2bc479ab02a8f3938833d
RESPONSE=`curl -s -G -L --data-urlencode "key=$API_KEY" --data-urlencode "q=$SEARCH_TERM" --data-urlencode "image_type=photo" --data-urlencode "per_page=$QTY_RESULTS" https://pixabay.com/api`
WEB_URL_IMAGES=`echo $RESPONSE | egrep -o "\"webformatURL\":\"https://[a-zA-Z]*.com/get/[a-zA-Z0-9]*_[0-9]*.jpg"`
ERRO_MSG=`echo $RESPONSE | egrep -o "\"totalHits\":[0-9]*" | cut -s -d":" -f2`

if [ -z "$QTY_RESULTS" ];then 
    echo "Voce não digito nada, entao retornaremos o valor padrao = 3."
    QTY_RESULTS=3;                
fi  

if [ -z "$SEARCH_TERM" ]; then
    echo "Voce precisa passar um termo de busca como argumento. "
    exit 1
elif [ $QTY_RESULTS -lt "3" ] || [ $QTY_RESULTS -gt "200" ]; then
    echo "Quantidade inválida, tente novamente com valores entre 3 e 200. "
    exit 1
elif [[ "$ERRO_MSG" == "0" ]]; then
    echo "Não encontrei nenhuma imagem para esse termo de busca."
    exit 1
else
    mkdir $SEARCH_TERM
    PATH_DIRECTORY=`echo $PWD`
    PATH_DIRECTORY=`echo $PATH_DIRECTORY/$SEARCH_TERM`
    touch $PATH_DIRECTORY/WebUrlTemp.txt
    for COUNTER in $(seq $QTY_RESULTS); do
        echo $WEB_URL_IMAGES | cut -s -d"\"" -f$VALOR_CONTROLE_CUT >> $PATH_DIRECTORY/WebUrlTemp.txt
        VALOR_CONTROLE_CUT=$[$VALOR_CONTROLE_CUT+3]
    done
    cd $SEARCH_TERM
    
    wget -i WebUrlTemp.txt
    rm $PATH_DIRECTORY/WebUrlTemp.txt
    
    read -p "Deseja compactar o arquivo: (S/N)" COMPACTAR
    if [ "$COMPACTAR" == "S" ]; then
        cd ..
        tar -zcf $SEARCH_TERM.tar.gz $SEARCH_TERM
    fi
fi


