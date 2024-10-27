/*
CREATE DATABASE "dbDesafioLoester"
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LOCALE_PROVIDER = 'libc'
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;
*/

--- DROP TABLE
/*
drop table tb_pedidositens;
drop table tb_pedidos;
drop table tb_produtos;
drop table tb_clientes;
drop table tb_categorias;
*/

--- CREATE TABLE

CREATE TABLE tb_categorias (
    idcategoria serial PRIMARY KEY,
    nome varchar(100)
);

CREATE TABLE tb_clientes (
    idcliente serial PRIMARY KEY,
    nome VARCHAR(40)
);

CREATE TABLE tb_produtos (
    idproduto serial PRIMARY KEY,
    idcategoria integer null,
    descricao varchar(80),
    valor numeric(12,2),
    qtd_estoque numeric(12, 3) NOT NULL
);

CREATE TABLE tb_log_produtos (
    idproduto integer not null,
    datacriacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    historico varchar(100)
);

CREATE TABLE tb_pedidos (
    idpedido serial PRIMARY KEY,
    data DATE,
    idcliente serial,
    status VARCHAR(1) NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'F' , 'C')), --- ABERTO --- FECHADO --- CANCELADO
    pagamento VARCHAR(1) NOT NULL DEFAULT 'A' CHECK (pagamento IN ('A', 'P')), --- AVISTA --- PARCELADO
    qtd_parcelas integer
);

CREATE TABLE tb_pedidos_parcelas(
idpedido integer not null,
numero_parcela varchar(10),
numero_parcela_de varchar(10),
dataparcela TIMESTAMP,
valorparcela decimal(10,2)
);

CREATE TABLE tb_pedidositens (
    idpedido int,
    idproduto int,
    quantidade numeric(12,2),
    valorunitario numeric(12,2)
);

CREATE TABLE TB_CONTAS(
ID SERIAL PRIMARY KEY,
NUMERO VARCHAR(20),
SALDO DECIMAL
);

CREATE TABLE TB_LOG_CONTAS(
ID SERIAL PRIMARY KEY,
NUMERO VARCHAR(20),
VALOR DECIMAL,
DESCRICAO VARCHAR(100)
);

--- FK

ALTER TABLE tb_pedidos ADD CONSTRAINT FK_tb_pedidos
    FOREIGN KEY (idcliente)
    REFERENCES tb_clientes (idcliente);

ALTER TABLE tb_pedidositens ADD CONSTRAINT FK_tb_pedido
    FOREIGN KEY (idpedido)
    REFERENCES tb_pedidos (idpedido);
	
ALTER TABLE tb_pedidositens ADD CONSTRAINT FK_tb_produto
    FOREIGN KEY (idproduto)
    REFERENCES tb_produtos (idproduto);

ALTER TABLE tb_produtos ADD CONSTRAINT FK_tb_categoria
    FOREIGN KEY (idcategoria)
    REFERENCES tb_categorias (idcategoria);


--- FUNCTIONS

CREATE OR REPLACE FUNCTION verificar_saldo_minimo()
RETURNS TRIGGER AS $$
BEGIN

	IF NEW.SALDO < 0 THEN
	RAISE EXCEPTION 'O saldo não pode ser negativo.';
	END IF;
	
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION log_insercao_conta()
RETURNS TRIGGER AS $$
BEGIN

	INSERT INTO TB_LOG_CONTAS (NUMERO,VALOR,DESCRICAO) 
	VALUES 
	(new.NUMERO, new.SALDO , FORMAT('SALDO ANTERIOR : %s, SALDO ATUAL : %s', old.SALDO,new.SALDO ) );
	
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION log_insercao_produto()
RETURNS TRIGGER AS $$
DECLARE
    mensagem_formatada varchar(100) := ''; 
BEGIN

 --- RAISE NOTICE ' A = %  B = % ', OLD.valor ,NEW.valor;

    IF ( (OLD.valor IS NULL) and (NEW.valor >= 0) ) THEN
        mensagem_formatada := mensagem_formatada || FORMAT('INSERT - PREÇO NEW: %s. ', NEW.valor);
    END IF;

    IF ( (OLD.qtd_estoque IS NULL) and (NEW.qtd_estoque >= 0) ) THEN
        mensagem_formatada := mensagem_formatada || FORMAT('INSERT - QTDE NEW: %s. ', NEW.qtd_estoque);
    END IF;

    IF OLD.valor <> NEW.valor THEN
        mensagem_formatada := mensagem_formatada || FORMAT('UPDATE - PREÇO DIFF: OLD: %s, NEW: %s. ', OLD.valor, NEW.valor);
    END IF;
    
    IF OLD.qtd_estoque <> NEW.qtd_estoque THEN
        mensagem_formatada := mensagem_formatada || FORMAT('UPDATE - QTDE DIFF: OLD: %s, NEW: %s. ', OLD.qtd_estoque, NEW.qtd_estoque);
    END IF;

    INSERT INTO tb_log_produtos (idproduto, datacriacao, historico) 
    VALUES (NEW.idproduto, CURRENT_TIMESTAMP, mensagem_formatada);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION verificar_pedido_fechado()
RETURNS TRIGGER AS $$
DECLARE
    pedidoitem RECORD;     
    i INTEGER;
    total_venda decimal(12,2) := 0;    
    valor_parcela decimal(12,2) := 0;
    data_parcela DATE := CURRENT_DATE;
BEGIN

	IF NEW.status in ('F') THEN
        FOR pedidoitem IN
            SELECT * FROM tb_pedidositens pi WHERE pi.idpedido = new.idpedido
        LOOP
            RAISE NOTICE 'IDPRODUTO: %, QUANTIDADE: %', pedidoitem.idproduto, pedidoitem.quantidade;
            UPDATE tb_produtos SET qtd_estoque = qtd_estoque - pedidoitem.quantidade where idproduto = pedidoitem.idproduto;
        END LOOP;
	END IF;

    IF new.pagamento in ('P') THEN

        select sum(i.quantidade * i.valorunitario) as total_venda into total_venda
          from tb_pedidositens i
         where i.idpedido = new.idpedido;

        valor_parcela = (total_venda/new.qtd_parcelas);     
	
        RAISE NOTICE 'O valor total é: %', total_venda;
        RAISE NOTICE 'O valor da parcela é: %', valor_parcela;       

        FOR i IN 1..new.qtd_parcelas LOOP
            RAISE NOTICE 'Processando parcela número %', i;

            data_parcela = ( data_parcela + (i * INTERVAL '30 days') );

            RAISE NOTICE 'parcela número % : %', i, data_parcela;  
            
            insert into tb_pedidos_parcelas (idpedido,numero_parcela,numero_parcela_de,dataparcela,valorparcela) 
            values (new.idpedido, i , new.qtd_parcelas, data_parcela, valor_parcela );

        END LOOP;
    END IF;
	
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION verificar_pedido_fechado_itens()
RETURNS TRIGGER AS $$
DECLARE
    pedido RECORD; 
BEGIN
        FOR pedido IN
            SELECT * FROM tb_pedidos p WHERE p.idpedido = new.idpedido
        LOOP
            IF pedido.status in ('F') THEN
                RAISE EXCEPTION 'VENDA FECHADA NÃO PODE SER INCLUIDO NOVOS ITENS.';
            END IF;
        END LOOP;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

--- TRIGGERS

CREATE TRIGGER trigger_verificar_pedido_fechado_itens
BEFORE INSERT OR UPDATE ON tb_pedidositens
FOR EACH ROW
EXECUTE FUNCTION verificar_pedido_fechado_itens();

CREATE TRIGGER trigger_pedido_fechado
BEFORE INSERT OR UPDATE ON tb_pedidos
FOR EACH ROW
EXECUTE FUNCTION verificar_pedido_fechado();

CREATE TRIGGER trigger_log_produto
BEFORE INSERT OR UPDATE ON tb_produtos
FOR EACH ROW
EXECUTE FUNCTION log_insercao_produto();

CREATE TRIGGER trigger_verificar_saldo
BEFORE INSERT OR UPDATE ON TB_CONTAS
FOR EACH ROW
EXECUTE FUNCTION verificar_saldo_minimo();

CREATE TRIGGER trigger_log_insercao
AFTER INSERT OR UPDATE ON TB_CONTAS
FOR EACH ROW
EXECUTE FUNCTION log_insercao_conta();


--- procedures 

CREATE OR REPLACE PROCEDURE inserir_produto(
    p_descricao VARCHAR,
    p_valor NUMERIC,
    p_idcategoria INTEGER,
    p_qtd_estoque NUMERIC
)
LANGUAGE plpgsql
AS $$
BEGIN

    IF p_idcategoria IS NULL OR p_idcategoria = 0 THEN
        RAISE EXCEPTION 'A categoria não pode ser nula ou 0';
    END IF;

    INSERT INTO tb_produtos (idcategoria, descricao, valor, qtd_estoque)
    VALUES (p_idcategoria, p_descricao, p_valor, p_qtd_estoque);

    RAISE NOTICE 'Produto inserido com sucesso';
END;
$$;

CREATE OR REPLACE PROCEDURE check_equality(val1 INT, val2 INT)
LANGUAGE plpgsql
AS $$
BEGIN
    IF val1 = val2 THEN
        RAISE NOTICE 'O valor % é igual a %', val1, val2;
    ELSE
        RAISE NOTICE 'O valor % não é igual a %', val1, val2;
    END IF;
END;
$$;

CREATE OR REPLACE PROCEDURE check_values(val1 INT, val2 INT)
LANGUAGE plpgsql
AS $$
BEGIN
    IF val1 >= val2 THEN
        RAISE NOTICE 'O valor % é maior ou igual a %', val1, val2;
    ELSE
        RAISE NOTICE 'O valor % não é maior ou igual a %', val1, val2;
    END IF;
END;
$$;

--- CALL check_values(10, 5);
--- CALL check_equality(10, 10);
