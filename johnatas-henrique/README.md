#Arquivos da Semana 2 - Projeto Shell Script

#Geral:

Nos **dois exercícios**, preferimos utilizar apenas **REGEX**, apesar da facilidade de usar o `jq`, para fixação dos conteúdos.
Os dois scripts dependem do `zenity` e do `xcowsay` para funcionarem corretamente, sem esses dois programas, o script não roda perfeitamente.

###Exercício 1:

1.0) **Todas** as **funções** pedidas na página do curso foram **alcançadas, incluindo a bônus**.
1.1) Esse script **não necessita** que cidades com mais de um nome sejam escritas entre **aspas** (exemplo, Belo Horizonte), pois ele pega todos os argumentos passados e transforma em apenas 1 argumento.
1.2) Foi **adicionada** uma função pequena a mais no exercício, que é a **visualização do país** ao qual a cidade pertence, colocamos isso para ajudar a checar se a cidade retornada na pesquisa é a correta, por exemplo, a cidade de Embu, também é conhecida como Embu das Artes, no script ao digitarmos Embu, temos o retorno de uma cidade do Quênia (KE), chamada Embu, então nesse caso, foi importante para ajudar a saber que estávamos pesquisando a cidade errada (que deve ser pesquisada como Embu das Artes).

###Exercício 2:

1.0) **Todas** as **funções** pedidas na página do curso foram **alcançadas, incluindo a bônus**.
1.1) O **script verifica** se o **argumento #2** (número de fotos a ser baixadas) é um **número**, porque um usuário pode digitar uma string ali e causar um erro, o script está **tratando** o **erro**, e passando uma **orientação** para o **usuário** sobre como proceder caso isso ocorra.
1.2) Utilizamos uma **janela do zenity** para que o usuário possa **escolher** sua opção, se **arquivo TAR** ou **nova pasta**, e com isso, demos ao usuário a opção de utilizar o **script todo sem** precisar do **terminal** depois de chamar o script com seus argumentos, a combinação do xcowsay com o zenity permite isso.
1.3) Criamos uma **verificação** para saber se a **pasta** onde o script vai baixar as coisas **já existe**, se a pasta existir, ele dá **opção** ao usuário de ou digitar um **novo nome** para a pasta (o nome padrão é o nome da pesquisa do usuário passada via argumento) ou utilizar a pasta **já criada**.
1.4) Na opção de criar o **arquivo .TAR**, vimos que caso o usuário faça a mesma pesquisa duas vezes, o nome do arquivo poderia causar problemas, então **adicionamos** ao nome do arquivo criado, um **timestamp**, com data completa (ano-mes-dia-hora-minuto-segundo), fazendo com que seja **extremamente difícil** qualquer tipo de **problema** em relação ao nome do arquivo, com a timestamp, é **praticamente impossível** dois **arquivos** saírem do script com o **mesmo nome**.

**#VQV #gotrybe**
