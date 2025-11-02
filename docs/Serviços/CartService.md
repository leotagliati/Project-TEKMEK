# Documentação da API de Carrinho - E-commerce

## 1. Introdução
Essa API fornece acesso às operações do **carrinho de compras** do nosso e-commerce, permitindo operações de **consulta**, **adição**, **remoção** e **atualização** de itens no carrinho de cada usuário.

O microserviço é responsável por manter o estado do carrinho de forma persistente ou temporária, dependendo do usuário (logado ou convidado).

---

## 2. Rotas
Os endpoints principais são:

| Endpoint              | Método | Descrição                                     |
| --------------------- | ------ | --------------------------------------------- |
| `/api/checkout`       | GET    | Retorna o carrinho completo do usuário atual  |
| `/api/checkout`       | POST   | Adiciona um item ao carrinho do usuário atual |
| `/api/checkout`       | PUT    | Atualiza a quantidade de um item no carrinho  |
| `/api/checkout`       | DELETE | Remove um item específico do carrinho         |
| `/api/checkout/clear` | DELETE | Limpa todos os itens do carrinho              |
(/api/checkout/clear nao foi feito ainda) 

---

## 3. Navegando pelo código

### ApiEndpoints
Essa classe contém **todas as rotas** que o microserviço de carrinho pode acessar.  
Diferente de criar várias classes por recurso, mantemos **uma única classe centralizada** para todas as APIs, inclusive produtos e carrinho, para padronização.

---

### CartService
Essa classe contém **todos os métodos que o carrinho pode executar**:

- `getUserItems()` → busca o carrinho do usuário  
- `addItemToCart(item)` → adiciona um item  
- `updateCartItem(itemId, qty)` → atualiza quantidade de um item  
- `removeCartItem(itemId)` → remove um item do carrinho  

Ela utiliza um **objeto singleton `RequestHandler`** para fazer as requisições, aproveitando os endpoints definidos em `ApiEndpoints`.
