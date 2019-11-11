#!/bin/bash
clear
API_Key=14225963-65f011eac0dcadc2019128ae2

echo -e "Digite um termo de busca para download de imagens:\n(somente em português)"

ping -c 1 google.com >/dev/null
ultimaSaida=$?
if [ "$ultimaSaida" = 0 ]
then
echo "Você tem uma conexão, vamos à pesquisa!"
else
echo "Você não tem uma conexão à internet pra realizar a busca =("
exit
fi

clear
if [[ -z "$termoBusca" ]]; then
    echo "Ops, você precisa digitar um termo de busca!"
    exit 1
fi
clear
echo "Quantas imagens você deseja baixar?"
read -r qtdeResultados
clear
if [[ -z "$qtdeResultados" ]]; then
    qtdePadrao=3
    echo -e "Por padrão, serão baixadas três imagens!\nAguarde enquanto buscamos..."
    RESPONSE=$(curl -s -G -L --data-urlencode "key=$API_Key" --data-urlencode "q=$termoBusca" --data-urlencode "image_type=photo" --data-urlencode "lang=pt" --data-urlencode "per_page=$qtdePadrao" https://pixabay.com/api)
    echo "$RESPONSE" | grep -o -E '"webformatURL":[^,]+' | grep -o -E '(http[s]?|[s]?ftp[s]?)(:\/\/)([^\s,]+)([^"]+)' > lista.txt
    if [[ ! -s lista.txt ]]; then
        echo "Ops, não encontrei nenhuma imagem para esta busca."
        rm -rf lista.txt
        exit 1
    fi
    clear
    echo "Suas imagens estão sendo baixadas!"
    mkdir "$termoBusca"
    mv lista.txt ./"$termoBusca"/
    cd "$termoBusca" || exit
    wget -i lista.txt -q

    echo "Suas fotos foram salvas na pasta \"$termoBusca\""
    Menu(){
            echo -e "Você deseja compactar a pasta com os arquivos?\n[ 1 ] Sim\n[ 2 ] Não\n[ 3 ] Sair\nQual a opção desejada?"
            read -r condicional

            case $condicional in
                1) Sim ;;
                2) Não ;;
                3) exit ;;
                *) echo -e "\nOpção desconhecida, informe uma opção válida" ; echo ; Menu ;;
            esac
        }
        Sim () {
            cd ..
            tar -zcf "$termoBusca".tar.gz "$termoBusca"/
            echo "Seu arquivo foi compactado"
            rm -rf "$termoBusca"
            exit
        }
        Não () {
        exit
        }
        Menu
    exit 1

elif (( "$qtdeResultados" < 3 || "$qtdeResultados" > 200 )); then
    echo "Ops, o número de imagens deve estar entre 3 e 200."
    exit 1

elif (( "$qtdeResultados" >= 3 || "$qtdeResultados" <= 200 )); then

    echo "Aguarde enquanto buscamos..."

    RESPONSE=$(curl -s -G -L --data-urlencode "key=$API_Key" --data-urlencode "q=$termoBusca" --data-urlencode "image_type=photo" --data-urlencode "lang=pt" --data-urlencode "per_page=$qtdeResultados" https://pixabay.com/api)

    echo "$RESPONSE" | grep -o -E '"webformatURL":[^,]+' | grep -o -E '(http[s]?|[s]?ftp[s]?)(:\/\/)([^\s,]+)([^"]+)' > lista.txt

    if [[ ! -s lista.txt ]]; then
        echo "Ops, não encontrei nenhuma imagem para esta busca."
        rm -rf lista.txt
        exit 1
    fi

    echo "Suas imagens estão sendo baixadas..."

    mkdir "$termoBusca"
    mv lista.txt ./"$termoBusca"/
    cd "$termoBusca" || exit
    wget -i lista.txt -q
    rm -rf lista.txt
    clear
    echo "Suas fotos foram salvas na pasta \"$termoBusca\"!"

        Menu(){
            echo -e "Você deseja compactar a pasta com os arquivos?\n[ 1 ] Sim\n[ 2 ] Não\n[ 3 ] Sair\nQual a opção desejada?"
            read -r condicional

            case $condicional in
                1) Sim ;;
                2) Não ;;
                3) exit ;;
                *) echo -e "\nOpção desconhecida, informe uma opção válida" ; echo ; Menu ;;
            esac
        }
        Sim () {
            cd ..
            tar -zcf "$termoBusca".tar.gz "$termoBusca"/
            echo "Seu arquivo foi compactado"
            rm -rf "$termoBusca"
            exit
        }
        Não () {
        exit
        }
        Menu
fi
