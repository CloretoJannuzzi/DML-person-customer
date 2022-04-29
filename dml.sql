USE tempdb;
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
CREATE TABLE carro(
    id_carro INT IDENTITY(1,1) PRIMARY KEY,
    placa CHAR(10),
    modelo VARCHAR(20),
    marca VARCHAR(20)
);
GO
CREATE TABLE cliente_carro(
    id_carro INT FOREIGN KEY REFERENCES carro (id_carro),
    id_cliente INT FOREIGN KEY REFERENCES cliente (id_cliente)
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
    IF @opcao = 1 AND @nome IS NOT NULL AND @sobrenome IS NOT NULL AND @cpf IS NOT NULL
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

    IF @opcao = 2 AND @cpf IS NOT NULL AND (EXISTS(SELECT * FROM pessoa WHERE cpf = @cpf))
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

    IF @opcao = 3 AND @cpf IS NOT NULL AND (EXISTS(SELECT * FROM pessoa WHERE cpf = @cpf))
        BEGIN
            DECLARE @id_pessoa INT
            SELECT @id_pessoa = [id_pessoa] FROM pessoa
                WHERE cpf = @cpf
            DELETE cliente where id_pessoa = @id_pessoa
            DELETE pessoa where cpf = @cpf
        RETURN
    END

    IF @opcao = 4
        BEGIN
            SELECT * FROM pessoa p INNER JOIN cliente c ON p.id_pessoa = c.id_pessoa
            WHERE (@cpf IS NULL OR cpf = @cpf) 
            AND ((nome = @nome OR @nome IS NULL) AND (@sobrenome IS NULL OR sobrenome = @sobrenome)) 
        RETURN
    END


-- PROCEDURE PESSOA CLIENTE CONCLUÍDO - MESMA LÓGICA PARA FUNCIONÁRIO.


-- PROCEDURE DML CARRO(Mesma sessão)

GO
CREATE PROCEDURE sp_car(
    @opcao INT,
    @placa CHAR(10),
    @modelo VARCHAR(20),
    @marca VARCHAR(20),
    @cpf char(11)
)
AS
    -- Só serve essa if se for sequencial(cliente -> carro)
    IF @opcao = 1 AND @placa IS NOT NULL AND @modelo IS NOT NULL AND @marca IS NOT NULL
        BEGIN
            INSERT INTO carro (
                placa,
                modelo,
                marca
            )
            VALUES(
                @placa,
                @modelo,
                @marca
            );

            DECLARE @id_carro INT = SCOPE_IDENTITY(), @id_cliente INT
            SELECT TOP 1 @id_cliente = SCOPE_IDENTITY() FROM cliente

            INSERT INTO cliente_carro(id_carro, id_cliente)
            VALUES(@id_carro, @id_cliente);
        RETURN
    END 

    IF @opcao = 2 AND @placa IS NOT NULL AND (EXISTS(SELECT * FROM carro WHERE placa = @placa))
        BEGIN
            IF @modelo IS NULL
                SELECT @modelo = [modelo] FROM carro WHERE placa = @placa
            IF @marca IS NULL
                SELECT @marca = [marca] FROM carro WHERE placa = @placa

            UPDATE carro SET modelo = @modelo, marca = @marca
            WHERE placa = @placa
        RETURN
    END

    --Relacionamento, caso cliente seja criado e ja tenha um carro q tbm pertence a ele cadastrado
    IF @opcao = 3 AND @placa IS NOT NULL AND (EXISTS(SELECT * FROM carro WHERE placa = @placa))
    AND @cpf IS NOT NULL AND (EXISTS(SELECT * FROM pessoa p INNER JOIN cliente c ON p.id_pessoa = c.id_pessoa WHERE cpf = @cpf))
        BEGIN
            DECLARE @id_cliente2 INT
            SELECT @id_cliente2 = [id_cliente] FROM cliente c 
            INNER JOIN pessoa p ON c.id_pessoa = p.id_pessoa
                WHERE cpf = @cpf 

            INSERT INTO cliente_carro(id_carro,id_cliente)
            VALUES(@placa,@id_cliente2);
        RETURN
    END

    IF @opcao = 4 AND @placa IS NOT NULL 
    AND (EXISTS(SELECT * FROM carro c INNER JOIN cliente_carro cc ON c.id_carro = cc.id_carro WHERE placa = @placa ))
        BEGIN
            DECLARE @id_carro INT
            SELECT @id_carro = id_carro FROM carro 
                WHERE placa = @placa
            DELETE cliente_carro WHERE id_carro = @id_carro
            DELETE carro WHERE id_carro = @id_carro
            
            
        RETURN
    END
