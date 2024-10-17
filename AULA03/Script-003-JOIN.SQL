select p.*, c.descricao 
from produtos p, categorias c
where p.categoriaId = c.id

select p.*, c.descricao 
from produtos p
inner join categorias c
on p.categoriaId = c.id

select p.*, c.descricao 
from produtos p
right join categorias c
on p.categoriaId = c.id

select p.*, c.descricao 
from produtos p
left join categorias c
on p.categoriaId = c.id

select p.*, c.descricao 
from produtos p
full join categorias c
on p.categoriaId = c.id

