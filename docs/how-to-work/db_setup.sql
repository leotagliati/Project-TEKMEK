-- =======================================
-- DROP TABLES (para recriar do zero)
-- =======================================
DROP TABLE IF EXISTS order_items_tb CASCADE;
DROP TABLE IF EXISTS orders_tb CASCADE;
DROP TABLE IF EXISTS carts_tb CASCADE;
DROP TABLE IF EXISTS cart_products_tb CASCADE;
DROP TABLE IF EXISTS products_tb CASCADE;
DROP TABLE IF EXISTS login_tb CASCADE;

-- =======================================
-- TABELA DE LOGIN
-- =======================================
CREATE TABLE login_tb (
    idLogin SERIAL PRIMARY KEY,
    username VARCHAR(255) NOT NULL,
    user_pass VARCHAR(255) NOT NULL,
    is_admin BOOL NOT NULL
);

-- =======================================
-- TABELA DE PRODUTOS
-- =======================================
CREATE TABLE products_tb (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    price NUMERIC(10,2) NOT NULL,
    image_url TEXT NOT NULL,
    layout_size VARCHAR(50),
    connectivity VARCHAR(100),
    product_type VARCHAR(100),
    keycaps_type VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =======================================
-- TABELA DE PRODUTOS DO CARRINHO
-- =======================================
CREATE TABLE cart_products_tb (
    id SERIAL PRIMARY KEY,
    product_id INT UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    price NUMERIC(10,2) NOT NULL,
    image_url TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products_tb(id) ON DELETE CASCADE
);

-- =======================================
-- TABELA DE CARRINHOS
-- =======================================
CREATE TABLE carts_tb (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT DEFAULT 1,
    price NUMERIC(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES login_tb(idLogin) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products_tb(id) ON DELETE CASCADE
);

-- =======================================
-- TABELA DE PEDIDOS
-- =======================================
CREATE TABLE orders_tb (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    status VARCHAR(50) DEFAULT 'pendente',
    valor_total NUMERIC(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES login_tb(idLogin) ON DELETE CASCADE
);

-- =======================================
-- TABELA DE ITENS DO PEDIDO
-- =======================================
CREATE TABLE order_items_tb (
    id SERIAL PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price NUMERIC(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders_tb(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products_tb(id) ON DELETE CASCADE
);



-- =======================================
-- POPULAAAAANDO
-- =======================================

-- ========================
-- POPULAÇÃO DE PRODUCTS_TB
-- ========================
INSERT INTO products_tb (
    name,
    description,
    price,
    image_url,
    layout_size,
    connectivity,
    product_type,
    keycaps_type,
    created_at
) VALUES
(
    'Keychron K3 Max',
    'O K3 Max é um teclado mecânico sem fio discreto com layout de 75%. Ele suporta conexões de 2,4 GHz, Bluetooth e com fio. Com suporte ao QMK/VIA, oferece infinitas possibilidades e maior produtividade no seu trabalho e jogos!',
    499.99,
    'https://i.imgur.com/1bBhl4O.png',
    '75%',
    'Wireless',
    'Teclado Mecânico',
    'Perfil Baixo (Low Profile) ABS',
    NOW()
),
(
    'AKKO 3068B Plus',
    'Um teclado mecânico 65% compacto e cheio de estilo. Possui 3 modos de conexão e switches lineares AKKO CS Jelly Pink para uma digitação suave.',
    389.00,
    'https://i.imgur.com/T00Aprh.png',
    '65%',
    'Wireless',
    'Teclado Mecânico',
    'PBT Double-Shot (Perfil ASA)',
    NOW()
),
(
    'Razer Huntsman V3 Pro',
    'Teclado óptico para e-sports com switches analógicos Razer de 2ª geração. Oferece atuação ajustável e Modo de Disparo Rápido para uma resposta inigualável em jogos.',
    1399.90,
    'https://i.imgur.com/GKijw9R.png',
    'TKL (Tenkeyless)',
    'Com fio',
    'Teclado Mecânico',
    'PBT Double-Shot',
    NOW()
),
(
    'Logitech MX Keys S',
    'Um teclado de membrana avançado, projetado para conforto, precisão e produtividade. Possui teclas côncavas silenciosas e retroiluminação inteligente.',
    649.90,
    'https://i.imgur.com/p0pbkXG.png',
    '100% (Full-size)',
    'Wireless',
    'Teclado de Membrana',
    'Perfil Baixo (Membrana)',
    NOW()
),
(
    'NuPhy Air75 V2',
    'Teclado mecânico 75% low-profile ultracompacto, focado em design e portabilidade para usuários de Mac e Windows. Conectividade tripla e switches Gateron Low Profile 2.0.',
    720.00,
    'https://i.imgur.com/acOz7HN.png',
    '75%',
    'Wireless',
    'Teclado Mecânico',
    'PBT (Perfil nSA Low-Profile)',
    NOW()
)
ON CONFLICT DO NOTHING;

-- ========================
-- POPULAÇÃO DE CART_PRODUCTS_TB
-- ========================
INSERT INTO cart_products_tb (product_id, name, price, image_url, created_at)
VALUES
(1, 'Keychron K3 Max', 499.99, 'https://i.imgur.com/1bBhl4O.png', NOW()),
(2, 'AKKO 3068B Plus', 389.00, 'https://i.imgur.com/T00Aprh.png', NOW()),
(3, 'Razer Huntsman V3 Pro', 1399.90, 'https://i.imgur.com/GKijw9R.png', NOW()),
(4, 'Logitech MX Keys S', 649.90, 'https://i.imgur.com/p0pbkXG.png', NOW()),
(5, 'NuPhy Air75 V2', 720.00, 'https://i.imgur.com/acOz7HN.png', NOW())
ON CONFLICT (product_id) DO NOTHING;
