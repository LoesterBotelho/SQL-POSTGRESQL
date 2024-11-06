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
	end if;

	exception
		when others then
			raise notice 'Executando rollback.';
END;
$$;

CREATE OR REPLACE PROCEDURE buscaConta(p_id_conta INT)
LANGUAGE plpgsql
AS $$
BEGIN
    PERFORM * FROM conta_bancaria WHERE id_conta = p_id_conta;
    
    IF NOT FOUND THEN
        RAISE NOTICE 'Conta não encontrada para o id: %', p_id_conta;
    ELSE
        PERFORM * FROM conta_bancaria WHERE id_conta = p_id_conta;
    END IF;
END;
$$;

CREATE OR REPLACE PROCEDURE buscaConta(p_id_conta INT)
LANGUAGE plpgsql
AS $$
BEGIN

    PERFORM * FROM conta_bancaria WHERE id_conta = p_id_conta;
    
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Conta não encontrada para o id: %', p_id_conta;
    ELSE
        PERFORM * FROM conta_bancaria WHERE id_conta = p_id_conta;
		RAISE NOTICE 'Conta encontrada para o id: %', p_id_conta;
    END IF;
END;
$$;

CREATE OR REPLACE FUNCTION buscaSaldo(p_id_conta INT)
RETURNS NUMERIC(10,2) LANGUAGE plpgsql
AS $$
DECLARE
    v_saldo NUMERIC(10,2);
BEGIN
    SELECT saldo INTO v_saldo FROM conta_bancaria WHERE id_conta = p_id_conta;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Conta não encontrada para o id: %', p_id_conta;
    ELSE
        RAISE NOTICE 'O saldo da conta % é: %', p_id_conta, v_saldo;
    END IF;

	RETURN v_saldo;
END;
$$;


CREATE OR REPLACE PROCEDURE alterarSaldo(p_id_conta INT, p_valor NUMERIC, p_operacao CHAR)
LANGUAGE plpgsql
AS $$
DECLARE 
	varsaldo numeric(12,2);
BEGIN

    IF p_operacao = 'D' THEN

		SELECT buscaSaldo(p_id_conta) INTO varsaldo;

		IF varsaldo < p_valor THEN
			RAISE EXCEPTION 'Saldo Insuficiente';
		END IF;


        UPDATE conta_bancaria
        SET saldo = saldo - p_valor
        WHERE id_conta = p_id_conta;
    ELSIF p_operacao = 'C' THEN
        UPDATE conta_bancaria
        SET saldo = saldo + p_valor
        WHERE id_conta = p_id_conta;
    ELSE
        RAISE EXCEPTION 'Operação inválida. Use ''D'' para débito ou ''C'' para crédito.';
    END IF;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Conta não encontrada para o id: %', p_id_conta;
    ELSE
        RAISE NOTICE 'Saldo da conta % atualizado com sucesso.', p_id_conta;
    END IF;
END;
$$;

CREATE OR REPLACE PROCEDURE inserirTransacao(
    p_id_conta_origem INT,
    p_id_conta_destino INT,
    p_valor NUMERIC
)
LANGUAGE plpgsql
AS $$
BEGIN

    INSERT INTO transacao (id_conta_origem, id_conta_destino, valor, data_transacao)
    VALUES (p_id_conta_origem, p_id_conta_destino, p_valor, CURRENT_TIMESTAMP);

    UPDATE conta_bancaria
    SET saldo = saldo - p_valor
    WHERE id_conta = p_id_conta_origem;

    UPDATE conta_bancaria
    SET saldo = saldo + p_valor
    WHERE id_conta = p_id_conta_destino;
    
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Uma das contas não foi encontrada.';
    ELSE
        RAISE NOTICE 'Transação inserida e saldos atualizados com sucesso.';
    END IF;
END;
$$;

CREATE OR REPLACE PROCEDURE transacao_bancaria
(p_id_conta_origem int, p_id_conta_destino int, valor decimal(10,2))
LANGUAGE plpgsql
AS $$
DECLARE
	
BEGIN

	call buscaConta(p_id_conta_origem);
	call buscaConta(p_id_conta_destino);

	call alterarSaldo(p_id_conta_origem, valor, 'D');
	call alterarSaldo(p_id_conta_destino, valor, 'C');

	call inserirTransacao(p_id_conta_origem, p_id_conta_destino, valor);
	
	raise notice 'Transação concluída com sucesso.';

	exception
		when others then
			raise notice 'Executando rollback. ERRO : %', SQLERRM;

END;
$$;

call transacao_bancaria(1, 2, 5000);

call transacao_bancaria(1, 2, 500);




select * from conta_bancaria;
select * from transacao;
