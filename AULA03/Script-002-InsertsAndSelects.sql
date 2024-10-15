--- criar estoque
--- transações commitar e rollback
--- https://www.w3schools.com/sql/default.asp
--- joins estudar todos join
---
--- usuarios , permissoes

/*
/* COMANDOS DML*/
CREATE TABLE tb_categorias (
    idcategoria serial PRIMARY KEY,
    nome varchar(100)
);

insert into tb_categorias (nome) values ('Default');

ALTER TABLE IF EXISTS public.tb_produtos ADD COLUMN idcategoria integer NOT NULL DEFAULT 1;

ALTER TABLE tb_produtos ADD CONSTRAINT FK_tb_categoria FOREIGN KEY (idcategoria) REFERENCES tb_categorias (idcategoria);

ALTER TABLE IF EXISTS tb_produtos ADD COLUMN qtd_estoque numeric(12, 3) NOT NULL DEFAULT 0;

ALTER TABLE IF EXISTS public.tb_produtos ADD COLUMN idcategoria integer NULL;

*/

/*
ALTER TABLE public.tb_produtos ALTER COLUMN idcategoria integer NULL;
ALTER TABLE public.tb_produtos ALTER COLUMN idcategoria BIGINT;

ALTER TABLE public.tb_produtos ALTER COLUMN idcategoria DROP NOT NULL; --- funciona

*/


/* COMANDOS DML*/
insert into tb_categorias (nome) values ('Default'),('hortifruti'),('Bebidas'),('cereais'),('Frutas'),('Carnes'),('Lacticinios'),('Bebidas'),('Carnes');

/* COMANDOS DML*/
select * from tb_categorias;

insert into tb_clientes (nome) values ('Maria'),('João'),('Antonio'),('Leonardo');

select * from tb_clientes;


select * from tb_produtos;

insert into tb_produtos (descricao,valor,idcategoria) values ('Uva', 2,2);
insert into tb_produtos (descricao,valor,idcategoria) values ('Banana', 1.5,2);
insert into tb_produtos (descricao,valor,idcategoria) values ('Laranja', 3.75,2);
insert into tb_produtos (descricao,valor,idcategoria) values ('FEIJÃO', 2,4);
insert into tb_produtos (descricao,valor,idcategoria) values ('ARROZ', 1.5,4);
insert into tb_produtos (descricao,valor,idcategoria) values ('VINHO', 3.75,8);
insert into tb_produtos (descricao,valor,idcategoria) values ('CARNES', 32.75,9);
insert into tb_produtos (descricao,valor,idcategoria) values ('CAFE', 2,null);
insert into tb_produtos (descricao,valor,idcategoria) values ('ACUCAR', 1.5,null);
insert into tb_produtos (descricao,valor,idcategoria) values ('FANTA UVA', 3.75,null);
insert into tb_produtos (descricao,valor,idcategoria) values ('SABÃO', 32.75,null);


select * from tb_pedidos;

insert into tb_pedidos (data,idcliente) values ('2024-10-01', 1);
insert into tb_pedidos (data,idcliente) values ('2024-09-01', 2);

select * from tb_pedidos p 
  inner join tb_clientes c on (p.idcliente = c.idcliente);
  
select distinct * from tb_pedidos p 
  inner join tb_clientes c on (p.idcliente = c.idcliente);

select * from tb_pedidositens;

--insert into tb_pedidositens (idpedido, idproduto, quantidade, valorunitario) values (1,1,2,2);  

select * from tb_pedidositens i 
  inner join tb_produtos p on (i.idproduto = p.idproduto);

select valor from tb_produtos p where (p.idproduto = 2);

--delete from tb_pedidositens i where i.idpedido = 1;

insert into tb_pedidositens (idpedido, idproduto, quantidade, valorunitario) values (1,1,2,
(select p.valor from tb_produtos p where (p.idproduto = 2)));  

---
--delete from tb_pedidositens i where i.idpedido = 2;

select * from tb_pedidositens;

insert into tb_pedidositens (idpedido, idproduto, quantidade, valorunitario) values (2,1,10,
(select p.valor from tb_produtos p where (p.idproduto = 1)));  

insert into tb_pedidositens (idpedido, idproduto, quantidade, valorunitario) values (2,2,20,
(select p.valor from tb_produtos p where (p.idproduto = 2)));  

insert into tb_pedidositens (idpedido, idproduto, quantidade, valorunitario) values (2,2,30,
(select p.valor from tb_produtos p where (p.idproduto = 6)));  

select * from tb_pedidositens i where i.idpedido = 1;
select * from tb_pedidositens i where i.idpedido = 2;

-----------------

select c.nome as nome_cliente , p.data,
  
  (select sum(i.quantidade * i.valorunitario) as valortotal
    from tb_pedidositens i
   where i.idpedido = p.idpedido) as valortotal,

  (select count(idproduto) as qtd_produto
    from tb_pedidositens i
   where i.idpedido = p.idpedido) as qtditens
   
  from tb_pedidos p 
 inner join tb_clientes c on (p.idcliente = c.idcliente);


select c.nome , p.data,
sum(i.quantidade * i.valorunitario) as valortotal,
count(i.idproduto) as qtd_produto
   from tb_pedidos p 
 inner join tb_clientes c on (p.idcliente = c.idcliente)
 inner join tb_pedidositens i on (p.idpedido = i.idpedido)
 inner join tb_produtos prd on (i.idproduto = prd.idproduto)
 group by c.nome , p.data
 ;
 

-----------------

  select sum(i.quantidade * i.valorunitario) as valortotal
    from tb_pedidositens i
   where i.idpedido = 2;

  
select distinct * 
  from tb_pedidos p 
 inner join tb_clientes c on (p.idcliente = c.idcliente)
 inner join tb_pedidositens i on (p.idpedido = i.idpedido)
 inner join tb_produtos prd on (i.idproduto = prd.idproduto);

---------------------------------------------------------------

select p.* ,c.*
from tb_produtos p , tb_categorias c

--- do meio - somente se existe nos dois
select p.* ,c.*
from tb_produtos p
inner join tb_categorias c on (c.idcategoria = p.idcategoria)
;

--- direita
select p.* ,c.*
from tb_produtos p
right join tb_categorias c on (c.idcategoria = p.idcategoria)
;

--- esquerda
select p.* ,c.*
from tb_produtos p
left join tb_categorias c on (c.idcategoria = p.idcategoria)
;

--- traz todos
select p.* ,c.*
from tb_produtos p
full join tb_categorias c on (c.idcategoria = p.idcategoria)
;

--- traz todos
--- full join = full outer join
select p.* ,c.*
from tb_produtos p
full join tb_categorias c on (c.idcategoria = p.idcategoria)
;

--- traz somente os vazios
select p.* ,c.*
from tb_produtos p
full outer join tb_categorias c on (c.idcategoria = p.idcategoria)
where p.idproduto is null 
   or c.idcategoria is null
;

---------------------------------------------------------------


--- clientes que não tem vendas
--- todos produtos que nunca foram vendidos 
--- todos produtos que foram vendidos
--- exists ou not exists


--- clientes que não tem vendas
select * 
  from tb_clientes c
 WHERE not exists ( select * from tb_pedidos p where p.idcliente = c.idcliente)


--- todos produtos que nunca foram vendidos 
select * 
  from tb_produtos p
 WHERE not exists ( 
                    select * 
                      from tb_pedidositens pi 
                      where pi.idproduto = p.idproduto)

--- todos produtos que foram vendidos
select * 
  from tb_produtos p
 WHERE exists ( 
                    select * 
                      from tb_pedidositens pi 
                      where pi.idproduto = p.idproduto)


---------------------------------------------------------------



--- clientess que não tem vendas
select * 
  from tb_pedidos p 
 full join tb_clientes c on (p.idcliente = c.idcliente)
 where p.idpedido is null
;

----------------------------

--- todos produtos que nunca foram vendidos 
select * 
 from tb_pedidos p 
 full join tb_pedidositens i on (p.idpedido = i.idpedido)
 full join tb_produtos prd on (i.idproduto = prd.idproduto)
where p.idpedido is null
;


--- todos produtos que foram vendidos
select * 
 from tb_pedidos p 
 full join tb_pedidositens i on (p.idpedido = i.idpedido)
 full join tb_produtos prd on (i.idproduto = prd.idproduto)
where p.idpedido is not null
;

