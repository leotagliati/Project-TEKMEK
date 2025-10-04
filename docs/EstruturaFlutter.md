# Estrutura de Pastas do Projeto Flutter

Este documento descreve o propósito de cada pasta e arquivo principal dentro do diretório `lib/` do projeto Flutter.

---

## `main.dart` 
- Arquivo principal da aplicação.
- Responsável por inicializar o app e definir configurações globais, como rotas e tema.
- Contem apenas a função `runApp()` e a configuração inicial do `MaterialApp` ou `CupertinoApp` (sim, na minha opinião, faz mais sentido não separar o app.dart do main.dart).

---

## `common_components/`
- Contém **componentes reutilizáveis** em toda a aplicação, como botões, campos de input, cards, app bars, etc.
- Os componentes aqui devem ser **independentes de páginas específicas** e podem ser usados em múltiplas telas.
- Exemplos de arquivos:
  - `custom_button.dart`
  - `app_bar.dart`
  - `input_field.dart`

---

## `pages/`
- Contém todas as **telas (pages)** do aplicativo.
- Cada página deve ter sua própria subpasta com:
  - O arquivo principal da tela (ex: `home.page.dart`) utilizando **snake_case** e o **.page** para facilitar a leitura dos grandes seres de pura inteligencia do nosso grupo.
  - Uma subpasta `_compose` para **widgets específicos daquela tela** utilizando **snake_case** e o **.component** para facilitar a leitura dos grandes seres de pura inteligencia do nosso grupo.
- Exemplo de organização:
```
lib/
...
├── pages/
│   ├── home/
│   │   ├── home.page.dart
│   │   └── _compose/
│   │       ├── home_header.component.dart
│   │       └── home_item_card.dart
│   ├── login/
│   │   ├── login.page.dart
│   │   └── _compose/
...
```
---

## `utils/`
- Contém **funções auxiliares, constantes globais e extensões**.
- Devem ser gerais e reutilizáveis em qualquer parte do aplicativo.
- Exemplos de arquivos:
  - `constants.dart` → strings ou valores fixos
  - `formatters.dart` → funções de formatação de datas, números ou strings (nsei se vamos ter isso mas vale deixar anotado)
  - `routes.dart` → arquivo que centraliza **todas as rotas nomeadas** do app

---