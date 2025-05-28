/*
-- Query: SELECT * FROM products_db.products_images_tb
LIMIT 0, 1000

-- Date: 2025-05-28 17:18
*/

DROP TABLE IF EXISTS products_images_tb;
CREATE TABLE products_images_tb (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    front_image VARCHAR(2048),
    back_image VARCHAR(2048),
    left_image VARCHAR(2048),
    right_image VARCHAR(2048),
    FOREIGN KEY (product_id) REFERENCES products_tb(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
INSERT INTO products_images_tb (product_id, front_image, back_image, left_image, right_image) VALUES
(1, 'https://placehold.co/80x80', 'https://placehold.co/80x80', 'https://placehold.co/80x80', 'https://placehold.co/80x80'),
(2, 'https://placehold.co/80x80', 'https://placehold.co/80x80', 'https://placehold.co/80x80', 'https://placehold.co/80x80'),
(3, 'https://placehold.co/80x80', 'https://placehold.co/80x80', 'https://placehold.co/80x80', 'https://placehold.co/80x80'),
(4, 'https://placehold.co/80x80', 'https://placehold.co/80x80', 'https://placehold.co/80x80', 'https://placehold.co/80x80'),
(5, 'https://placehold.co/80x80', 'https://placehold.co/80x80', 'https://placehold.co/80x80', 'https://placehold.co/80x80'),
(6, 'https://placehold.co/80x80', 'https://placehold.co/80x80', 'https://placehold.co/80x80', 'https://placehold.co/80x80'),
(7, 'https://placehold.co/80x80', 'https://placehold.co/80x80', 'https://placehold.co/80x80', 'https://placehold.co/80x80'),
(8, 'https://placehold.co/80x80', 'https://placehold.co/80x80', 'https://placehold.co/80x80', 'https://placehold.co/80x80'),
(9, 'https://placehold.co/80x80', 'https://placehold.co/80x80', 'https://placehold.co/80x80', 'https://placehold.co/80x80');
