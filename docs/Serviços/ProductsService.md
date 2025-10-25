# Documentação da API de Produtos - E-commerce

## 1. Introdução
Essa API fornece acesso aos produtos do nosso e-commerce, permite operações de **consulta**, **criação**, **atualização** e **remoção** de produtos (ou pelo menos deveria ser assim).

## 2. Autenticação
A API utiliza **Token** de admin para autenticação na hora de realizar **criação**, **atualização** e **remoção**. 

No semestre passado, a gente fez duas bases de dados de produtos:
1. Produtos Cliente
2. Produtos Admin
Era feito assim pq em teoria, produtos adicionados em **ADMIN** seriam transferidos para a tabela **CLIENTE** via evento.

Talvez possa manter essa feature, mas não sei a eficiencia disso, então acho melhor **os dois serviços utilizarem uma mesma base**.

## 3. Rotas
Basicamente os endpoints serão:
   * '/products', GET/ POST (POST somente feito com autenticação de admin)
   * '/products/:id' , GET/ PUT/ DELETE (PUT e DELETE somente feitos com autenticação de admin)

## 4. Navegando pelo cógido
Bom, essa é a parte que deve gerar mais dúvida, então vamos com calma:
   
### ApiEndpoints
    Essa classe contém TODAS as rotas que TODAS as API'S podem fazer requisições.
    Vale ressaltar que não temos uma classe por serviço, é UMA para todos.

### Products Service
    Essa classe contém TODAS os métodos que o serviço pode executar.
    Ela usa um objeto SINGLETON "RequestHandler" para fazer as requisições e o seu respectivo ApiEndpoints com todas as rotas.
    

