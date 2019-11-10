#!/bin/bash
API_KEY=14234971-002ebb11c2d7a00eb49d80094
TMP_FILE=tmp_pixabay.txt
REGEX_FILE=pixabay_regex.txt
SEARCH_TERM="$1"
QTY_RESULTS="$2"
TIMESTAMP=$(date ++'%Y%m%d%H%M%S')
PASTA_INIT=$(pwd)
echo $PASTA_INIT
if [ -z "$QTY_RESULTS" ]; then
    QTY_RESULTS=3
    xcowsay --at=200,250 $'Como não foi passado nenhum valor, baixaremos 3 fotos.'
elif [ "$QTY_RESULTS" -lt 3 ] || [ "$QTY_RESULTS" -gt 200 ]; then
    xcowsay --at=200,250 $'O site consegue retornar entre 3 a 200 imagens por pesquisa.\nPor favor, refaça a pesquisa digitando um valor entre 3 a 200 como argumento.'
    exit 1
fi
RESPONSE=$(curl -s -G -L --data-urlencode "key=$API_KEY" --data-urlencode "q=$SEARCH_TERM" --data-urlencode "image_type=photo" --data-urlencode "per_page=$QTY_RESULTS" https://pixabay.com/api)
echo "$RESPONSE" > "$TMP_FILE"
grep -o -E '"webformatURL":[^,]+' "$TMP_FILE" | cut -d: -f2-3 | grep -o -E '[^"]+' > "$REGEX_FILE"
COUNT_LINES=$(wc -l < "$REGEX_FILE")
COUNT_BYTES=$(wc -m < "$REGEX_FILE")
if [ "$COUNT_BYTES" -eq 0 ]; then
    xcowsay --at=200,250 $'Nenhuma foto encontrada de acordo com o argumento passado.'
    exit 1
fi
xcowsay --at=200,250 $'Foram encontradas '"$COUNT_LINES"' fotos de acordo com o argumento passado.'
xcowsay --at=200,250 $'Qual a saída preferida? Uma pasta ou um arquivo TAR?'
OPTION=$(zenity  --list  --text "Escolha sua opção" --radiolist --column "Marcar" --column "Opções" FALSE "Arquivo TAR" TRUE "Nova pasta");
echo "$OPTION"
if [ "$OPTION" = "Nova pasta" ]; then
mkdir "$SEARCH_TERM" 2> /dev/null
    if [ $? != 0 ]; then
        xcowsay --at=200,250 $'Ops, parece que a pasta já existe!\nCaso queira criar uma pasta nova, digite um nome para a pasta e clique no OK.\nCaso queira utilizar a pasta já criada, deixe a caixa em branco e clique em OK.'
        PASTA=$(zenity --title="Criar nova pasta?" --text "Por favor, insira um nome para a nova pasta ou deixe vazio para usar a pasta já criada." --entry)
        if [ -z "$PASTA" ]; then
            PASTA="$SEARCH_TERM"
        fi
        mkdir "$PASTA" 2> /dev/null
        cd "$PASTA"
        wget --show-progress -qi ../"$REGEX_FILE" | zenity --progress --pulsate --no-cancel --text "Baixando fotos, aguarde um momento:" --width=300 --height=80
        xcowsay --at=200,250 $'Os arquivos foram baixados para a pasta \n'"$PASTA"', obrigado pelo uso!'
    else
        cd "$SEARCH_TERM"
        wget --show-progress -qi ../"$REGEX_FILE" | zenity --progress --pulsate --no-cancel --text "Baixando fotos, aguarde um momento:" --width=300 --height=80
        xcowsay --at=200,250 $'Os arquivos foram baixados para a pasta \n'"$SEARCH_TERM"', obrigado pelo uso!'
    fi
fi
if [ "$OPTION" = "Arquivo TAR" ]; then
    echo "construir opção TAR"
    pwd
    mkdir wget-"$TIMESTAMP"
    cd wget-"$TIMESTAMP"
    pwd
    echo "construir opção TAR"
fi
cd $PASTA_INIT
    rm $TMP_FILE
    rm $REGEX_FILE
