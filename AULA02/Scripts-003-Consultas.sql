select * from tb_autores ta where ta.ativo  = 'Y';
select * from tb_categorias tc where tc.ativo  = 'Y';
select * from tb_editoras te where te.ativo  = 'Y';


select * from tb_livros tl where tl.ativo  = 'Y';
select * from tb_livrosautores tl;

select tl.id
     , tl.ano 
     , tl.titulo
     , tl.isbn
     , tl.ativo
     , tl.idcategoria
     , tc.nome as nome_categoria
     , tl.ideditora
     , te.nome as nome_editora
 from tb_livros tl 
 join tb_categorias tc on (tl.idcategoria = tc.id)
 join tb_editoras te on (tl.ideditora = te.id)
 where tl.ativo  = 'Y'
;

select tla.idautor
     , ta.nome as nome_autor
     , tla.idlivro 
     , tl.titulo 
  from tb_livrosautores tla
  join tb_autores ta on (tla.idautor = ta.id)
  join tb_livros tl on (tla.idlivro = tl.id)
 order by titulo
  ;
  
 
select tl.id
     , tl.ano 
     , tl.titulo
     , tl.isbn
     , tl.ativo
     , tl.idcategoria
     , tc.nome as nome_categoria
     , tl.ideditora
     , te.nome as nome_editora
     , STRING_AGG(ta.nome, ', ') as autores
  from tb_livros tl
  join tb_categorias tc on (tl.idcategoria = tc.id)
  join tb_editoras te on (tl.ideditora = te.id)  
  join tb_livrosautores tla on (tl.id = tla.idLivro)
  join tb_autores ta on (tla.idAutor = ta.id)
 group by tl.id
     , tl.ano
     , tl.titulo
     , tl.isbn
     , tl.ativo
     , tl.idcategoria
     , tc.nome
     , tl.ideditora
     , te.nome
 ;
 
