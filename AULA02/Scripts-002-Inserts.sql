INSERT INTO tb_categorias (nome, descricao, ativo) VALUES
('Literatura Clássica', 'Obras literárias reconhecidas pela crítica.', 'S'),
('Ficção Científica', 'Histórias que exploram conceitos científicos e futuristas.', 'S'),
('Romance Policial', 'Livros que envolvem mistérios e investigações.', 'S'),
('Fantasia Épica', 'Narrativas de fantasia com mundos complexos.', 'S'),
('Biografias Inspiradoras', 'Relatos de vidas que mudaram a história.', 'S'),
('História do Brasil', 'Livros sobre eventos históricos do Brasil.', 'S'),
('Desenvolvimento Pessoal', 'Literatura voltada para o crescimento pessoal.', 'S'),
('Aventura e Exploração', 'Livros que levam o leitor a aventuras emocionantes.', 'S'),
('Terror e Suspense', 'Histórias que provocam medo e tensão.', 'S'),
('Poesia Contemporânea', 'Poemas de autores modernos e suas expressões.', 'S');

INSERT INTO tb_editoras (nome, ativo) VALUES
('Editora Aurora', 'S'),
('Editora Estrela', 'S'),
('Editora Sorriso', 'S'),
('Editora Horizonte', 'S'),
('Editora Página', 'S'),
('Editora Sabedoria', 'S'),
('Editora Maré', 'S'),
('Editora Raízes', 'S'),
('Editora Coração', 'S'),
('Editora Inspiração', 'S');

INSERT INTO tb_autores (nome, ativo) VALUES
('Isabel Allende', 'S'),
('J.K. Rowling', 'S'),
('Gabriel Garcia Márquez', 'S'),
('Stephen King', 'S'),
('Maya Angelou', 'S'),
('Haruki Murakami', 'S'),
('George R.R. Martin', 'S'),
('Agatha Christie', 'S'),
('Paulo Coelho', 'S'),
('Chimamanda Ngozi Adichie', 'S');

INSERT INTO tb_livros (ano, titulo, isbn, ativo, idCategoria, idEditora) VALUES
(2021, 'Cem Anos de Solidão', '978-0-06-088328-7', 'S', 5, 3),
(2020, 'Harry Potter e a Pedra Filosofal', '978-85-390-0023-6', 'S', 3, 1),
(2019, 'O Senhor dos Anéis', '978-85-390-0167-0', 'S', 4, 2),
(2018, 'A Morte e a Morte de Quincas Berro d’Água', '978-85-7500-181-8', 'S', 1, 5),
(2022, 'A Revolução dos Bichos', '978-85-356-0167-5', 'S', 2, 6),
(2021, 'Orgulho e Preconceito', '978-85-7657-007-6', 'S', 1, 4),
(2020, 'O Hobbit', '978-85-391-0089-3', 'S', 4, 1),
(2019, 'O Morro dos Ventos Uivantes', '978-85-7685-079-3', 'S', 1, 2),
(2018, 'O Conto da Aia', '978-85-7657-020-5', 'S', 2, 5),
(2022, 'A Sutil Arte de Ligar o F*da-se', '978-85-422-0198-4', 'S', 7, 3);

INSERT INTO tb_livrosautores (idAutor, idLivro) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10),
(1, 2),
(2, 3),
(3, 4),
(4, 5),
(5, 6),
(6, 7),
(7, 8),
(8, 9),
(9, 10),
(10, 1);