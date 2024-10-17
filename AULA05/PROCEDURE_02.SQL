CREATE OR REPLACE PROCEDURE sp_vnd_iten7 (pIDpedido int, pIDproduto int, pQTD decimal)
LANGUAGE plpgsql
AS $$
declare 
	vPrecoProduto decimal;
	vQuantidadeEstoque decimal;
BEGIN

	if exists(	select 1 from tb_pedidos pe where pe.idpedido = pIDpedido ) then

		if exists(	select 1 from tb_produtos pr where pr.idproduto = pIDproduto ) then
			
			select pr.valor , pr.qtd_estoque into vPrecoProduto ,vQuantidadeEstoque
			from tb_produtos pr where pr.idproduto = pIDproduto;
		
			if (vQuantidadeEstoque < pQTD) THEN
				RAISE NOTICE 'O saldo não pode ser negativo.';				
			else	
				insert into tb_pedidositens (idpedido, idproduto, quantidade, valorunitario) 
				values  (pIDpedido, pIDproduto, pQTD, vPrecoProduto);

				update tb_produtos set qtd_estoque = qtd_estoque - pQTD where idproduto = pIDproduto;
				
				RAISE NOTICE 'Item adicionado com sucesso';
			END IF;
	
		else
		
			RAISE NOTICE 'O produto id: % não existe.', pIDproduto;
		end if;
		
	else
		RAISE NOTICE 'O pedido id: % não existe.', pIDpedido;
	end if;	
	

	exception
	   when foreign_key_violation then
	     raise notice 'O pedido Id:% não existe.',pPedidoId; 

	   when others then
	     raise notice 'Ocorreu um erro inesperado.'; 

END;
$$;

update tb_produtos set qtd_estoque = 150 where idproduto = 3;
select pr.valor , pr.qtd_estoque from tb_produtos pr where pr.idproduto = 3;

call sp_vnd_iten7(1,3,50);



call sp_vnd_iten7(1,22222,200);

call sp_vnd_iten7(12222,1,200);

select * from tb_pedidositens;


select * from tb_pedidos;
select * from tb_pedidositens;
select * from tb_produtos;
