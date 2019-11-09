#!/bin/bash
#inserir interface
API_KEY=14207965-9493642060cb1c95148269738
xcowsay "Serei sua assistente, qual imagem você procura?" > /dev/null 2> /dev/null
Busca=$(yad --entry --height="100" --width="200" --title="Responda a vaquinha" --buttons-layout=center --button="gtk-ok:0" )
if [ $? -eq 252 ]
then 
    xcowsay "Até mais" > /dev/null 2> /dev/null
    exit 1
elif [ $Busca -z ] > /dev/null 2> /dev/null
then
    xcowsay "Sem imagem, sem download, até mais"  > /dev/null 2> /dev/null
    exit 1
fi
xcowsay "Quantas imagens de $Busca você quer?"  > /dev/null 2> /dev/null
Q_Fotos=$(yad --entry --height="100" --width="200" --title="Responda a vaquinha" --buttons-layout=center --button="gtk-ok:0" )
if [ $? -eq 252 ]
then 
    xcow say "Até mais" > /dev/null 2> /dev/null
    exit 1
fi
if [ $Q_Fotos -z ] > /dev/null 2> /dev/null
then
    Q_Fotos=3
fi
if (( $Q_Fotos < 3 ))
then
    xcowsay "Desculpa, so consigo pegar o minimo de 3 imagens :C" > /dev/null 2> /dev/null
    exit 1
elif (( $Q_Fotos > 200 ))
then
    xcowsay "Desculpa, so consigo pegar 200 imagens por pesquisa :C" > /dev/null 2> /dev/null
    exit 1
fi

RESPONSE=`curl -s -G -L --data-urlencode "key=$API_KEY" --data-urlencode "q=$Busca" --data-urlencode "image_type=photo" --data-urlencode "per_page=$Q_Fotos" https://pixabay.com/api/`;
echo $RESPONSE > teste.txt

encontrado=`cut -d ":" -f2 teste.txt | cut -d ',' -f1`

if [ $encontrado -eq 0 ]
then
    xcowsay "Que pena, nenhuma imagem de $Busca foi encontrada, Até mais" > /dev/null 2> /dev/null
    exit 0
fi
    mkdir $Busca  > /dev/null 2> /dev/null
    mv teste.txt ./$Busca  
    cd $Busca
    termo=`egrep -o 'webformatURL":"https://pixabay.com/get/(\d+|\w+)+.\w{3}' teste.txt | cut -d '"' -f3`
    wget --quiet $termo 
    rm teste.txt
    xcowsay "Suas imagens ja estão na pasta $Busca, Até a proxíma" > /dev/null 2> /dev/null