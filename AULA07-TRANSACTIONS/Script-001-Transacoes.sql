
CREATE TABLE usuarios (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL
);

select * from usuarios;

-- Exercício 1 --

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



insert into tb_produto(nome, quantidade) values
('Batata', 20), ('Café', 50), ('Vassoura', 10), ('Sabonete', 100);



CREATE OR REPLACE PROCEDURE transacao(p_id_produto int, p_quantidade int)
LANGUAGE plpgsql
AS $$
DECLARE
	quantidadeEstoque int;
BEGIN
	select quantidade into quantidadeEstoque
	from tb_produto where id_produto = p_id_produto;

	if not found then
		raise exception 'O produto de id: % não existe.', p_id_produto;
	end if;
		
	if (p_quantidade > quantidadeEstoque) then
		raise exception 'Quantidade solicitada não disponível.';
	else

		update tb_produto set quantidade = (quantidade - p_quantidade)
		where id_produto = p_id_produto;
		
		raise notice 'Quantidade de produtos atualizada.';

		insert into tb_pedido(id_produto, quantidade, data_pedido)
		values (p_id_produto, p_quantidade, NOW()::timestamp);

		raise notice 'Pedido criado com sucesso.';
		
		-- COMMIT;
	end if;

	exception
		when others then
			raise notice 'Executando rollback.';
			-- ROLLBACK;
END;
$$;




call transacao(4, 10);

select * from tb_produto;
select * from tb_pedido;



-- Exercício 2 --


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




insert into conta_bancaria(nome_titular, saldo) values
('Felipe', 300), ('Jorge', 550.75), ('Marina', 1202.25);




CREATE OR REPLACE PROCEDURE transacao_bancaria
(p_id_conta_origem int, p_id_conta_destino int, valor decimal(10,2))
LANGUAGE plpgsql
AS $$
DECLARE
	qtd_origem decimal(10, 2);
BEGIN
	select saldo into qtd_origem
	from conta_bancaria where id_conta = p_id_conta_origem;

	if not found then
		raise exception 'A conta de id: % não existe.', p_id_conta_origem;
	end if;

	if not exists(select 1 from conta_bancaria where id_conta = p_id_conta_destino) then
		raise exception 'A conta de id: % não existe.', p_id_conta_destino;
	end if;

	if (qtd_origem < valor) then
		raise exception 'Saldo insuficiente para realizar transação.';
	else

		update conta_bancaria set saldo = saldo - valor
		where id_conta = p_id_conta_origem;

		update conta_bancaria set saldo = saldo + valor
		where id_conta = p_id_conta_destino;

		insert into transacao(id_conta_origem, id_conta_destino, valor, data_transacao)
		values (p_id_conta_origem, p_id_conta_destino, valor, NOW());
		
		-- COMMIT;	

		raise notice 'Transação concluída com sucesso.';
	end if;

	exception
		when others then
			raise notice 'Executando rollback.';
			-- ROLLBACK;
END;
$$;





call transacao_bancaria(3, 1, 1);




select * from conta_bancaria;
select * from transacao;
