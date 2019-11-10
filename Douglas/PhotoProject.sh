#!/bin/bash
#Verificando se possui as aplcações instaladas
pacote=$(dpkg --get-selections | grep yad ) 
if [ -z "$pacote" ] ;
then 
     echo "Vamos precisar instar o YAD para começar"
     sudo apt-get install yad
fi
pacote=$(dpkg --get-selections | grep xcowsay ) 
if [ -z "$pacote" ] ;
then 
     echo "Vamos precisar instar o XCOWSAY começar"
     sudo apt-get install xcowsay
fi

xcowsay --at=400,300 "Meu nome é Clotilde serei sua assistente,
vocẽ pode fechar qualquer caixa de 
dialogo para sair do programa" 2> /dev/null
function Baixar(){
    #Inicio do codigo para buscar imagem
    API_KEY=14207965-9493642060cb1c95148269738
    #Recebendo o assunto a ser pesquisado
    xcowsay --at=400,300 "Qual imagem você procura?" 2> /dev/null
    Busca=$(yad --entry --text="Qual imagem você deseja?" --height="100" --width="200" --title="Responda a Clotilde"  --buttons-layout=center --button="gtk-ok:0" )
    #Verificando e finalizando o programa se a opção de fechar a caixinha foi utilizada
    if [ $? -eq 252 ]
    then 
        xcowsay --at=400,300 "Até mais" 2> /dev/null
        exit 1
    #Verificando se foi passado o algum assunto
    elif [ $Busca -z ] 2> /dev/null
    then
        xcowsay --at=400,300 "Sem imagem, sem download, até mais"  2> /dev/null
        exit 1
    fi
    xcowsay --at=400,300 "Quantas imagens de \"$Busca\" você quer?"  2> /dev/null
    #Recebendo o numero de imagens
    Q_Fotos=$(yad --entry --text="Quantas imagens você deseja?" --height="100" --width="200" --title="Responda a Clotilde" --buttons-layout=center --button="gtk-ok:0" )
    #Verificando e finalizando o programa se a opção de fechar a caixinha foi utilizada
    if [ $? -eq 252 ]
    then 
        xcow say --at=400,300 "Até mais" 2> /dev/null
        exit 1
    fi
    #Valor padrão se a entrada for vazia
    if [ $Q_Fotos -z ] 2> /dev/null
    then
        Q_Fotos=3
    fi
    #verificação se esta dentro dos padrões de 3 a 200
    if (( $Q_Fotos < 3 ))
    then
        xcowsay --at=400,300 "Desculpa, so consigo pegar o minimo de 3 imagens :C" 2> /dev/null
        exit 1
    elif (( $Q_Fotos > 200 ))
    then
        xcowsay --at=400,300 "Desculpa, so consigo pegar 200 imagens por pesquisa :C" 2> /dev/null
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
        xcowsay --at=400,300 "Que pena, nenhuma imagem de \"$Busca\" foi encontrada, Até mais" 2> /dev/null
        exit 0
    fi
    #Criando a pasta caso não exista e baixando as fotos
    mkdir $Busca  2> /dev/null
    mv Linksapi.txt ./$Busca  
    cd $Busca
    termo=$(egrep -o 'webformatURL":"https://pixabay.com/get/(\d+|\w+)+.\w{3}' Linksapi.txt | cut -d '"' -f3)
    wget --quiet $termo 
    #exclusão do arquivo que contem os links da api
    rm Linksapi.txt
    xcowsay --at=400,300 "Deseja ter suas imagens em formato tar.gz?" 2> /dev/null    
    #Verificando se o usario prefere ter um arquivo tar.gz
    (yad --text="Deseja ter suas imagens em formato tar.gz?" --height="100" --width="200" --title="Responda a Clotilde" --buttons-layout=center --button="gtk-yes:0" --button="gtk-no:1" )
    #criação do arquivo tar.gz com as fotos
    if [ $? -eq 0 ]
    then 
        tar -czf $Busca.tar.gz *.jpg
        mv $Busca.tar.gz ..
        cd ..
        rm -r $Busca
        xcowsay --at=400,300 "Seu arquivo \"$Busca.tar.gz\" está pronto!" 2> /dev/null
    #Opção caso o usuario não deseje tar.gz
    else   
        xcowsay --at=400,300 "Suas imagens ja estão na pasta \"$Busca\"" 2> /dev/null
        cd ..
    fi
}
while [ $? -ne 1 ]; do
    Baixar
    xcowsay --at=400,300 "Deseja procurar mais imagens?" 2> /dev/null
    (yad --text="Deseja procurar mais imagens?" --height="100" --width="200" --title="Responda a Clotilde" --buttons-layout=center --button="gtk-yes:0" --button="gtk-no:1" )
done
cd ./Imagem
xcowsay --at=400,300 -d ImageLu.jpeg 2> /dev/null