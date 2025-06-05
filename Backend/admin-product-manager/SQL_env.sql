-- Remove a tabela se já existir
DROP TABLE IF EXISTS products_tb;

-- Criação da tabela de produtos
CREATE TABLE products_tb (
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
INSERT INTO products_tb (id, name, description, price, image_url, layout_size, connectivity, product_type, created_at, keycaps_type) VALUES
(1, 'Keychron K6', 'Teclado mecânico compacto 65% com Bluetooth.', 449.90, 'https://place.holder.image', '65%', 'Bluetooth', 'Keyboards', '2025-05-27 09:06:46', 'ABS'),
(2, 'Logitech K380', 'Teclado compacto e silencioso, ideal para mobilidade.', 199.90, 'https://place.holder.image', '75%', 'Bluetooth', 'Keyboards', '2025-05-27 09:06:46', 'PBT'),
(3, 'Redragon Kumara K552', 'Teclado mecânico 87 teclas com iluminação RGB.', 259.99, 'https://place.holder.image', '80%', 'USB', 'Keyboards', '2025-05-27 09:06:46', 'PBT'),
(4, 'Corsair K100', 'Teclado gamer com switches ópticos e alta performance.', 999.00, 'https://place.holder.image', '100%', 'USB', 'Keyboards', '2025-05-27 09:06:46', 'ABS'),
(5, 'Razer BlackWidow V3 Mini', 'Compacto com switches verdes e conexão sem fio.', 799.90, 'https://place.holder.image', '65%', 'Bluetooth', 'Keyboards', '2025-05-27 09:06:46', 'ABS'),
(6, 'Logitech MX Keys Mini', 'Teclado silencioso com design elegante.', 699.90, 'https://place.holder.image', '60%', 'Bluetooth', 'Keyboards', '2025-05-27 09:06:46', 'ABS'),
(7, 'Anne Pro 2', 'Teclado 60% RGB mecânico com Bluetooth.', 499.00, 'https://place.holder.image', '60%', 'Bluetooth', 'Keyboards', '2025-05-27 09:06:46', 'ABS'),
(8, 'HyperX Alloy Origins', 'Teclado mecânico 100% com RGB e corpo em alumínio.', 579.99, 'https://place.holder.image', '100%', 'USB', 'Keyboards', '2025-05-27 09:06:46', 'PBT');

-- Remove a tabela de imagens se já existir
DROP TABLE IF EXISTS products_images_tb;

-- Criação da tabela de imagens
CREATE TABLE products_images_tb (
  id SERIAL PRIMARY KEY,
  product_id INT NOT NULL,
  front_image VARCHAR(2048),
  back_image VARCHAR(2048),
  left_image VARCHAR(2048),
  right_image VARCHAR(2048),
  FOREIGN KEY (product_id) REFERENCES products_tb(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- Inserts de imagens
INSERT INTO products_images_tb (product_id, front_image, back_image, left_image, right_image) VALUES
(1, 'https://placehold.co/80x80', 'https://placehold.co/80x80', 'https://placehold.co/80x80', 'https://placehold.co/80x80'),
(2, 'https://placehold.co/80x80', 'https://placehold.co/80x80', 'https://placehold.co/80x80', 'https://placehold.co/80x80'),
(3, 'https://placehold.co/80x80', 'https://placehold.co/80x80', 'https://placehold.co/80x80', 'https://placehold.co/80x80'),
(4, 'https://placehold.co/80x80', 'https://placehold.co/80x80', 'https://placehold.co/80x80', 'https://placehold.co/80x80'),
(5, 'https://placehold.co/80x80', 'https://placehold.co/80x80', 'https://placehold.co/80x80', 'https://placehold.co/80x80'),
(6, 'https://placehold.co/80x80', 'https://placehold.co/80x80', 'https://placehold.co/80x80', 'https://placehold.co/80x80'),
(7, 'https://placehold.co/80x80', 'https://placehold.co/80x80', 'https://placehold.co/80x80', 'https://placehold.co/80x80'),
(8, 'https://placehold.co/80x80', 'https://placehold.co/80x80', 'https://placehold.co/80x80', 'https://placehold.co/80x80');
