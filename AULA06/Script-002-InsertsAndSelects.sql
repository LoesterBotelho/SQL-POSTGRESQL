--- QUESTÃO 01  - INICIO ------------------------------------------------------------------

--- INSERTs
insert into tb_categorias (nome) values ('Default'),('hortifruti'),('Bebidas'),('cereais'),('Frutas'),('Carnes'),('Lacticinios'),('Bebidas'),('Carnes');
insert into tb_clientes (nome) values ('Maria'),('João'),('Antonio'),('Leonardo');


--- INSERT 1 - TESTE 1
insert into tb_produtos (descricao,valor,idcategoria,qtd_estoque) values ('Uva', 2,2,100);
insert into tb_produtos (descricao,valor,idcategoria,qtd_estoque) values ('Banana', 1.5,2,100);
insert into tb_produtos (descricao,valor,idcategoria,qtd_estoque) values ('Laranja', 3.75,2,100);
insert into tb_produtos (descricao,valor,idcategoria,qtd_estoque) values ('FEIJÃO', 2,4,100);
insert into tb_produtos (descricao,valor,idcategoria,qtd_estoque) values ('ARROZ', 1.5,4,100);
insert into tb_produtos (descricao,valor,idcategoria,qtd_estoque) values ('VINHO', 3.75,8,100);
insert into tb_produtos (descricao,valor,idcategoria,qtd_estoque) values ('CARNES', 32.75,9,100);
insert into tb_produtos (descricao,valor,idcategoria,qtd_estoque) values ('CAFE', 2,null,100);
insert into tb_produtos (descricao,valor,idcategoria,qtd_estoque) values ('ACUCAR', 1.5,null,100);
insert into tb_produtos (descricao,valor,idcategoria,qtd_estoque) values ('FANTA UVA', 3.75,null,100);
insert into tb_produtos (descricao,valor,idcategoria,qtd_estoque) values ('SABÃO', 32.75,null,100);

--- UPDATE 1 - TESTE 1
UPDATE tb_produtos SET valor = valor + 10.0, qtd_estoque = 50 WHERE descricao = 'Uva';
UPDATE tb_produtos SET valor = valor + 10.0, qtd_estoque = 50 WHERE descricao = 'Banana';
UPDATE tb_produtos SET valor = valor + 10.0, qtd_estoque = 50 WHERE descricao = 'Laranja';
UPDATE tb_produtos SET valor = valor + 10.0, qtd_estoque = 50 WHERE descricao = 'FEIJÃO';
UPDATE tb_produtos SET valor = valor + 10.0, qtd_estoque = 50 WHERE descricao = 'ARROZ';
UPDATE tb_produtos SET valor = valor + 10.0, qtd_estoque = 50 WHERE descricao = 'VINHO';
UPDATE tb_produtos SET valor = valor + 10.0, qtd_estoque = 50 WHERE descricao = 'CARNES';
UPDATE tb_produtos SET valor = valor + 10.0, qtd_estoque = 50 WHERE descricao = 'CAFE';
UPDATE tb_produtos SET valor = valor + 10.0, qtd_estoque = 50 WHERE descricao = 'ACUCAR';
UPDATE tb_produtos SET valor = valor + 10.0, qtd_estoque = 50 WHERE descricao = 'FANTA UVA';
UPDATE tb_produtos SET valor = valor + 10.0, qtd_estoque = 50 WHERE descricao = 'SABÃO';

--- UPDATE 2 - TESTE 2
UPDATE tb_produtos SET valor = valor + 5.0, qtd_estoque = 150 WHERE descricao = 'Uva';
UPDATE tb_produtos SET valor = valor + 5.0, qtd_estoque = 150 WHERE descricao = 'Banana';
UPDATE tb_produtos SET valor = valor + 5.0, qtd_estoque = 150 WHERE descricao = 'Laranja';
UPDATE tb_produtos SET valor = valor + 5.0, qtd_estoque = 150 WHERE descricao = 'FEIJÃO';
UPDATE tb_produtos SET valor = valor + 5.0, qtd_estoque = 150 WHERE descricao = 'ARROZ';
UPDATE tb_produtos SET valor = valor + 5.0, qtd_estoque = 150 WHERE descricao = 'VINHO';
UPDATE tb_produtos SET valor = valor + 5.0, qtd_estoque = 150 WHERE descricao = 'CARNES';
UPDATE tb_produtos SET valor = valor + 5.0, qtd_estoque = 150 WHERE descricao = 'CAFE';
UPDATE tb_produtos SET valor = valor + 5.0, qtd_estoque = 150 WHERE descricao = 'ACUCAR';
UPDATE tb_produtos SET valor = valor + 5.0, qtd_estoque = 150 WHERE descricao = 'FANTA UVA';
UPDATE tb_produtos SET valor = valor + 5.0, qtd_estoque = 150 WHERE descricao = 'SABÃO';

--- PEDIDO 1
insert into tb_pedidos (data,idcliente,pagamento,qtd_parcelas) values ('2024-10-01', 1,'A',NULL);

insert into tb_pedidositens (idpedido, idproduto, quantidade, valorunitario) values (1,1,10,
(select p.valor from tb_produtos p where (p.idproduto = 1)));  


--- PEDIDO 2
insert into tb_pedidos (data,idcliente,pagamento,qtd_parcelas) values ('2024-09-01', 2,'P',5);

insert into tb_pedidositens (idpedido, idproduto, quantidade, valorunitario) values (2,2,20,
(select p.valor from tb_produtos p where (p.idproduto = 2)));  

insert into tb_pedidositens (idpedido, idproduto, quantidade, valorunitario) values (2,2,30,
(select p.valor from tb_produtos p where (p.idproduto = 3)));  

--- VALIDAÇÃO

SELECT * FROM tb_log_produtos order by datacriacao desc;

SELECT * FROM tb_log_produtos where idproduto = 1 order by datacriacao desc;


--- QUESTÃO 01 - FINAL ------------------------------------------------------------------

--- QUESTÃO 02 - INICIO ------------------------------------------------------------------

SELECT * FROM tb_pedidos;
SELECT * FROM tb_pedidositens;

--- PEDIDO 1
--- INSERIR ANTES - COM PEDIDO ABERTO
insert into tb_pedidositens (idpedido, idproduto, quantidade, valorunitario) values (1,1,10,
(select p.valor from tb_produtos p where (p.idproduto = 1)));  

--- ATUALIZAR PEDIDO PARA FECHADO
update tb_pedidos 
   set status = 'F'
     , pagamento = 'A'
     , qtd_parcelas = NULL
 where idpedido = 1;

--- VERIFICAR LOG DA OPERAÇÃO ANTERIOR
SELECT * FROM tb_log_produtos order by datacriacao desc;

---- TENTAR INSERIR ITEM COM PEDIDO FECHADO
insert into tb_pedidositens (idpedido, idproduto, quantidade, valorunitario) values (1,1,10,
(select p.valor from tb_produtos p where (p.idproduto = 1)));  

----

--- PEDIDO 2
--- INSERIR ANTES - COM PEDIDO ABERTO
insert into tb_pedidositens (idpedido, idproduto, quantidade, valorunitario) values (2,2,20,
(select p.valor from tb_produtos p where (p.idproduto = 2)));  

--- ATUALIZAR PEDIDO PARA FECHADO
update tb_pedidos 
   set status = 'F'
     , pagamento = 'P'
     , qtd_parcelas = 5
 where idpedido = 2;

--- VERIFICAR LOG DA OPERAÇÃO ANTERIOR
SELECT * FROM tb_log_produtos order by datacriacao desc;

---- TENTAR INSERIR ITEM COM PEDIDO FECHADO
insert into tb_pedidositens (idpedido, idproduto, quantidade, valorunitario) values (2,2,20,
(select p.valor from tb_produtos p where (p.idproduto = 2)));  




SELECT * FROM tb_pedidos;
SELECT * FROM tb_pedidositens;

--- QUESTÃO 02 - FINAL ------------------------------------------------------------------


--- QUESTÃO 03 - INICIO ------------------------------------------------------------------

--- PERMITE
call inserir_produto('Uva de ouro ', 2,2,100);

--- NÃO PERMITE
call inserir_produto('Banana de ouro ', 1.5,null,100);
call inserir_produto('Banana de ouro ', 1.5,0,100);

--- QUESTÃO 03 - FINAL ------------------------------------------------------------------


--- QUESTÃO 04 - INICIO ------------------------------------------------------------------

delete from tb_pedidos_parcelas pp where pp.idpedido  = 2;

select * from tb_pedidos_parcelas;

  select pp.* 
  from tb_pedidos_parcelas pp 
  where pp.idpedido  = 2;

--- PARA TESTAR É SÓ FECHAR A VENDA

--- a vista
update tb_pedidos 
   set status = 'F'
     , pagamento = 'A'
     , qtd_parcelas = NULL
 where idpedido = 1;

---- parcelada
update tb_pedidos 
   set status = 'F'
     , pagamento = 'P'
     , qtd_parcelas = 5
 where idpedido = 2;

---EU FIZ NA TABELA DE PEDIDO
/*
CREATE TABLE tb_pedidos (
    idpedido serial PRIMARY KEY,
    data DATE,
    idcliente serial,
    status VARCHAR(1) DEFAULT 'A' CHECK (status IN ('A', 'F' , 'C')), --- ABERTO --- FECHADO --- CANCELADO
    pagamento varchar(1) CHECK (status IN ('A', 'P')), --- AVISTA --- PARCELADO
    qtd_parcelas integer
);
*/

--- insert into tb_pedidos (data,idcliente,pagamento,qtd_parcelas) values ('2024-10-01', 1,'A',NULL);
--- insert into tb_pedidos (data,idcliente,pagamento,qtd_parcelas) values ('2024-09-01', 2,'P',5);

--- QUESTÃO 04 - FINAL ------------------------------------------------------------------