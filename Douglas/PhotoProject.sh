#!/bin/bash
#Verificando se possui as aplcações instaladas
pacote=$(dpkg --get-selections | grep yad ) 
if [ -z "$pacote" ] ;
then 
     echo "Vamos precisar instar alguns pacotes para começar"
     sudo apt-get install yad
fi
pacote=$(dpkg --get-selections | grep xcowsay ) 
if [ -z "$pacote" ] ;
then 
     echo "Vamos precisar instar alguns pacotes para começar"
     sudo apt-get install xcowsay
     sudo apt-get gtk
fi
#Inicio do codigo para buscar imagem
API_KEY=14207965-9493642060cb1c95148269738
xcowsay "Meu nome é Clotilde serei sua assistente, qual imagem você procura?" > /dev/null 2> /dev/null
#Recebendo o assunto a ser pesquisado
Busca=$(yad --entry --text="Qual imagem você procura?" --height="100" --width="200" --title="Responda a Clotilde" --buttons-layout=center --button="gtk-ok:0" )
#Verificando e finalizando o programa se a opção de fechar a caixinha foi utilizada
if [ $? -eq 252 ]
then 
    xcowsay "Até mais" > /dev/null 2> /dev/null
    exit 1
#Verificando se foi passado o algum assunto
elif [ $Busca -z ] > /dev/null 2> /dev/null
then
    xcowsay "Sem imagem, sem download, até mais"  > /dev/null 2> /dev/null
    exit 1
fi
xcowsay "Quantas imagens de \"$Busca\" você quer?"  > /dev/null 2> /dev/null
#Recebendo o numero de imagens
Q_Fotos=$(yad --entry --text="Quantas imagens você deseja?" --height="100" --width="200" --title="Responda a Clotilde" --buttons-layout=center --button="gtk-ok:0" )
#Verificando e finalizando o programa se a opção de fechar a caixinha foi utilizada
if [ $? -eq 252 ]
then 
    xcow say "Até mais" > /dev/null 2> /dev/null
    exit 1
fi
#Valor padrão se a entrada for vazia
if [ $Q_Fotos -z ] > /dev/null 2> /dev/null
then
    Q_Fotos=3
fi
#verificação se esta dentro dos padrões de 3 a 200
if (( $Q_Fotos < 3 ))
then
    xcowsay "Desculpa, so consigo pegar o minimo de 3 imagens :C" > /dev/null 2> /dev/null
    exit 1
elif (( $Q_Fotos > 200 ))
then
    xcowsay "Desculpa, so consigo pegar 200 imagens por pesquisa :C" > /dev/null 2> /dev/null
    exit 1
fi
#Fazendo a busca pela api e registrando os dados em texto
RESPONSE=`curl -s -G -L --data-urlencode "key=$API_KEY" --data-urlencode "q=$Busca" --data-urlencode "image_type=photo" --data-urlencode "per_page=$Q_Fotos" https://pixabay.com/api/`;
echo $RESPONSE > Linksapi.txt
#Recortando o numero de resultados
encontrado=`cut -d ":" -f2 Linksapi.txt | cut -d ',' -f1`
#Informando se não houver resultado
if [ $encontrado -eq 0 ]
then
    xcowsay "Que pena, nenhuma imagem de \"$Busca\" foi encontrada, Até mais" > /dev/null 2> /dev/null
    exit 0
fi
#Criando a pasta caso não exista e baixando as fotos
mkdir $Busca  > /dev/null 2> /dev/null
mv Linksapi.txt ./$Busca  
cd $Busca
termo=`egrep -o 'webformatURL":"https://pixabay.com/get/(\d+|\w+)+.\w{3}' Linksapi.txt | cut -d '"' -f3`
wget --quiet $termo 
#exclusão do arquivo que contem os links da api
rm Linksapi.txt
xcowsay "Deseja ter suas imagens em formato tar.gz?" > /dev/null 2> /dev/null      
#Verificando se o usario prefere ter um arquivo tar.gz
(yad --text="Deseja ter suas imagens em formato tar.gz?" --height="100" --width="200" --title="Responda a Clotilde" --buttons-layout=center --button="gtk-ok:0" --button="gtk-close:1" )
#criação do arquivo tar.gz com as fotos
if [ $? -eq 0 ]
then 
    tar -czf $Busca.tar.gz *.jpg
    mv $Busca.tar.gz ..
    cd ..
    rm -r $Busca
    xcowsay "Seu arquivo \"$Busca.tar.gz\" está pronto! Até a proxíma." > /dev/null 2> /dev/null
    exit 0
#Opção caso o usuario não deseje tar.gz
else   
    xcowsay "Suas imagens ja estão na pasta "$Busca", Até a proxíma." > /dev/null 2> /dev/null
fi
