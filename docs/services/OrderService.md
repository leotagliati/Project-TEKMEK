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

> Observação: o projeto usa `INTEGER`/`SERIAL` para identificadores (não UUIDs).

### **Tabela `orders_tb`**
| Campo           | Tipo                      | Descrição                             |
| --------------- | ------------------------- | ------------------------------------- |
| **id**          | `SERIAL` PRIMARY KEY      | Identificador do pedido               |
| **user_id**     | `INT`                     | Referência ao usuário (`login_tb.idLogin`) |
| **status**      | `VARCHAR(50)`             | Estado atual do pedido (`pendente`, `pago`, `cancelado`, `enviado`, etc.) |
| **valor_total** | `NUMERIC(10,2)`           | Valor total do pedido                 |
| **created_at**  | `TIMESTAMP`               | Data/hora de criação                  |
| **updated_at**  | `TIMESTAMP`               | Última modificação                    |

### **Tabela `order_items_tb`**
| Campo     | Tipo            | Descrição                                           |
| --------- | --------------- | --------------------------------------------------- |
| **id**    | `SERIAL`        | Identificador do item                               |
| **order_id** | `INT`         | FK para `orders_tb.id`                              |
| **product_id** | `INT`      | FK para `products_tb.id`                            |
| **quantity** | `INT`         | Quantidade do produto                               |
| **price**  | `NUMERIC(10,2)` | Preço do produto no momento da compra (unitário)    |

> O campo `price` em `order_items_tb` guarda o preço unitário no momento do checkout, garantindo consistência histórica mesmo que o preço do `products_tb` mude depois.

---

## Fluxo de Eventos

1. **Cart Service** envia o evento `CartCheckoutInitiated` contendo, por exemplo:

```json
{
  "type": "CartCheckoutInitiated",
  "data": {
    "userId": 12,
    "items": [
      { "productId": 3, "quantity": 2 },
      { "productId": 8, "quantity": 1 }
    ]
  }
}
