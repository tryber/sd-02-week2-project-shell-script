#!/bin/bash
    CIDADE=$*
    API_KEY=434d61d332b71d8b17a8bf7246f78d7e
    TMP_FILE=tmp_file.txt
    if [ -z "$CIDADE" ]
    then
        echo "Ops, você precisa passar o nome de uma cidade como argumento!"
    else

        RESPONSE=$(curl -s -G --data-urlencode "appid=$API_KEY" --data-urlencode "q=$CIDADE" --data-urlencode "units=metric" http://api.openweathermap.org/data/2.5/weather)

        #echo $RESPONSE #Resposta será dada mais abaixo, deixei aqui apenas para efeito de debug caso necessário. - Johnatas
        echo $RESPONSE > $TMP_FILE
        CIDADE_TEMP=$(grep -o -E '"temp":[^,]+' $TMP_FILE | grep -o -E "[^:]+$")
        #echo $CIDADE_TEMP  #Resposta será dada mais abaixo, deixei aqui apenas para efeito de debug caso necessário. - Johnatas
        CIDADE_TR=$(echo $CIDADE_TEMP | tr . ,) #tr no ., porque no Brasil utilizamos ',' como separador de decimais
        echo $CIDADE_TR #Resposta será dada mais abaixo, deixei aqui apenas para efeito de debug caso necessário. - Johnatas
        NOT_FOUND_ERROR=$(grep -o -E "\"cod\":\"404\"" $TMP_FILE)
            
        #echo $NOT_FOUND_ERROR #Resposta será dada mais abaixo, deixei aqui apenas para efeito de debug caso necessário. - Johnatas
        
        if [ $NOT_FOUND_ERROR == '"cod":"404"' ] 2> /dev/null; then  #resolvendo mensagem de falha de operador unário - Johnatas
            echo "Ops, não encontrei a temperatura para esta cidade! A grafia está correta?"
        else
            echo "Em $CIDADE, a temperatura é de $CIDADE_TRºC."
        fi
    fi
