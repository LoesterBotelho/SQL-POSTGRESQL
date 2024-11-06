CREATE TABLE usuarios (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL
);

create table tb_produto(
	id_produto serial,
	nome varchar,
	quantidade int,
	primary key (id_produto)
);

create table tb_pedido(
	id_pedido serial,
	id_produto int,
	quantidade int,
	data_pedido timestamp,
	primary key (id_pedido),
	foreign key (id_produto) references tb_produto(id_produto)
);


create table conta_bancaria(
	id_conta serial,
	nome_titular varchar,
	saldo numeric(10,2),
	primary key (id_conta)
);


create table transacao(
	id_transacao serial,
	id_conta_origem int,
	id_conta_destino int,
	valor numeric(10,2),
	data_transacao timestamp,
	primary key (id_transacao),
	foreign key (id_conta_origem) references conta_bancaria(id_conta),
	foreign key (id_conta_destino) references conta_bancaria(id_conta)
);

