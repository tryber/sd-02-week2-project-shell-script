#!/bin/bash
API_KEY=14226934-e6bc1f36fa5e1560bf098247e
TMP_FILE=tmp_pixabay.txt
REGEX_FILE=pixabay_regex.txt
SEARCH_TERM="$1"
QTY_RESULTS="$2"
TIMESTAMP=$(date +'%Y%m%d%H%M%S')
PASTA_INIT=$(pwd)
if [ -z "$SEARCH_TERM" ]; then
    xcowsay --at=100,250 $'Ops, você precisa passar um termo de busca como primeiro argumento!\nVou fechar aqui, então chame o script novamente e digite o que quer buscar ok?'
    exit 1
elif [ -z "$QTY_RESULTS" ]; then
    QTY_RESULTS=3
    xcowsay --at=100,250 $'Não foi passado nenhum valor como segundo argumento.\nEntão, o script vai procurar por 3 fotos, que é o mínimo do Pixabay.'
fi
[ "$QTY_RESULTS" -gt 0 ] 2> /dev/null
LAST_SH=$?
if [ "$LAST_SH" -gt 0 ]; then
    xcowsay --at=100,250 $'Ops, você precisa passar um valor numérico de fotos para buscar como segundo argumento!\nVou fechar aqui, então chame o script novamente e digite a quantidade desejada ok?'
    exit 1
elif [ "$QTY_RESULTS" -lt 3 ] || [ "$QTY_RESULTS" -gt 200 ]; then
    xcowsay --at=100,250 $'O site consegue retornar entre 3 a 200 imagens por pesquisa.\nPor favor, refaça a pesquisa digitando um valor entre 3 a 200 como argumento.'
    exit 1
fi
RESPONSE=$(curl -s -G -L --data-urlencode "key=$API_KEY" --data-urlencode "q=$SEARCH_TERM" --data-urlencode "image_type=photo" --data-urlencode "per_page=$QTY_RESULTS" https://pixabay.com/api)
echo "$RESPONSE" > "$TMP_FILE"
grep -o -E '"webformatURL":[^,]+' "$TMP_FILE" | cut -d: -f2-3 | grep -o -E '[^"]+' > "$REGEX_FILE"
COUNT_LINES=$(wc -l < "$REGEX_FILE")
COUNT_BYTES=$(wc -m < "$REGEX_FILE")
if [ "$COUNT_BYTES" -eq 0 ]; then
    xcowsay --at=100,250 $'Nenhuma foto encontrada de acordo com o argumento passado.\nVerifique a grafia e tente novamente.'
    rm $TMP_FILE
    rm $REGEX_FILE
    exit 1
fi
xcowsay --at=100,250 $'Foram encontradas '"$COUNT_LINES"' fotos de acordo com o argumento passado.'
xcowsay --at=100,250 $'Qual a saída preferida? Uma pasta ou um arquivo TAR?'
OPTION=$(zenity  --list  --text "Escolha sua opção" --radiolist --column "Marcar" --column "Opções" FALSE "Arquivo TAR" TRUE "Nova pasta");
if [ "$OPTION" = "Nova pasta" ]; then
mkdir "$SEARCH_TERM" 2> /dev/null
LAST_SH=$?
    if [ "$LAST_SH" -gt 0 ]; then
        xcowsay --at=100,250 $'Ops, parece que a pasta já existe!\nCaso queira criar uma pasta nova, digite um nome para a pasta e clique no OK.\nCaso queira utilizar a pasta já criada, deixe a caixa em branco e clique em OK.'
        PASTA=$(zenity --title="Criar nova pasta?" --text "Por favor, insira um nome para a nova pasta ou deixe vazio para usar a pasta já criada." --entry)
        if [ -z "$PASTA" ]; then
            PASTA="$SEARCH_TERM"
        fi
        mkdir "$PASTA" 2> /dev/null
        cd "$PASTA" || exit
        wget --show-progress -qi ../"$REGEX_FILE" | zenity --progress --pulsate --no-cancel --text "Baixando fotos, aguarde um momento:" --width=300 --height=80
        xcowsay --at=100,250 $'Os arquivos foram baixados para a pasta \n'"$PASTA"', obrigado pelo uso!'
    else
        cd "$SEARCH_TERM" || exit
        wget --show-progress -qi ../"$REGEX_FILE" | zenity --progress --pulsate --no-cancel --text "Baixando fotos, aguarde um momento:" --width=300 --height=80
        xcowsay --at=100,250 $'Os arquivos foram baixados para a pasta \n'"$SEARCH_TERM"', obrigado pelo uso!'
    fi
elif [ "$OPTION" = "Arquivo TAR" ]; then
    mkdir pixabay-"$TIMESTAMP"
    cd pixabay-"$TIMESTAMP" || exit
    wget --show-progress -qi ../"$REGEX_FILE" | zenity --progress --pulsate --no-cancel --auto-close --text "Baixando fotos, aguarde um momento:" --width=300 --height=80
    cd "$PASTA_INIT" || exit
    tar -czf pixabay-"$SEARCH_TERM"-"$TIMESTAMP".tar.gz pixabay-"$TIMESTAMP"
    rm -r pixabay-"$TIMESTAMP"
    xcowsay --at=100,250 $'Os arquivos foram baixados e após isso compactados, o nome do arquivo TAR é:\npixabay-'"$TIMESTAMP"'.tar.gz, obrigado pelo uso!'
fi
cd "$PASTA_INIT" || exit
    rm $TMP_FILE
    rm $REGEX_FILE
