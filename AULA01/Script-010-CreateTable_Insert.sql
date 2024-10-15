create table tb_pessoas(
id serial primary key,
nome varchar(50) not null,
email varchar(100) not null unique,
fone varchar(15)
);

--- CREATE SEQUENCE mysequence INCREMENT 1 START 100;

/*
SELECT * 
  FROM pg_sequences
 WHERE schemaname = 'public'
   AND sequencename = 'tb_pessoas_id_seq';
   
SELECT sequence_schema, sequence_name
  FROM information_schema.sequences 
 ORDER BY sequence_name

*/

--- https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-sequences/

--- https://matam-kirankumar.medium.com/updating-postgresql-sequences-to-max-id-870fcb0829c3


--- 

SELECT nextval('tb_pessoas_id_seq');

--- unique -- cpf -- cnpj


ALTER SEQUENCE tb_pessoas_id_seq RESTART WITH 1;

DELETE FROM tb_pessoas;

select * from tb_pessoas;

INSERT INTO 
    tb_pessoas(nome, email, fone)
VALUES
    ('Maria','maria@gmail.com','(47)9898-7878'),
    ('Rose','rose@gmail.com',''),
    ('Luiz','teste@teste.com',null),
    ('Andre','andre@gmail.com','(47)9898-7878'),
    ('Antonio','antonio@gmail.com',''),
    ('Marcelo','marcelo@teste.com',null);


-------------------------

create table tb_estoque(
id serial primary key,
descricao varchar(50) not null,
preco numeric(12,2) not null,
estoque numeric(12,3) not null
);

select * from tb_estoque;

select e.*, (e.estoque*e.preco)  as saldo_estoque
  from tb_estoque e;

INSERT INTO 
    tb_estoque(descricao, preco, estoque)
VALUES
    ('Banana', 5.7, 100),
    ('Maça', 8.7, 100),
    ('Pera', 10.35, 100),
    ('Abacaxi', 7.5, 100),
    ('Batata', 4.58, 100),
    ('Rabanete', 6.87, 100);