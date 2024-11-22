
--- EXÉRCICIO 01

-- Criando Usuários
CREATE USER usuario_leitura WITH PASSWORD '123';
CREATE USER usuario_escrita WITH PASSWORD '123';
CREATE USER usuario_consulta WITH PASSWORD '123';
CREATE USER usuario_analista WITH PASSWORD '123';
CREATE USER usuario_editor WITH PASSWORD '123';
CREATE USER admin_local WITH PASSWORD '123';


-- Criando Grupo
CREATE ROLE grupo_vendas;
CREATE ROLE grupo_financeiro;

-- Permissão de Usuários
GRANT SELECT ON tb_clientes to usuario_leitura;
GRANT SELECT, INSERT, UPDATE ON tb_clientes to usuario_escrita;
GRANT SELECT ON tb_relatorios to usuario_analista;
REVOKE UPDATE ON tb_clientes FROM usuario_escrita;
GRANT INSERT, UPDATE ON tb_inventario TO usuario_editor;
GRANT CREATE ON SCHEMA public TO admin_local;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO usuario_consulta;

-- Associando os usuários ao grupo
GRANT grupo_vendas TO usuario_leitura;
GRANT grupo_vendas TO usuario_escrita;

-- Permissão do Grupo
GRANT SELECT, INSERT, UPDATE ON tb_clientes to grupo_vendas;
GRANT SELECT, INSERT, UPDATE ON tb_clientes to grupo_vendas;
GRANT SELECT, UPDATE ON tb_financeiro to grupo_financeiro;


\dt nometabela

--- listar permissao
\dp

--- lista todos database
\l

--- conecta na base
\c db_permissao



