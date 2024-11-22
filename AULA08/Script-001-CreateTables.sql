--- SCHEMA
--- GRUPO USUÁRIO

create table tb_clientes(
	id serial primary key,
	nome varchar(100)
);

create table tb_financeiro(
    id serial primary key,
    nome varchar(100),
    valor decimal(12,2)
);

create table tb_relatorios(
    id serial primary key,
    nome varchar(100)
);

create table tb_inventario(
    id serial primary key,
    nome varchar(100)
);

INSERT INTO tb_clientes(nome) VALUES ('Maria');
INSERT INTO tb_clientes(nome) VALUES ('João');
