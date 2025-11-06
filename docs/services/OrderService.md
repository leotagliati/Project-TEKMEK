# Order Service

## Descrição

O **Order Service** é o microserviço responsável pela **gestão de pedidos** no sistema.  
Ele recebe eventos do **Cart Service** e mantém o estado dos pedidos, incluindo criação, atualização de status e cancelamentos.

---

## Funcionalidades principais

- Criar novos pedidos com base em eventos recebidos do **Cart Service**.
- Atualizar o status de pedidos conforme o andamento do processo (ex: pagamento, envio, cancelamento).
- Cancelar pedidos e manter histórico.
- Armazenar os produtos e preços do momento da compra, garantindo rastreabilidade.

---

## Estrutura do Banco de Dados

### **Tabela `orders_tb`**
| Campo           | Tipo                                            | Descrição                     |
| --------------- | ----------------------------------------------- | ----------------------------- |
| **id**          | UUID                                            | Identificador único do pedido |
| **user_id**     | UUID                                            | Identificador do usuário      |
| **status**      | ENUM(`PENDING`, `PAID`, `CANCELLED`, `SHIPPED`) | Estado atual do pedido        |
| **valor_total** | DECIMAL(10,2)                                   | Valor total do pedido         |
| **created_at**  | TIMESTAMP                                       | Data/hora de criação          |
| **updated_at**  | TIMESTAMP                                       | Última modificação            |

---

### **Tabela `order_items_tb`**
| Campo               | Tipo          | Descrição                             |
| ------------------- | ------------- | ------------------------------------- |
| **id**              | UUID          | Identificador único do item           |
| **order_id**        | UUID          | Referência ao pedido (`orders_tb.id`) |
| **product_id**      | UUID          | Produto associado                     |
| **quantity**        | INT           | Quantidade do produto                 |
| **price_at_moment** | DECIMAL(10,2) | Preço do produto no momento da compra |

> O campo `price_at_moment` vai manter a consistência histórica do valor, mesmo que o preço do produto mude posteriormente.

---

## Fluxo de Eventos

1. **Cart Service** envia o evento `CartCheckoutInitiated` contendo:
   ```json
   {
     "type": "CartCheckoutInitiated",
     "data": {
       "userId": "id-do-usuario",
       "items": [
         { "productId": "id-produto", "quantity": 2 },
         { "productId": "id-produto2", "quantity": 1 }
       ]
     }
   }
