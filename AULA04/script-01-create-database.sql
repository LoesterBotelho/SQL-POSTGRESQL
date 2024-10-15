

-- FORÇAR A REMOÇÃO DO BANCO DE DADOS
DO $$ 
BEGIN 
    -- Verifica se o banco de dados existe
    IF EXISTS (
        SELECT 1 
        FROM pg_database 
        WHERE datname = 'db_aula01'
    ) THEN
        -- Altera o limite de conexões para desconectar usuários
        EXECUTE 'ALTER DATABASE db_aula01 CONNECTION LIMIT 0'; 
    END IF;
END $$;

DROP DATABASE IF EXISTS db_aula01;

CREATE DATABASE db_aula01
WITH TEMPLATE template0 
LC_COLLATE='pt_BR.UTF-8' 
LC_CTYPE='pt_BR.UTF-8' 
ENCODING='UTF8';