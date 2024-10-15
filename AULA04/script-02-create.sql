DROP SCHEMA IF EXISTS public CASCADE;

DROP SCHEMA IF EXISTS contabil cascade;
DROP SCHEMA IF EXISTS financeiro cascade;

CREATE SCHEMA IF NOT EXISTS contabil;
CREATE SCHEMA IF NOT EXISTS financeiro;


--- VERIFICAR SE EXISTE USUÁRIO
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 
        FROM pg_roles 
        WHERE rolname = 'usr_financeiro'
    ) THEN
        CREATE USER usr_financeiro WITH PASSWORD 'PA@password';
    END IF;
END $$;


--- VERIFICAR SE EXISTE USUÁRIO
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 
        FROM pg_roles 
        WHERE rolname = 'usr_contabil'
    ) THEN
        CREATE USER usr_contabil WITH PASSWORD 'PA@password';
    END IF;
END $$;


CREATE TABLE IF NOT EXISTS contabil.plano_contas (
    id SERIAL PRIMARY KEY,
    codigo VARCHAR(20) NOT NULL UNIQUE,
    nome VARCHAR(100) NOT NULL,
    tipo VARCHAR(50) CHECK (tipo IN ('ativo', 'passivo', 'receita', 'despesa')) NOT NULL,
    nivel INTEGER NOT NULL,
    descricao TEXT,
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS contabil.centro_custo (
    id SERIAL PRIMARY KEY,
    codigo VARCHAR(20) NOT NULL UNIQUE,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    status VARCHAR(20) CHECK (status IN ('ativo', 'inativo')) NOT NULL,
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS contabil.livro_diario (
    id SERIAL PRIMARY KEY,
    data DATE NOT NULL,
    conta_id INTEGER NOT NULL,
    tipo VARCHAR(50) CHECK (tipo IN ('debito', 'credito')) NOT NULL,
    valor NUMERIC(15, 2) NOT NULL,
    descricao TEXT,
    centro_custo_id INTEGER,
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (conta_id) REFERENCES contabil.plano_contas(id) ON DELETE CASCADE,
    FOREIGN KEY (centro_custo_id) REFERENCES contabil.centro_custo(id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS contabil.livro_razao (
    id SERIAL PRIMARY KEY,
    data DATE NOT NULL,
    conta_id INTEGER NOT NULL,
    tipo VARCHAR(50) CHECK (tipo IN ('debito', 'credito')) NOT NULL,
    valor NUMERIC(15, 2) NOT NULL,
    descricao TEXT,
    saldo NUMERIC(15, 2) NOT NULL,
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (conta_id) REFERENCES contabil.plano_contas(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS contabil.balanco (
    id SERIAL PRIMARY KEY,
    data DATE NOT NULL,
    conta_id INTEGER NOT NULL,
    tipo VARCHAR(20) CHECK (tipo IN ('ativo', 'passivo', 'patrimonio_liquido')) NOT NULL,
    valor NUMERIC(15, 2) NOT NULL,
    descricao TEXT,
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    atualizado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (conta_id) REFERENCES contabil.plano_contas(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS financeiro.transacoes (
    id SERIAL PRIMARY KEY,
    data DATE NOT NULL,
    tipo VARCHAR(20) CHECK (tipo IN ('receber', 'pagar')) NOT NULL,
    valor NUMERIC(15, 2) NOT NULL,
    descricao TEXT,
    conta_id INTEGER NOT NULL,
    centro_custo_id INTEGER,
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    atualizado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (conta_id) REFERENCES contabil.plano_contas(id) ON DELETE CASCADE,
    FOREIGN KEY (centro_custo_id) REFERENCES contabil.centro_custo(id) ON DELETE SET NULL
);


-- Remover a função se existir
DO $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM pg_proc
        WHERE proname = 'update_atualizado_em'
        AND pronamespace = (SELECT oid FROM pg_namespace WHERE nspname = 'financeiro')
    ) THEN
        EXECUTE 'DROP FUNCTION financeiro.update_atualizado_em()';
    END IF;
END $$;

-- Remover a função se existir
DO $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM pg_proc
        WHERE proname = 'update_atualizado_em'
        AND pronamespace = (SELECT oid FROM pg_namespace WHERE nspname = 'contabil')
    ) THEN
        EXECUTE 'DROP FUNCTION contabil.update_atualizado_em()';
    END IF;
END $$;

-- Criar um trigger para atualizar a coluna 'atualizado_em' automaticamente
CREATE OR REPLACE FUNCTION contabil.update_atualizado_em()
RETURNS TRIGGER AS $$
BEGIN
    NEW.atualizado_em := CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Criar um trigger para atualizar a coluna 'atualizado_em' automaticamente
CREATE OR REPLACE FUNCTION financeiro.update_atualizado_em()
RETURNS TRIGGER AS $$
BEGIN
    NEW.atualizado_em := CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER balanco_atualizado
BEFORE UPDATE ON contabil.balanco
FOR EACH ROW EXECUTE FUNCTION contabil.update_atualizado_em();

CREATE TRIGGER transacoes_atualizado
BEFORE UPDATE ON financeiro.transacoes
FOR EACH ROW EXECUTE FUNCTION financeiro.update_atualizado_em();





GRANT SELECT, INSERT, UPDATE ON TABLE contabil.balanco TO usr_contabil;
GRANT SELECT, INSERT, UPDATE ON TABLE financeiro.transacoes TO usr_financeiro;

REVOKE ALL PRIVILEGES ON TABLE financeiro.transacoes FROM usr_contabil;
REVOKE ALL PRIVILEGES ON TABLE contabil.balanco FROM usr_financeiro;

REVOKE UPDATE ON TABLE contabil.balanco FROM usr_contabil;
REVOKE UPDATE ON TABLE financeiro.transacoes FROM usr_financeiro;

GRANT SELECT ON ALL TABLES IN SCHEMA contabil TO usr_contabil;
GRANT SELECT ON ALL TABLES IN SCHEMA financeiro TO usr_financeiro;

REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA financeiro FROM usr_contabil;
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA contabil FROM usr_financeiro;