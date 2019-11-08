#!/bin/bash

API_KEY=14207965-9493642060cb1c95148269738
echo "Imagem de que você procura?"
read SEARCH_TERM
echo "Quantas imagens de $SEARCH_TERM você quer?"
read QTY_RESULTS
resultpadrao=3
if [ -z $SEARCH_TERM  ]
then
    echo "Você deve passar um argumento valido!"
    exit 1
elif [ -z $QTY_RESULTS ]
then
    QTY_RESULTS = $resultpadrao
fi
if (($QTY_RESULTS < 3 || $QTY_RESULTS > 200))
then
    echo "Você não passou um valor valido (de 3 a 200)"
    exit 1
fi

RESPONSE=`curl -s -G -L --data-urlencode "key=$API_KEY" --data-urlencode "q=$SEARCH_TERM" --data-urlencode "image_type=photo" --data-urlencode "per_page=$QTY_RESULTS" https://pixabay.com/api/`;
echo $RESPONSE > teste.txt

encontrado=`cut -d ":" -f2 teste.txt | cut -d ',' -f1`

if [ $encontrado -eq 0 ]
then
    echo "Que pena, nenhuma imagem de $SEARCH_TERM foi encontrada"
    exit 0
fi
if [ $SEARCH_TERM -e ]
then
    mv teste.txt ./$SEARCH_TERM
    cd $SEARCH_TERM
    termo=`egrep -o 'webformatURL":"https://pixabay.com/get/(\d+|\w+)+.\w{3}' teste.txt | cut -d '"' -f3`
    wget --quiet $termo 
    rm teste.txt
    echo "Suas imagens ja estão na pasta $SEARCH_TERM"
else
    mkdir $SEARCH_TERM
    mv teste.txt ./$SEARCH_TERM
    cd $SEARCH_TERM
    termo=`egrep -o 'webformatURL":"https://pixabay.com/get/(\d+|\w+)+.\w{3}' teste.txt | cut -d '"' -f3`
    wget --quiet $termo 
    rm teste.txt
    echo "Suas imagens ja estão na pasta $SEARCH_TERM"
fi