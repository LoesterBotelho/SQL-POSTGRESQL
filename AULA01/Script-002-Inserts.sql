INSERT INTO public.autor(cpf, nome, datanascimento) VALUES (39234251040, 'Isis Isabella Carolina da Rocha', '20/07/1989');

SELECT autorid, cpf, nome, datanascimento FROM public.autor;

INSERT INTO public.livro( isbn, titulo, editora, ano) VALUES ('9783127323207', 'Scrum fazendo o dobro na metade do tempo', 'ABRIL', 2024);

SELECT isbn, titulo, editora, ano FROM public.livro;

INSERT INTO public.livro_autor( fk_livro_isbn, fk_autor_autorid) VALUES ('9783127323207', 1);

SELECT fk_livro_isbn, fk_autor_autorid FROM public.livro_autor;

INSERT INTO public.cliente( cpf, nome, endereco) VALUES (45534847492, 'Maitê Carolina Fernandes', 'Rua Hermínio Victorelli , 834 , Centro , Ji-Paraná , RO');

SELECT cpf, nome, endereco 	FROM public.cliente;
	
INSERT INTO public.emprestimo( dataemprestimo, datadevolucao, fk_cliente_cpf) VALUES ('17/09/2024', '17/10/2024', 45534847492);

SELECT emprestimoid, dataemprestimo, datadevolucao, fk_cliente_cpf FROM public.emprestimo;

INSERT INTO public.livro_emprestimo( fk_emprestimo_emprestimoid, fk_livro_isbn) VALUES (8, '9783127323207');

SELECT fk_emprestimo_emprestimoid, fk_livro_isbn FROM public.livro_emprestimo;

