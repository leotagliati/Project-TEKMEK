-- Tabela de pedidos
CREATE TABLE orders_tb (
    order_id UUID PRIMARY KEY,
    user_id VARCHAR NOT NULL,
    status VARCHAR NOT NULL DEFAULT 'PENDING',
    total NUMERIC NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela de itens do pedido
CREATE TABLE order_items_tb (
    id SERIAL PRIMARY KEY,
    order_id UUID REFERENCES orders_tb(order_id) ON DELETE CASCADE,
    product_id VARCHAR NOT NULL,
    quantity INT NOT NULL
);
-- Remove a tabela se já existir
DROP TABLE IF EXISTS products_tb;

-- Criação da tabela de produtos
CREATE TABLE known_products_tb (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  description TEXT DEFAULT NULL,
  price NUMERIC(10,2) DEFAULT NULL,
  image_url VARCHAR(500) DEFAULT NULL,
  layout_size VARCHAR(50) DEFAULT NULL,
  connectivity VARCHAR(50) DEFAULT NULL,
  product_type VARCHAR(100) DEFAULT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  keycaps_type VARCHAR(50) DEFAULT NULL
);

-- Inserts de produtos
INSERT INTO known_products_tb (id, name, description, price, image_url, layout_size, connectivity, product_type, created_at, keycaps_type) VALUES
(1, 'Keychron K6', 'Teclado mecânico compacto 65% com Bluetooth.', 449.90, 'https://place.holder.image', '65%', 'Bluetooth', 'Keyboards', '2025-05-27 09:06:46', 'ABS'),
(2, 'Logitech K380', 'Teclado compacto e silencioso, ideal para mobilidade.', 199.90, 'https://place.holder.image', '75%', 'Bluetooth', 'Keyboards', '2025-05-27 09:06:46', 'PBT'),
(3, 'Redragon Kumara K552', 'Teclado mecânico 87 teclas com iluminação RGB.', 259.99, 'https://place.holder.image', '80%', 'USB', 'Keyboards', '2025-05-27 09:06:46', 'PBT'),
(4, 'Corsair K100', 'Teclado gamer com switches ópticos e alta performance.', 999.00, 'https://place.holder.image', '100%', 'USB', 'Keyboards', '2025-05-27 09:06:46', 'ABS'),
(5, 'Razer BlackWidow V3 Mini', 'Compacto com switches verdes e conexão sem fio.', 799.90, 'https://place.holder.image', '65%', 'Bluetooth', 'Keyboards', '2025-05-27 09:06:46', 'ABS'),
(6, 'Logitech MX Keys Mini', 'Teclado silencioso com design elegante.', 699.90, 'https://place.holder.image', '60%', 'Bluetooth', 'Keyboards', '2025-05-27 09:06:46', 'ABS'),
(7, 'Anne Pro 2', 'Teclado 60% RGB mecânico com Bluetooth.', 499.00, 'https://place.holder.image', '60%', 'Bluetooth', 'Keyboards', '2025-05-27 09:06:46', 'ABS'),
(8, 'HyperX Alloy Origins', 'Teclado mecânico 100% com RGB e corpo em alumínio.', 579.99, 'https://place.holder.image', '100%', 'USB', 'Keyboards', '2025-05-27 09:06:46', 'PBT');
