CREATE DATABASE crud_customer;
GO
USE crud_customer;
GO
CREATE TABLE pessoa
(
    id_pessoa INT IDENTITY(1,1) PRIMARY KEY,
    nome VARCHAR(30),
    sobrenome VARCHAR(30),
    cpf char(11),
    cep char(11)
);
GO
CREATE TABLE cliente
(
    id_cliente INT IDENTITY(1,1) PRIMARY KEY,
    id_pessoa INT UNIQUE FOREIGN KEY REFERENCES pessoa (id_pessoa)
);
GO
CREATE PROC sp_customer(
    @opcao int not NULL,
    @nome varchar(30),
    @sobrenome varchar(30),
    @cpf char(11),
    @cep char(11)
    )
AS

IF @opcao = 1
    BEGIN
    INSERT INTO pessoa(nome, sobrenome, cpf, cep)
    VALUES(
        @nome,
        @sobrenome,
        @cpf,
        @cep
    );

    DECLARE @id INT = SCOPE_IDENTITY()
    INSERT INTO cliente(id_pessoa) VALUES(@id);
    RETURN
END

IF @opcao = 2 AND @cpf IS NOT NULL
    BEGIN
        IF @nome IS NULL 
            SELECT @nome = [nome] FROM pessoa WHERE cpf = @cpf
        IF @sobrenome IS NULL 
            SELECT @sobrenome = [sobrenome] FROM pessoa WHERE cpf = @cpf
        IF @cep IS NULL
            SELECT @cep = [cep] FROM pessoa WHERE cpf = @cpf

        UPDATE pessoa SET nome = @nome, sobrenome = @sobrenome, cep = @cep
        FROM pessoa p
        INNER JOIN cliente c
        ON p.id_pessoa = c.id_pessoa
            WHERE p.cpf = @cpf
    RETURN
END

IF @opcao = 3 AND @cpf IS NOT NULL or (@nome IS NOT NULL AND @sobrenome IS NOT NULL)
    BEGIN
    IF (EXISTS(SELECT * FROM pessoa WHERE cpf = @cpf))
    OR (EXISTS(SELECT * FROM pessoa WHERE nome = @nome AND sobrenome = @sobrenome))
        BEGIN
            DECLARE @id_pessoa INT
            SELECT @id_pessoa = [id_pessoa] FROM pessoa
                WHERE cpf = @cpf OR (nome = @nome AND sobrenome = @sobrenome)
            DELETE cliente where id_pessoa = @id_pessoa
            DELETE pessoa where cpf = @cpf
        END
    RETURN
END

IF @opcao = 4
    BEGIN
        SELECT * FROM pessoa p INNER JOIN cliente c ON p.id_pessoa = c.id_pessoa
        WHERE (@cpf IS NULL OR cpf = @cpf) 
        AND ((nome = @nome OR @nome IS NULL) AND (@sobrenome IS NULL OR sobrenome = @sobrenome)) 
    RETURN
END
