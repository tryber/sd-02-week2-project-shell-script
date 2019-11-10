#!/bin/bash
API_KEY=14226934-e6bc1f36fa5e1560bf098247e
TMP_FILE=tmp_pixabay.txt
REGEX_FILE=pixabay_regex.txt
SEARCH_TERM="$1"
QTY_RESULTS="$2"
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
xcowsay --at=200,250 $'Qual a saída preferida? Uma pasta ou um arquivo TAR?.'
OPTION=$(zenity  --list  --text "Selecione seu sistema favorito" --radiolist --column "Marcar" --column "Opções" TRUE "Pasta com o nome do argumento" FALSE "Arquivo TAR");
echo "$OPTION"
if [ "$OPTION" = "Pasta com o nome do argumento" ]; then
mkdir "$1"
cd "$1"
wget -i ../"$REGEX_FILE"
xcowsay --at=200,250 $'Os arquivos foram baixados para a pasta \n'"$1"', obrigado pelo uso!.'
fi
if [ "$OPTION" = "Arquivo TAR" ]; then
echo $"construir opção TAR"
fi
