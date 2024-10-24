CREATE TABLE Livro (
    ISBN VARCHAR(13) PRIMARY KEY,
    Titulo VARCHAR(100),
    Editora VARCHAR(50),
    Ano INT
);

CREATE TABLE Autor (
    AutorID serial PRIMARY KEY,
    CPF CHAR(11),
    Nome VARCHAR(100),
    DataNascimento DATE
);

CREATE TABLE Cliente (
    CPF CHAR(11) PRIMARY KEY,
    Nome VARCHAR(100),
    Endereco VARCHAR(200)
);

CREATE TABLE Emprestimo (
    EmprestimoID serial PRIMARY KEY,
    DataEmprestimo DATE,
    DataDevolucao DATE,
    fk_Cliente_CPF CHAR(11)
);

CREATE TABLE Livro_Autor (
    fk_Livro_ISBN VARCHAR(13),
    fk_Autor_AutorID serial
);

CREATE TABLE Livro_Emprestimo (
    fk_Emprestimo_EmprestimoID serial,
    fk_Livro_ISBN VARCHAR(13)
);
 
ALTER TABLE Emprestimo ADD CONSTRAINT FK_Emprestimo_2
    FOREIGN KEY (fk_Cliente_CPF)
    REFERENCES Cliente (CPF)
    ON DELETE CASCADE;
 
ALTER TABLE Livro_Autor ADD CONSTRAINT FK_Livro_Autor_1
    FOREIGN KEY (fk_Livro_ISBN)
    REFERENCES Livro (ISBN)
    ON DELETE RESTRICT;
 
ALTER TABLE Livro_Autor ADD CONSTRAINT FK_Livro_Autor_2
    FOREIGN KEY (fk_Autor_AutorID)
    REFERENCES Autor (AutorID)
    ON DELETE RESTRICT;
 
ALTER TABLE Livro_Emprestimo ADD CONSTRAINT FK_Livro_Emprestimo_1
    FOREIGN KEY (fk_Emprestimo_EmprestimoID)
    REFERENCES Emprestimo (EmprestimoID)
    ON DELETE RESTRICT;
 
ALTER TABLE Livro_Emprestimo ADD CONSTRAINT FK_Livro_Emprestimo_2
    FOREIGN KEY (fk_Livro_ISBN)
    REFERENCES Livro (ISBN)
    ON DELETE SET NULL;