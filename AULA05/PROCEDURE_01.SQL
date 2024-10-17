CREATE OR REPLACE PROCEDURE sp_insert_usr2 (pNome text, pEmail text)
LANGUAGE plpgsql
AS $$
BEGIN
	insert into tb_usuarios (nome,email) values (pNome,pEmail);
END;
$$;


CREATE OR REPLACE PROCEDURE sp_update_usr2 (pNome text, pEmail text)
LANGUAGE plpgsql
AS $$
BEGIN

	IF NOT EXISTS (select 1 from tb_usuarios u where u.email = email)
	THEN
		insert into tb_usuarios (nome,email) values (pNome,pEmail);
		RAISE NOTICE 'O usuário %, com o email % foi inserido com sucesso',pNome,pEmail;
	ELSE
		RAISE NOTICE 'Já existe um usuário com o email %', pEmail;
	END IF;

END;
$$;

call sp_insert_usr2('Mariana','mariana@hotmail.com')

call sp_update_usr2('Mariana','mariana@hotmail.com')


CREATE TABLE tb_usuarios (
    id serial PRIMARY KEY,
    nome VARCHAR(40) not null,
	email VARCHAR(100) not null unique
);

select * from tb_usuarios u where u.nome like '%%';

insert into tb_usuarios (nome,email) values 
('Maria','maria@hotmail.com'),
('João','joao@hotmail.com'),
('Antonio','antonio@hotmail.com'),
('Leonardo','leonardo@hotmail.com');