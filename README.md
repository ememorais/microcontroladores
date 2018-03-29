# Guia:
## 1ª Utilização:

Colocar dados pro github saber qual o usuário:

`git config --global user.name "Nome"`

`git config --global user.email email@email.com`

## Pegar código do github:

`cd diretorio\que\os\arquivos\vao\ficar`

`git clone https://github.com/ememorais/microcontroladores.git`

## Adicionar código

pra ver o que mudou da versão no github:

`git status`

Em vermelho ainda não será colocado no commit; 

Para adicionar um arquivo:

`git add arquivo.asd`

Para adicionar todos os arquivos modificados:

`git add .`

Quando terminar de adicionar:

`git commit -m "mensagem dizendo o que mudou resumidamente"`

Para mandar pro github:

`git push origin master`
