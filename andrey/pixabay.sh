#!/bin/bash
while [[ $SEARCH_TERM = "" ]]
do
    read -p "Bem vindo à busca de imagens do Pixabay pelo terminal! O que você gostaria de ver? " SEARCH_TERM
    if [[ $SEARCH_TERM = "" ]]; then
        echo "Desculpe, você não digitou um termo válido para ser pesquisado. O programa será encerrado."
        exit 
    fi   
done
while [[ $QTY_RESULTS = "" || $(($QTY_RESULTS)) -le 2 || $(($QTY_RESULTS)) -gt 201 ]]
do
    read -p "Qual a quantidade que você deseja de imagens de $SEARCH_TERM? Escolha uma quantidade entre 3 e 200 fotos! " QTY_RESULTS
    if [[ $QTY_RESULTS  = "" || $(($QTY_RESULTS)) -lt 2 || $(($QTY_RESULTS)) -gt 201 ]]; then
        echo "Buscando a quantidade mínima de imagens que é 3."
        QTY_RESULTS=$((3))
        break
    fi
done
echo "Verificando se o diretório './foto' existe."
if [ ! -d foto ];
then
    echo "Criando o diretório 'foto'."
    mkdir foto
fi
echo "Entrando no diretório 'foto'."
cd foto
API_KEY=14214201-9d62060be38de7be7ac88482d
RESPONSE=`curl -s -G -L --data-urlencode "key=$API_KEY" --data-urlencode "q=$SEARCH_TERM" --data-urlencode "image_type=photo" --data-urlencode "per_page=$QTY_RESULTS" https://pixabay.com/api`
RESPONSE_INDEX=0
ERRO=`echo $RESPONSE | egrep -o "\"totalHits\":[0:9]*" | cut -s -d ":" -f2`
echo $ERRO
if [[ "$ERRO" == "0" ]]; then
    echo "Ops! Não encontrei nada por aqui... tente outro termo!"
    exit 1
fi
while [ $RESPONSE_INDEX -lt $QTY_RESULTS ]
do
    IMAGE_URL=$(echo $RESPONSE | jq .hits[$RESPONSE_INDEX].largeImageURL | sed 's/"//g')
    curl $IMAGE_URL > $RESPONSE_INDEX.jpg
	RESPONSE_INDEX=$[ $RESPONSE_INDEX + $SEARCH_TERM + 1 ]
done
while [[ $SHOULD_COMPACT != "S" && $SHOULD_COMPACT != "N" ]]
do
    read -p "Deseja compactar seu pedido em um arquivo? (S/N)" SHOULD_COMPACT
    if [[ $SHOULD_COMPACT != "S" && $SHOULD_COMPACT != "N" ]]; then
    echo "Escolha uma opção entre S ou N."
    fi   
done
if [ $SHOULD_COMPACT = "S" ]
then
echo "Iniciando compactação."
cd ..
tar -czvf foto.tar.gz foto
fi
echo "Fim da execução."