# Cresce Challenge TLF 🚀

## Decisões técnicas e seus trade-offs

O Sistema foi criado utilizando LocalStorage nas duas partes da aplicação, utilizei a API Da FakeStore para pegar os dados dos produtos para realizar o cadastro de novas campanhas de descontos, porem com isso tive que realizar alterações no Design, como adicionar um novo campo select para selecionar o produto dentro da lista informada. O principal problema de utilizar o LocalStorage é que as duas aplicações não estão com os dados interligados, eu queria fazer uma API por tras para realizar essa integração entre as duas, porem não consegui consilhar o teste e meus dois serviços.

Realizei tambem a implementação de um container Docker para facilitar configuração e execução do sistema em diferentes ambientes.

## Instruções de instalação e execução

### Versões utilizadas :

NPM: 10.2.4

node: 18.19.1

docker : 26.0.0

yarn: 1.22.22

flutter: 3.27.2

dart: 3.6.1

### Sistema Web Docker:

1- Certificar que tem o Docker instalado e ligado.

2-  abrir a pasta do projeto via terminal e digitar (docker build -t projeto-web .)

3 -  Executar o container Docker ( docker run -p 3000:3000 projeto-web )

4 - acessar a aplicação pelo http://localhost:3000

### Sistema Web npm:

1 - certificar que tem o node e o npm instalado

2 - Caso não tenha yarn instalado , intale (npm install -g yarn)

3 - rodar (yarn install) na pasta do projeto web

4 - rodar (yarn build) para construir a aplicação

5 - rodar (yarn) start para iniciar a aplicação

### Sistema Mobile Apk

1 - localizar dentro da pasta do sistema mobile o arquivo (APK APP.apk)

2 - enviar para um celular e realizar a instalação padrão

### Sistema Mobile Realizar build

1 - acessar a pasta do sistema

2 - rodar no terminar o comando (flutter build apk)

3 - localizar a pasta /build/host/apk/localizar o arquivo .apk

4 - enviar para um celular e realizar a instalação padrão

### Sistema Mobile Rodar no computador

1 - garantir que tem o Flutter instalado

2 - Iniciar o Emulador / AVD

3 - rode ( flutter devices ) para verificar se o emulador android esta disponivel

4 - rode (flutter run)

## Estratégia de testes

 A estrategia dos testes utilizados foram testes unitarios utilizando o Jest , Mockito, flutter_test, porem não consegui desenvolver todos os testes que gostaria.

## Melhorias futuras e débitos técnicos identificados

Para melhorias futuras eu anotei algumas principais:

Criação de uma API para realizar o salvamento dos dados não apenas localmente, assim podendo integrar as 2 plataformas,

Login de usuários para cadastro de descontos.

implementar CI/CD para deploy da aplicação

e de debito tecnico

Melhoria nos meus testes e estruturação do código FrontEnd.

## Desafios encontrados

- Um dos principais desafios encontrados foi não ter feito testes unitarios em React e em Flutter e tambem nunca ter usado o Flutter Modular, portanto tive que pesquisar sobre e utilizar tutoriais e pesquisas para auxiliar o desenvolvimento.
- Outro foi a questão de pensar em como implementar os descontos sem ter uma API delas , acabei optando por salvar localmente via SharedPreferences e assim tendo a solução para salvar as campanhas, realizando a integração com a API da fakeStore apenas para receber os dados do produto selecionado , e assim alterando o Design para ter um campo novo de Seleção de produto.
- E é claro teve a questão de conciliar o tempo com meu serviço atual, pois precisava entregar demandas e realizar o teste ao mesmo tempo, mas espero ter ido bem!

## Atualizações dia 28/01

* Adicionado mais alguns testes unitarios no sistema
* criado o deploy automatizado pela Vercel do sistema WEB (Optei pela vercel para o teste por ser gratuita e ter um facil manuseio, )
  link: https://crescechallenge-hzv9-cmfcgxmj2-codeflowbrs-projects.vercel.app/



  Muito Obrigado pela opotunidade de participar do teste!
