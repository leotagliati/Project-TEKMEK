-- =======================================
-- DROP TABLES (para recriar do zero)
-- =======================================
DROP TABLE IF EXISTS order_products_tb CASCADE;

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
    price NUMERIC(10, 2) NOT NULL,
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
    price NUMERIC(10, 2) NOT NULL,
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
    price NUMERIC(10, 2) NOT NULL,
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
    valor_total NUMERIC(10, 2) NOT NULL,
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
    price NUMERIC(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders_tb(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products_tb(id) ON DELETE CASCADE
);

CREATE TABLE order_products_tb (
    id SERIAL PRIMARY KEY,
    product_id INT UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    price NUMERIC(10, 2) NOT NULL,
    image_url TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products_tb(id) ON DELETE CASCADE
);

-- =======================================
-- POPULAAAAANDO
-- =======================================

-- ========================
-- POPULAÇÃO DE PRODUCTS_TB
-- ========================
INSERT INTO
    products_tb (
        name,
        description,
        price,
        image_url,
        layout_size,
        connectivity,
        product_type,
        keycaps_type,
        created_at
    )
VALUES
    (
        'Mistel Barocco MD770',
        'Teclado split TKL ergonômico, projetado para reduzir a tensão nos pulsos. Possui keycaps PBT e switches Cherry MX genuínos.',
        890.00,
        'https://i.imgur.com/Ln7eBeF.png',
        'TKL (Tenkeyless)',
        'Com fio',
        'Teclado Mecânico',
        'Cherry',
        NOW()
    ),
    (
        'Ducky One 3 Full-size',
        'Versão 100% do Ducky One 3, ideal para quem precisa do numpad. Mantém as keycaps PBT doubleshot e a construção "Quack Mechanics".',
        899.90,
        'https://i.imgur.com/HekFCi9.png',
        '100% (Full-size)',
        'Com fio',
        'Teclado Mecânico',
        'Cherry',
        NOW()
    ),
    (
        'Kailh Box Jade (70x)',
        'Switches clicky (thick click) com click bar. Oferecem um feedback tátil e sonoro muito nítido, ideal para quem gosta de "clicks".',
        149.90,
        'https://i.imgur.com/bBXNsPu.png',
        'Não se aplica',
        'Não se aplica',
        'Switch',
        'Não se aplica',
        NOW()
    ),
    (
        'Keychron K3 Max',
        'O K3 Max é um teclado mecânico sem fio discreto com layout de 75%. Ele suporta conexões de 2,4 GHz, Bluetooth e com fio. Com suporte ao QMK/VIA, oferece infinitas possibilidades e maior produtividade no seu trabalho e jogos!',
        499.99,
        'https://i.imgur.com/1bBhl4O.png',
        '75%',
        'Wireless',
        'Teclado Mecânico',
        'DSA',
        NOW()
    ),
    (
        'HK Gaming "BoW" (Cherry)',
        'Set de keycaps PBT (clone) no tema Black on White (BoW). Oferece o visual clássico do perfil Cherry por um preço acessível.',
        159.90,
        'https://i.imgur.com/8ECHfuX.png',
        'Não se aplica',
        'Não se aplica',
        'Keycap',
        'Cherry',
        NOW()
    ),
    (
        'Ducky MIYA Pro',
        'Teclado 65% em parceria com a Varmilo. Apresenta designs exclusivos e uma qualidade de construção de nível entusiasta.',
        719.90,
        'https://i.imgur.com/6c4W6N7.png',
        '65%',
        'Com fio',
        'Teclado Mecânico',
        'Cherry',
        NOW()
    ),
    (
        'Das Keyboard 4 Professional',
        'Teclado 100% focado em produtividade, com switches Cherry MX. Inclui um hub USB 3.0 e um knob de volume oversized.',
        900.00,
        'https://i.imgur.com/lENsQ9Q.png',
        '100% (Full-size)',
        'Com fio',
        'Teclado Mecânico',
        'OEM',
        NOW()
    ),
    (
        'Royal Kludge RK68',
        'Teclado 65% hotswap com tripla conexão (2.4Ghz, BT, Fio). É uma escolha popular para quem busca customização sem gastar muito.',
        349.90,
        'https://i.imgur.com/rWLh3AK.png',
        '65%',
        'Wireless',
        'Teclado Mecânico',
        'OEM',
        NOW()
    ),
    (
        'Vortex Race 3',
        'Teclado 75% compacto com case de alumínio e keycaps DSA PBT. Seu layout único inclui uma fileira de F-keys bem integrada.',
        649.90,
        'https://i.imgur.com/2451ANN.png',
        '75%',
        'Com fio',
        'Teclado Mecânico',
        'DSA',
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
        'SA',
        NOW()
    ),
    (
        'Akko CS Jelly Pink (45x)',
        'Switch linear leve e suave, com mola de 45g. Ótimo para digitação rápida e jogos, pacote com 45 unidades.',
        60.00,
        'https://i.imgur.com/yrzyQ6q.png',
        'Não se aplica',
        'Não se aplica',
        'Switch',
        'Não se aplica',
        NOW()
    ),
    (
        'Gateron Milky Yellow Pro (70x)',
        'Switch linear "budget" favorito da comunidade. Esta versão Pro vem pré-lubrificada de fábrica para máxima suavidade.',
        89.90,
        'https://i.imgur.com/oPWj1jV.png',
        'Não se aplica',
        'Não se aplica',
        'Switch',
        'Não se aplica',
        NOW()
    ),
    (
        'Keycap Set XDA "Matcha',
        'Set de keycaps PBT em perfil XDA uniforme, com tema verde Matcha. O perfil XDA é baixo e plano, ótimo para digitação.',
        209.90,
        'https://i.imgur.com/tscrnJA.png',
        'Não se aplica',
        'Não se aplica',
        'Keycap',
        'XDA',
        NOW()
    ),
    (
        'GMK Metropolis (Base Kit)',
        'Set de keycaps PBT em perfil Cherry, com tema ciberpunk azul e cinza. Um kit premium para builds temáticas.',
        850.00,
        'https://i.imgur.com/bJBLc4A.png',
        'Não se aplica',
        'Não se aplica',
        'Keycap',
        'Cherry',
        NOW()
    ),
    (
        'Akko PC75B Plus',
        'Teclado 75% com case de policarbonato e perfil SA. A combinação de hotswap e conectividade tripla o torna muito versátil.',
        599.00,
        'https://i.imgur.com/BQYNslR.png',
        '75%',
        'Wireless',
        'Teclado Mecânico',
        'SA',
        NOW()
    ),
    (
        'Logitech G Pro X TKL',
        'Teclado gamer TKL com switches hotswap (GX) e conectividade wireless Lightspeed. Projetado para performance em e-sports.',
        849.90,
        'https://i.imgur.com/4busRHA.png',
        'TKL (Tenkeyless)',
        'Wireless',
        'Teclado Mecânico',
        'OEM',
        NOW()
    ),
    (
        'Akko "Black & Pink" (SA)',
        'Set de keycaps PBT Doubleshot em perfil SA alto. O perfil SA é esculpido e alto, oferecendo um som grave e visual retrô.',
        279.90,
        'https://i.imgur.com/X94IJ5U.png',
        'Não se aplica',
        'Não se aplica',
        'Keycap',
        'SA',
        NOW()
    ),
    (
        'Razer Huntsman V3 Pro',
        'Teclado óptico para e-sports com switches analógicos Razer de 2ª geração. Oferece atuação ajustável e Modo de Disparo Rítido para uma resposta inigualável em jogos.',
        1399.90,
        'https://i.imgur.com/GKijw9R.png',
        'TKL (Tenkeyless)',
        'Com fio',
        'Teclado Mecânico',
        'Cherry',
        NOW()
    ),
    (
        'Durock T1 (70x)',
        'Switch tátil "smoky" (T1), famoso pelo seu bump tátil forte e arredondado. Oferece uma experiência tátil muito pronunciada.',
        189.90,
        'https://i.imgur.com/jDhU1w8.png',
        'Não se aplica',
        'Não se aplica',
        'Switch',
        'Não se aplica',
        NOW()
    ),
    (
        'Tai-Hao PBT "Miami" (OEM)',
        'Set de keycaps PBT doubleshot em perfil OEM. Traz as cores clássicas "Miami" (rosa e azul ciano) para o seu teclado.',
        199.90,
        'https://i.imgur.com/OdnAsIi.png',
        'Não se aplica',
        'Não se aplica',
        'Keycap',
        'OEM',
        NOW()
    ),
    (
        'Boba U4T (70x)',
        'Switch tátil "thocky" muito popular, com bump redondo e sem pré-travel. Projetado pela Gazzew para um som grave e feedback tátil.',
        219.90,
        'https://i.imgur.com/u9kZhIi.png',
        'Não se aplica',
        'Não se aplica',
        'Switch',
        'Não se aplica',
        NOW()
    ),
    (
        'Keychron Q1 Pro (Barebone)',
        'Versão Pro do 75% customizável, agora wireless e com case de alumínio. Suporta QMK/VIA para remapeamento completo das teclas.',
        1100.00,
        'https://i.imgur.com/KL01EM4.png',
        '75%',
        'Wireless',
        'Teclado Mecânico',
        'Não se aplica',
        NOW()
    ),
    (
        'Holy Panda (70x)',
        'Famoso switch tátil (remake), conhecido pelo seu "bump" tátil e som "thocky". Considerado um dos melhores táteis pela comunidade.',
        249.90,
        'https://i.imgur.com/foRZANL.png',
        'Não se aplica',
        'Não se aplica',
        'Switch',
        'Não se aplica',
        NOW()
    ),
    (
        'Ducky One 3 TKL',
        'Famoso TKL da Ducky com "Quack Mechanics" e PBT doubleshot. Oferece uma experiência de digitação superior com switches Cherry MX.',
        799.90,
        'https://i.imgur.com/AyREPDD.png',
        'TKL (Tenkeyless)',
        'Com fio',
        'Teclado Mecânico',
        'Cherry',
        NOW()
    ),
    (
        'Kailh Box White (70x)',
        'Switch clicky leve e agradável, usando uma click bar em vez do click jacket. Pacote com 70 unidades, resistente à poeira.',
        140.00,
        'https://i.imgur.com/PQ81RiF.png',
        'Não se aplica',
        'Não se aplica',
        'Switch',
        'Não se aplica',
        NOW()
    ),
    (
        'Epomaker TH80',
        'Teclado 75% com knob, gasket mount e keycaps XDA. É uma ótima opção de entrada para o mundo dos teclados "thocky".',
        509.90,
        'https://i.imgur.com/Z1r8eYM.png',
        '75%',
        'Wireless',
        'Teclado Mecânico',
        'XDA',
        NOW()
    ),
    (
        'Royal Kludge RK100',
        'Teclado 100% (layout 96%) compacto, tri-modo (BT, 2.4Ghz, Fio) e hotswap. Oferece funcionalidade full-size em um formato menor.',
        419.90,
        'https://i.imgur.com/yAf04Cy.png',
        '100% (Full-size)',
        'Wireless',
        'Teclado Mecânico',
        'OEM',
        NOW()
    ),
    (
        'Drop MT3 WoB',
        'Set de keycaps Black on White (WoB), em perfil MT3 alto e esculpido. Feito em PBT doubleshot, oferece um visual vintage.',
        550.00,
        'https://i.imgur.com/hwqAaaK.png',
        'Não se aplica',
        'Não se aplica',
        'Keycap',
        'SA',
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
        'XSA',
        NOW()
    ),
    (
        'Leopold FC900R',
        'Teclado full-size de alta qualidade, PBT doubleshot e construção robusta. Famoso pela sua digitação silenciosa e sólida.',
        750.00,
        'https://i.imgur.com/9Pw4tD2.png',
        '100% (Full-size)',
        'Com fio',
        'Teclado Mecânico',
        'OEM',
        NOW()
    ),
    (
        'Gateron Oil King (70x)',
        'Switches lineares premium, super suaves (smooth) de fábrica. Feitos com material Nylon, proporcionam um som "thocky" profundo.',
        209.90,
        'https://i.imgur.com/aoCzAEl.png',
        'Não se aplica',
        'Não se aplica',
        'Switch',
        'Não se aplica',
        NOW()
    ),
    (
        'Womier K66',
        'Teclado 65% com case em acrílico fosco e iluminação RGB underglow. Seu design foca em maximizar o brilho do RGB.',
        409.90,
        'https://i.imgur.com/JsY8xod.png',
        '65%',
        'Com fio',
        'Teclado Mecânico',
        'OEM',
        NOW()
    ),
    (
        'Keychron K8 Pro',
        'Versão TKL do QMK/VIA, agora wireless e com keycaps PBT. É uma ferramenta de produtividade robusta para usuários de Mac e Windows.',
        579.90,
        'https://i.imgur.com/Orrvbbm.png',
        'TKL (Tenkeyless)',
        'Wireless',
        'Teclado Mecânico',
        'OEM',
        NOW()
    ),
    (
        'YMDK PBT "Carbon" (OEM)',
        'Set de keycaps PBT em perfil OEM, com o popular tema Carbon (Laranja e Cinza). Compatível com a maioria dos layouts padrão.',
        189.90,
        'https://i.imgur.com/1Xwq0WC.png',
        'Não se aplica',
        'Não se aplica',
        'Keycap',
        'OEM',
        NOW()
    ),
    (
        'Cherry MX Brown (90x)',
        'O clássico switch tátil, leve e confiável. Pacote com 90 unidades, ideal para digitação e uso misto.',
        180.00,
        'https://i.imgur.com/HKVHoLv.png',
        'Não se aplica',
        'Não se aplica',
        'Switch',
        'Não se aplica',
        NOW()
    ),
    (
        'NPKC PBT DSA "Blank"',
        'Set de keycaps PBT em perfil DSA, totalmente brancas e sem legendas (blank). Ideal para um visual ultra minimalista.',
        150.00,
        'https://i.imgur.com/byG7Bi8.png',
        'Não se aplica',
        'Não se aplica',
        'Keycap',
        'DSA',
        NOW()
    ),
    (
        'GMK Olivia (Base Kit)',
        'Set de keycaps high-end em PBT de alta qualidade, perfil Cherry. O tema Oliva e Rosa é um dos mais procurados por entusiastas.',
        899.90,
        'https://i.imgur.com/5jXoJfw.png',
        'Não se aplica',
        'Não se aplica',
        'Keycap',
        'Cherry',
        NOW()
    ),
    (
        'Akko 5075S (Barebone)',
        'Kit 75% barebone com gasket mount, ideal para montar do zero. O case de policarbonato oferece um som mais profundo.',
        499.90,
        'https://i.imgur.com/Kf0Vawc.png',
        '75%',
        'Com fio',
        'Teclado Mecânico',
        'Não se aplica',
        NOW()
    ),
    (
        'HHKB Professional Hybrid',
        'Teclado Topre 60% com layout HHKB, famoso pela digitação "thocky". Esta versão Hybrid suporta Bluetooth e USB-C.',
        1499.90,
        'https://i.imgur.com/Yu153g3.png',
        '65%',
        'Wireless',
        'Teclado Mecânico',
        'Não se aplica',
        NOW()
    ),
    (
        'Keychron K14',
        'Teclado 70% que comprime um layout 65% com a fileira de F-keys. É hotswap e possui conectividade dupla (fio e BT).',
        529.90,
        'https://i.imgur.com/DRWHFAV.png',
        '65%',
        'Wireless',
        'Teclado Mecânico',
        'OEM',
        NOW()
    ),
    (
        'Glorious GMMK Pro',
        'Barebone 75% premium para customização total. Possui gasket mount e um knob rotativo de alumínio para controle de volume.',
        1199.90,
        'https://i.imgur.com/kL7jAms.png',
        '75%',
        'Com fio',
        'Teclado Mecânico',
        'Não se aplica',
        NOW()
    ),
    (
        'Cherry MX Red (90x)',
        'O clássico switch linear, rápido e leve, ideal para jogos. Pacote com 90 unidades, padrão de mercado.',
        170.00,
        'https://i.imgur.com/lYGqKUk.png',
        'Não se aplica',
        'Não se aplica',
        'Switch',
        'Não se aplica',
        NOW()
    ),
    (
        'NuPhy Halo75',
        'Teclado 75% com foco em design, som "thocky" e iluminação "halo" distintiva. Oferece uma experiência de digitação premium "out-of-the-box".',
        710.00,
        'https://i.imgur.com/7WL0vPh.png',
        '75%',
        'Wireless',
        'Teclado Mecânico',
        'Cherry',
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
        'DSA',
        NOW()
    ),
    (
        'PBT Keycaps "Chalk" (DSA)',
        'Set de keycaps PBT em perfil baixo e uniforme (DSA). O tema "Chalk" (giz) usa cores suaves e legendas minimalistas.',
        179.90,
        'https://i.imgur.com/qg4VHZT.png',
        'Não se aplica',
        'Não se aplica',
        'Keycap',
        'DSA',
        NOW()
    ) ON CONFLICT DO NOTHING;

-- ========================
-- POPULAÇÃO DE CART_PRODUCTS_TB
-- ========================
INSERT INTO
    cart_products_tb (product_id, name, price, image_url, created_at)
VALUES
    (
        1,
        'Mistel Barocco MD770',
        890.00,
        'https://i.imgur.com/Ln7eBeF.png',
        NOW()
    ),
    (
        2,
        'Ducky One 3 Full-size',
        899.90,
        'https://i.imgur.com/HekFCi9.png',
        NOW()
    ),
    (
        3,
        'Kailh Box Jade (70x)',
        149.90,
        'https://i.imgur.com/bBXNsPu.png',
        NOW()
    ),
    (
        4,
        'Keychron K3 Max',
        499.99,
        'https://i.imgur.com/1bBhl4O.png',
        NOW()
    ),
    (
        5,
        'HK Gaming "BoW" (Cherry)',
        159.90,
        'https://i.imgur.com/8ECHfuX.png',
        NOW()
    ),
    (
        6,
        'Ducky MIYA Pro',
        719.90,
        'https://i.imgur.com/6c4W6N7.png',
        NOW()
    ),
    (
        7,
        'Das Keyboard 4 Professional',
        900.00,
        'https://i.imgur.com/lENsQ9Q.png',
        NOW()
    ),
    (
        8,
        'Royal Kludge RK68',
        349.90,
        'https://i.imgur.com/rWLh3AK.png',
        NOW()
    ),
    (
        9,
        'Vortex Race 3',
        649.90,
        'https://i.imgur.com/2451ANN.png',
        NOW()
    ),
    (
        10,
        'AKKO 3068B Plus',
        389.00,
        'https://i.imgur.com/T00Aprh.png',
        NOW()
    ),
    (
        11,
        'Akko CS Jelly Pink (45x)',
        60.00,
        'https://i.imgur.com/yrzyQ6q.png',
        NOW()
    ),
    (
        12,
        'Gateron Milky Yellow Pro (70x)',
        89.90,
        'https://i.imgur.com/oPWj1jV.png',
        NOW()
    ),
    (
        13,
        'Keycap Set XDA "Matcha',
        209.90,
        'https://i.imgur.com/tscrnJA.png',
        NOW()
    ),
    (
        14,
        'GMK Metropolis (Base Kit)',
        850.00,
        'https://i.imgur.com/bJBLc4A.png',
        NOW()
    ),
    (
        15,
        'Akko PC75B Plus',
        599.00,
        'https://i.imgur.com/BQYNslR.png',
        NOW()
    ),
    (
        16,
        'Logitech G Pro X TKL',
        849.90,
        'https://i.imgur.com/4busRHA.png',
        NOW()
    ),
    (
        17,
        'Akko "Black & Pink" (SA)',
        279.90,
        'https://i.imgur.com/X94IJ5U.png',
        NOW()
    ),
    (
        18,
        'Razer Huntsman V3 Pro',
        1399.90,
        'https://i.imgur.com/GKijw9R.png',
        NOW()
    ),
    (
        19,
        'Durock T1 (70x)',
        189.90,
        'https://i.imgur.com/jDhU1w8.png',
        NOW()
    ),
    (
        20,
        'Tai-Hao PBT "Miami" (OEM)',
        199.90,
        'https://i.imgur.com/OdnAsIi.png',
        NOW()
    ),
    (
        21,
        'Boba U4T (70x)',
        219.90,
        'https://i.imgur.com/u9kZhIi.png',
        NOW()
    ),
    (
        22,
        'Keychron Q1 Pro (Barebone)',
        1100.00,
        'https://i.imgur.com/KL01EM4.png',
        NOW()
    ),
    (
        23,
        'Holy Panda (70x)',
        249.90,
        'https://i.imgur.com/foRZANL.png',
        NOW()
    ),
    (
        24,
        'Ducky One 3 TKL',
        799.90,
        'https://i.imgur.com/AyREPDD.png',
        NOW()
    ),
    (
        25,
        'Kailh Box White (70x)',
        140.00,
        'https://i.imgur.com/PQ81RiF.png',
        NOW()
    ),
    (
        26,
        'Epomaker TH80',
        509.90,
        'https://i.imgur.com/Z1r8eYM.png',
        NOW()
    ),
    (
        27,
        'Royal Kludge RK100',
        419.90,
        'https://i.imgur.com/yAf04Cy.png',
        NOW()
    ),
    (
        28,
        'Drop MT3 WoB',
        550.00,
        'https://i.imgur.com/hwqAaaK.png',
        NOW()
    ),
    (
        29,
        'NuPhy Air75 V2',
        720.00,
        'https://i.imgur.com/acOz7HN.png',
        NOW()
    ),
    (
        30,
        'Leopold FC900R',
        750.00,
        'https://i.imgur.com/9Pw4tD2.png',
        NOW()
    ),
    (
        31,
        'Gateron Oil King (70x)',
        209.90,
        'https://i.imgur.com/aoCzAEl.png',
        NOW()
    ),
    (
        32,
        'Womier K66',
        409.90,
        'https://i.imgur.com/JsY8xod.png',
        NOW()
    ),
    (
        33,
        'Keychron K8 Pro',
        579.90,
        'https://i.imgur.com/Orrvbbm.png',
        NOW()
    ),
    (
        34,
        'YMDK PBT "Carbon" (OEM)',
        189.90,
        'https://i.imgur.com/1Xwq0WC.png',
        NOW()
    ),
    (
        35,
        'Cherry MX Brown (90x)',
        180.00,
        'https://i.imgur.com/HKVHoLv.png',
        NOW()
    ),
    (
        36,
        'NPKC PBT DSA "Blank"',
        150.00,
        'https://i.imgur.com/byG7Bi8.png',
        NOW()
    ),
    (
        37,
        'GMK Olivia (Base Kit)',
        899.90,
        'https://i.imgur.com/5jXoJfw.png',
        NOW()
    ),
    (
        38,
        'Akko 5075S (Barebone)',
        499.90,
        'https://i.imgur.com/Kf0Vawc.png',
        NOW()
    ),
    (
        39,
        'HHKB Professional Hybrid',
        1499.90,
        'https://i.imgur.com/Yu153g3.png',
        NOW()
    ),
    (
        40,
        'Keychron K14',
        529.90,
        'https://i.imgur.com/DRWHFAV.png',
        NOW()
    ),
    (
        41,
        'Glorious GMMK Pro',
        1199.90,
        'https://i.imgur.com/kL7jAms.png',
        NOW()
    ),
    (
        42,
        'Cherry MX Red (90x)',
        170.00,
        'https://i.imgur.com/lYGqKUk.png',
        NOW()
    ),
    (
        43,
        'NuPhy Halo75',
        710.00,
        'https://i.imgur.com/7WL0vPh.png',
        NOW()
    ),
    (
        44,
        'Logitech MX Keys S',
        649.90,
        'https://i.imgur.com/p0pbkXG.png',
        NOW()
    ),
    (
        45,
        'PBT Keycaps "Chalk" (DSA)',
        179.90,
        'https://i.imgur.com/qg4VHZT.png',
        NOW()
    ) ON CONFLICT (product_id) DO NOTHING;
    
-- ========================
-- POPULAÇÃO DE ORDER_PRODUCTS_TB
-- ========================
INSERT INTO
    order_products_tb (product_id, name, price, image_url, created_at)
VALUES
    (
        1,
        'Mistel Barocco MD770',
        890.00,
        'https://i.imgur.com/Ln7eBeF.png',
        NOW()
    ),
    (
        2,
        'Ducky One 3 Full-size',
        899.90,
        'https://i.imgur.com/HekFCi9.png',
        NOW()
    ),
    (
        3,
        'Kailh Box Jade (70x)',
        149.90,
        'https://i.imgur.com/bBXNsPu.png',
        NOW()
    ),
    (
        4,
        'Keychron K3 Max',
        499.99,
        'https://i.imgur.com/1bBhl4O.png',
        NOW()
    ),
    (
        5,
        'HK Gaming "BoW" (Cherry)',
        159.90,
        'https://i.imgur.com/8ECHfuX.png',
        NOW()
    ),
    (
        6,
        'Ducky MIYA Pro',
        719.90,
        'https://i.imgur.com/6c4W6N7.png',
        NOW()
    ),
    (
        7,
        'Das Keyboard 4 Professional',
        900.00,
        'https://i.imgur.com/lENsQ9Q.png',
        NOW()
    ),
    (
        8,
        'Royal Kludge RK68',
        349.90,
        'https://i.imgur.com/rWLh3AK.png',
        NOW()
    ),
    (
        9,
        'Vortex Race 3',
        649.90,
        'https://i.imgur.com/2451ANN.png',
        NOW()
    ),
    (
        10,
        'AKKO 3068B Plus',
        389.00,
        'https://i.imgur.com/T00Aprh.png',
        NOW()
    ),
    (
        11,
        'Akko CS Jelly Pink (45x)',
        60.00,
        'https://i.imgur.com/yrzyQ6q.png',
        NOW()
    ),
    (
        12,
        'Gateron Milky Yellow Pro (70x)',
        89.90,
        'https://i.imgur.com/oPWj1jV.png',
        NOW()
    ),
    (
        13,
        'Keycap Set XDA "Matcha',
        209.90,
        'https://i.imgur.com/tscrnJA.png',
        NOW()
    ),
    (
        14,
        'GMK Metropolis (Base Kit)',
        850.00,
        'https://i.imgur.com/bJBLc4A.png',
        NOW()
    ),
    (
        15,
        'Akko PC75B Plus',
        599.00,
        'https://i.imgur.com/BQYNslR.png',
        NOW()
    ),
    (
        16,
        'Logitech G Pro X TKL',
        849.90,
        'https://i.imgur.com/4busRHA.png',
        NOW()
    ),
    (
        17,
        'Akko "Black & Pink" (SA)',
        279.90,
        'https://i.imgur.com/X94IJ5U.png',
        NOW()
    ),
    (
        18,
        'Razer Huntsman V3 Pro',
        1399.90,
        'https://i.imgur.com/GKijw9R.png',
        NOW()
    ),
    (
        19,
        'Durock T1 (70x)',
        189.90,
        'https://i.imgur.com/jDhU1w8.png',
        NOW()
    ),
    (
        20,
        'Tai-Hao PBT "Miami" (OEM)',
        199.90,
        'https://i.imgur.com/OdnAsIi.png',
        NOW()
    ),
    (
        21,
        'Boba U4T (70x)',
        219.90,
        'https://i.imgur.com/u9kZhIi.png',
        NOW()
    ),
    (
        22,
        'Keychron Q1 Pro (Barebone)',
        1100.00,
        'https://i.imgur.com/KL01EM4.png',
        NOW()
    ),
    (
        23,
        'Holy Panda (70x)',
        249.90,
        'https://i.imgur.com/foRZANL.png',
        NOW()
    ),
    (
        24,
        'Ducky One 3 TKL',
        799.90,
        'https://i.imgur.com/AyREPDD.png',
        NOW()
    ),
    (
        25,
        'Kailh Box White (70x)',
        140.00,
        'https://i.imgur.com/PQ81RiF.png',
        NOW()
    ),
    (
        26,
        'Epomaker TH80',
        509.90,
        'https://i.imgur.com/Z1r8eYM.png',
        NOW()
    ),
    (
        27,
        'Royal Kludge RK100',
        419.90,
        'https://i.imgur.com/yAf04Cy.png',
        NOW()
    ),
    (
        28,
        'Drop MT3 WoB',
        550.00,
        'https://i.imgur.com/hwqAaaK.png',
        NOW()
    ),
    (
        29,
        'NuPhy Air75 V2',
        720.00,
        'https://i.imgur.com/acOz7HN.png',
        NOW()
    ),
    (
        30,
        'Leopold FC900R',
        750.00,
        'https://i.imgur.com/9Pw4tD2.png',
        NOW()
    ),
    (
        31,
        'Gateron Oil King (70x)',
        209.90,
        'https://i.imgur.com/aoCzAEl.png',
        NOW()
    ),
    (
        32,
        'Womier K66',
        409.90,
        'https://i.imgur.com/JsY8xod.png',
        NOW()
    ),
    (
        33,
        'Keychron K8 Pro',
        579.90,
        'https://i.imgur.com/Orrvbbm.png',
        NOW()
    ),
    (
        34,
        'YMDK PBT "Carbon" (OEM)',
        189.90,
        'https://i.imgur.com/1Xwq0WC.png',
        NOW()
    ),
    (
        35,
        'Cherry MX Brown (90x)',
        180.00,
        'https://i.imgur.com/HKVHoLv.png',
        NOW()
    ),
    (
        36,
        'NPKC PBT DSA "Blank"',
        150.00,
        'https://i.imgur.com/byG7Bi8.png',
        NOW()
    ),
    (
        37,
        'GMK Olivia (Base Kit)',
        899.90,
        'https://i.imgur.com/5jXoJfw.png',
        NOW()
    ),
    (
        38,
        'Akko 5075S (Barebone)',
        499.90,
        'https://i.imgur.com/Kf0Vawc.png',
        NOW()
    ),
    (
        39,
        'HHKB Professional Hybrid',
        1499.90,
        'https://i.imgur.com/Yu153g3.png',
        NOW()
    ),
    (
        40,
        'Keychron K14',
        529.90,
        'https://i.imgur.com/DRWHFAV.png',
        NOW()
    ),
    (
        41,
        'Glorious GMMK Pro',
        1199.90,
        'https://i.imgur.com/kL7jAms.png',
        NOW()
    ),
    (
        42,
        'Cherry MX Red (90x)',
        170.00,
        'https://i.imgur.com/lYGqKUk.png',
        NOW()
    ),
    (
        43,
        'NuPhy Halo75',
        710.00,
        'https://i.imgur.com/7WL0vPh.png',
        NOW()
    ),
    (
        44,
        'Logitech MX Keys S',
        649.90,
        'https://i.imgur.com/p0pbkXG.png',
        NOW()
    ),
    (
        45,
        'PBT Keycaps "Chalk" (DSA)',
        179.90,
        'https://i.imgur.com/qg4VHZT.png',
        NOW()
    )
ON CONFLICT (product_id) DO NOTHING;