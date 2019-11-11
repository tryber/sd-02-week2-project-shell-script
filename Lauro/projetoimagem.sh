#!/bin/bash

echo "Digite um termo de busca das imagens que deseja baixar:"
read BUSCA
if [[ -z "$BUSCA" ]]; then
    echo "Ops, você precisa passar um termo de busca como argumento!"
    exit 1
fi
echo "Quantos resultados você quer baixar?"
read RESULTADOS
if [[ -z "$RESULTADOS" ]]; then
    RESULTADOS=3
elif [[ ! $RESULTADOS =~ ^[0-9]+$ || $RESULTADOS -lt 3 || $RESULTADOS -gt 200 ]]; then
    echo "Ops, você deve digitar um número inteiro entre 3 e 200!"
    exit 1
fi
echo -e 'Deseja compactar as imagens?\n(digite S ou N): '
read COMPACTA
echo 'Baixando imagens...'
API_KEY=14216325-55b3885a9ba66ebf025267411
SEARCH_TERM="$BUSCA"
QTY_RESULTS=$RESULTADOS
RESPONSE=`curl -s -G -L --data-urlencode "key=$API_KEY" --data-urlencode "q=$SEARCH_TERM" --data-urlencode "image_type=photo" --data-urlencode "per_page=$QTY_RESULTS" https://pixabay.com/api | jq --compact-output --raw-output '.hits[].webformatURL'`
if [[ $RESPONSE = "" ]]; then
    echo "Ops, não encontramos nenhum resultado para a sua busca!"
    exit 1
fi
OUTDIR=~/Pixabay_Downloads
TEMPDIR=$OUTDIR/.$BUSCA
if [[ ! -d $OUTDIR ]]; then
    mkdir $OUTDIR
fi
if [[ ! -d $TEMPDIR ]]; then
    mkdir $TEMPDIR
fi
cd $OUTDIR
echo "$RESPONSE" > lista_URL_imagens.txt
wget -q -i lista_URL_imagens.txt -P $TEMPDIR
rm lista_URL_imagens.txt
if [[ ${COMPACTA,,} = "s" ]]; then
    cd $TEMPDIR
    tar czf $BUSCA.tar.gz *
    mv $BUSCA.tar.gz $OUTDIR
    echo "Arquivo $BUSCA.tar.gz criado com sucesso em $OUTDIR"
else
    cd $TEMPDIR
    mv * $OUTDIR
    echo "Arquivos baixados com sucesso na pasta $OUTDIR"
fi
echo "Até a próxima!"
rm -r $TEMPDIR