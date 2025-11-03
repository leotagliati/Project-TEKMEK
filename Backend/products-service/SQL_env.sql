-- Remove a tabela se já existir
DROP TABLE IF EXISTS products_tb;

-- Criação da tabela de produtos
CREATE TABLE products_tb (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  description TEXT DEFAULT NULL,
  price NUMERIC(10, 2) DEFAULT NULL,
  image_url VARCHAR(500) DEFAULT NULL,
  layout_size VARCHAR(50) DEFAULT NULL,
  connectivity VARCHAR(50) DEFAULT NULL,
  product_type VARCHAR(100) DEFAULT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  keycaps_type VARCHAR(50) DEFAULT NULL
);

-- Inserts de produtos
INSERT INTO products_tb (
    name,
    description,
    price,
    image_url,
    layout_size,
    connectivity,
    product_type,
    keycaps_type
) VALUES
(
    'Keychron K3 Max',
    'O K3 Max é um teclado mecânico sem fio discreto com layout de 75%. Ele suporta conexões de 2,4 GHz, Bluetooth e com fio. Com suporte ao QMK/VIA, oferece infinitas possibilidades e maior produtividade no seu trabalho e jogos!',
    499.99,
    'https://i.imgur.com/1bBhl4O.png',
    '75%',
    'Wireless',
    'Teclado Mecânico',
    'Perfil Baixo (Low Profile) ABS'
),
(
    'AKKO 3068B Plus',
    'Um teclado mecânico 65% compacto e cheio de estilo. Possui 3 modos de conexão e switches lineares AKKO CS Jelly Pink para uma digitação suave.',
    389.00,
    'https://i.imgur.com/T00Aprh.png',
    '65%',
    'Wireless',
    'Teclado Mecânico',
    'PBT Double-Shot (Perfil ASA)'
),
(
    'Razer Huntsman V3 Pro',
    'Teclado óptico para e-sports com switches analógicos Razer de 2ª geração. Oferece atuação ajustável e Modo de Disparo Rápido para uma resposta inigualável em jogos.',
    1399.90,
    'https://i.imgur.com/GKijw9R.png',
    'TKL (Tenkeyless)',
    'Com fio',
    'Teclado Mecânico',
    'PBT Double-Shot'
),
(
    'Logitech MX Keys S',
    'Um teclado de membrana avançado, projetado para conforto, precisão e produtividade. Possui teclas côncavas silenciosas e retroiluminação inteligente.',
    649.90,
    'https://i.imgur.com/p0pbkXG.png',
    '100% (Full-size)',
    'Wireless',
    'Teclado de Membrana',
    'Perfil Baixo (Membrana)'
),
(
    'NuPhy Air75 V2',
    'Teclado mecânico 75% low-profile ultracompacto, focado em design e portabilidade para usuários de Mac e Windows. Conectividade tripla e switches Gateron Low Profile 2.0.',
    720.00,
    'https://i.imgur.com/acOz7HN.png',
    '75%',
    'Wireless',
    'Teclado Mecânico',
    'PBT (Perfil nSA Low-Profile)'
);