CREATE TABLE tb_livros (
    id serial PRIMARY KEY,
    ano integer,
    titulo varchar(200),
    isbn varchar(30),
    ativo varchar(1),
    idCategoria integer,
    idEditora integer
);

CREATE TABLE tb_categorias (
    id serial PRIMARY KEY,
    nome varchar(100),
    descricao varchar(300),
    ativo varchar(1)
);

CREATE TABLE tb_autores (
    id serial PRIMARY KEY,
    nome varchar(100),
    ativo varchar(1)
);

CREATE TABLE tb_editoras (
    id serial PRIMARY KEY,
    nome varchar(100),
    ativo varchar(1)
);

CREATE TABLE tb_livrosautores (
    idAutor integer,
    idLivro integer
);
 
ALTER TABLE tb_livros ADD CONSTRAINT fk_livros_categorias
    FOREIGN KEY (idCategoria)
    REFERENCES tb_categorias (id)
    ON DELETE RESTRICT;
 
ALTER TABLE tb_livros ADD CONSTRAINT fk_livros_editoras
    FOREIGN KEY (idEditora)
    REFERENCES tb_editoras (id)
    ON DELETE RESTRICT;
 
ALTER TABLE tb_livrosautores ADD CONSTRAINT fk_livrosautores_autores
    FOREIGN KEY (idAutor)
    REFERENCES tb_autores (id)
    ON DELETE RESTRICT;
 
ALTER TABLE tb_livrosautores ADD CONSTRAINT fk_livrosautores_livros
    FOREIGN KEY (idLivro)
    REFERENCES tb_livros (id)
    ON DELETE SET NULL;