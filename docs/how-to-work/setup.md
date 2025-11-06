# Como rodar o projeto

Basicamente:

* Abra o seu pgAdmin, crie um db chamado ecommerce_db.
      * Em um mundo ideal, teria que criar um db pra cada microsserviço para mante-los altamente coesos e independentes, mas por praticidade, mantemos tudo em um.

* Rode o script `db_setup.sql` que se encontra no mesmo diretório.

* Valida os .env se estão de acordo com a sua config do banco (senha imtdb ou outra etc).
   * O .env do front não está sendo commitado ent se precisarem das infos dele, basicamente é 
    ```
    PRODUCTS_MS_BASE_URL=http://localhost:5240
    CART_MS_BASE_URL=http://localhost:5245
    LOGIN_MS_BASE_URL=http://localhost:5315
    ```
    por favor, use o cérebro, a porta está chumbada aqui, caso vc altere a porta do microsservico, vc tem que alterar aqui tbm.
    
* Na IDE (VSCode geralmente), na aba de terminal, escolhe **Run Task** e escolha a task **Build Workspace**.
  * Geralmente aqui pode dar problema por eu estar usando powershell como terminal...

* Em teoria estará tudo funcionando yeeeee  

# NÃO COMMITE O SEU .ENV

