    #!/bin/bash

# instalação usando zenity

# (
# echo "0"; sleep 1
# echo "# Verificando pacotes necessários" ; sleep 1
# echo "10"; sleep 1;
#     ZENITY_INSTALADO=$`dpkg -l | grep zenity    
#     if ![[ -z  "$ZENITY_INSTALADO" ]]; then
#         echo "Você não tem o Zenity instalado, para instalar execute: sudo apt install zenity"
#     else
#         echo "Você já tem o zenity instalado"`
# echo "20"; sleep 1
# echo "# Instalando o pacote $ZENITY_INSTALADO" 
# echo "30"; sleep 1
# echo "# Instalação em 20%" 
# echo "40"; sleep 1
# echo "# Instalação em 40%" 
# echo "60"; sleep 1
# echo "# Instalação em 60%" 
# echo "65"; sleep 1
# echo "# Instalação em 80%" 
# echo "100"; sleep 1
# echo "# ShowTemp instalado com sucesso" 
# ) |
# zenity --progress --width=600 --height=100 \
#   --title="ShowTemp Setup" \
#   --text="Instalando ShowTemp" \
#   --percentage=0

# # if [ "$?" = -1 ] ; then
# #         zenity --error \
# #           --text="Update canceled."
# # fi

#API KEY
API_KEY=aeffd8cd63ab104d34dbce1049722f15

# Verificar o acesso à internet:
ping -w1 www.google.com.br >/dev/null 2>&1
if [ $? != 0 ]; then
    zenity --error --width=350 --height=150 --text="Você está sem conexão a internet :("
    sleep 2s
    ping -w1 www.google.com.br >/dev/null 2>&1
else
    #capturando variável $CIDADE
    echo "internet ok"
    CIDADE=$(zenity --entry --title="ShowTemp" --width=350 --height=150 --text="Qual sua cidade?")  
    #capturando variável $EXISTE, verifica previamente se a API retorna o erro 404
    EXISTE=$(curl -s -G --data-urlencode "appid=$API_KEY" --data-urlencode "q=$CIDADE" http://api.openweathermap.org/data/2.5/weather | jq '.cod' | cut -d '"' -f2)
        if [ $EXISTE -eq 404 ]; then
        zenity --warning  --title="ShowTemp" --width=350 --height=150 --text="Cidade não encontrada, tente novamente"
        exit 1
        fi
fi

if [[ -z "$CIDADE" ]]; then 
    #retornando erro ao não digitar cidade
    zenity --warning  --title="ShowTemp" --width=350 --height=150 --text="\n\n                         Você não informou sua cidade :("
    exit 1 
else 
    #buscando cidade na API
    RESPONSE=`curl -s -G --data-urlencode "appid=$API_KEY" --data-urlencode "q=$CIDADE" http://api.openweathermap.org/data/2.5/weather | jq '.main["temp"]'`
    echo $RESPONSE
    TEMPERATURA=`echo "scale=2; ($RESPONSE-273.15)" | bc`
fi

#retornando a cidade e a temperatura ao usuário
yad --info --title="ShowTemp" --center --image=src/temperature.png --width=350 --height=150 --text="\n\nSua temperatura é $TEMPERATURA°C"