USE master
DROP DATABASE cliente

CREATE DATABASE cliente
GO
USE cliente
GO
CREATE TABLE cliente(
cpf	CHAR(11)	NOT NULL,
nome	VARCHAR(100)	NOT NULL,
email	VARCHAR(200)	NOT NULL,
limite_de_credito	DECIMAL(7,2)	NOT NULL,
dt_nasc	DATE	NOT NULL
PRIMARY KEY(cpf)
)

-- Procedimento para validar o cpf
CREATE PROCEDURE sp_calculo (@cpf CHAR(11), @valido BIT OUTPUT)
AS
DECLARE @soma1 INT,
	@soma2 INT,
	@cont INT,
	@digito1 INT,
	@digito2 INT

SET @cont = 1
SET @soma1 = 0
SET @soma2 = 0

IF LEN(@cpf) <> 11
BEGIN
	SET @valido = 0
	RAISERROR('CPF Inválido', 16, 1)
END

WHILE(@cont <= 9)	
BEGIN 
	SET @soma1 = @soma1 + (CAST(SUBSTRING(@cpf, @cont, 1) AS INT) * (11 - @cont))
	SET @cont = @cont + 1
END
SET @cont = 1
WHILE(@cont <= 10)
BEGIN
	SET @soma2 = @soma2 + (CAST(SUBSTRING(@cpf, @cont, 1) AS INT) * (12 - @cont))
	SET @cont = @cont + 1
END
IF((@soma1 % 11) <  2)
BEGIN
	SET @digito1 = 0
END
ELSE
BEGIN
	SET @digito1 = 11 - (@soma1 % 11)
END

IF((@soma2 % 11) < 2)
BEGIN
	SET @digito2 = 0
END
ELSE
BEGIN
	SET @digito2 = 11 - (@soma2 % 11)
END
IF @digito1 = CAST(SUBSTRING(@cpf, 10, 1) AS INT) AND @digito2 = CAST(SUBSTRING(@cpf, 11, 1) AS INT)
BEGIN
	SET @valido = 1
END
ELSE
BEGIN
	SET @valido = 0
END

-- Procedimento insert/update/delete para o cliente
CREATE PROCEDURE sp_iudcliente (@op CHAR(1), @cpf CHAR(11), @nome VARCHAR(100), @email VARCHAR(200), @limcred DECIMAL(7,2), @dtnasc DATE, @saida VARCHAR(200) OUTPUT)
AS
	DECLARE @validador BIT
	EXEC sp_calculo @cpf, @validador OUTPUT

	IF(@cpf = '11111111111' OR @cpf = '22222222222' OR @cpf = '33333333333' OR @cpf = '44444444444' OR @cpf = '55555555555' OR @cpf = '66666666666' OR @cpf = '77777777777' OR @cpf = '88888888888' OR @cpf = '99999999999')
	BEGIN
		RAISERROR('CPF Inválido', 16, 1)
	END
	ELSE
		IF(UPPER(@op) = 'I' AND @validador = 1)
		BEGIN
			INSERT INTO cliente VALUES
			(@cpf, @nome, @email, @limcred, @dtnasc)
			SET @saida = 'Cliente inserido com sucesso'
		END
		ELSE
		IF(UPPER(@op) = 'U' AND @validador = 1)
		BEGIN
			UPDATE cliente
			SET nome = @nome, email = @email, limite_de_credito = @limcred, dt_nasc = @dtnasc
			WHERE cpf = @cpf
			SET @saida = 'Cliente atualizado com sucesso'
		END
		ELSE
		IF(UPPER(@op) = 'D')
		BEGIN
			DELETE cliente
			WHERE cpf = @cpf
			SET @saida = 'Cliente excluido com sucesso'
		END
	ELSE
	BEGIN
		RAISERROR('CPF Inválido', 16, 1)
	END
-- Procedimento para gerar dados com finalidade de teste do banco

CREATE PROCEDURE sp_gerardados(@saida VARCHAR(200) OUTPUT)
AS
DECLARE @nome VARCHAR(100),
		@email VARCHAR(200),
		@limcred DECIMAL(7,2),
		@dtnasc DATE,
		@cpf VARCHAR(11),
		@cont INT,
		@rand INT,
		@op CHAR
		
SET @cont = 1
WHILE(@cont <= 5)
BEGIN
	SET @cpf = CHOOSE(@cont, '23033601022', '54847787005', '44789259099', '05394174083', '22147041084')
	SET @rand = RAND()*20+1
	SET @nome = CHOOSE(@rand, 'João', 'José', 'Maria', 'Pedro', 'Miguel', 'Rafael', 'Ricardo', 'Mauricio', 'Gabriel', 'Francisco', 'Alberto', 'Bruno', 'Yasmin', 'Heloisa', 'Cláudia', 'Isabela', 'Raquel', 'Zélia', 'Marcia', 'Luisa')
	SET @email = LOWER(@nome)+CAST((CAST(RAND()*150+1 AS INT)) AS VARCHAR)+'@email.com'
	SET @rand = RAND()*10000+500
	SET @limcred = @rand
	SET @rand = RAND()*500+100
	SET @dtnasc = DATEADD(MONTH, -@rand, GETDATE())
	SET @op = 'I'
	EXEC sp_iudcliente @op, @cpf, @nome, @email, @limcred, @dtnasc, @saida
	SET @cont = @cont + 1
END	


DECLARE @exit VARCHAR(200)	
EXEC sp_clientecpf 'I', '22147041084', 'Fulano de Tal', 'fulano@detal.com', 1200, '2002-07-16', @exit OUTPUT
PRINT @exit
DECLARE @exit VARCHAR(200)	
EXEC sp_clientecpf 'U', '22147041084', 'Beltrano de tal', 'beltrano@detal.com', 7200, '1998-04-12', @exit OUTPUT
PRINT @exit
DECLARE @exit VARCHAR(200)	
EXEC sp_clientecpf 'D', '22147041084', NULL, NULL, NULL, NULL, @exit OUTPUT
PRINT @exit

-- Gerar dados a fim de teste:
DECLARE @saida VARCHAR(200)
EXEC sp_gerardados @saida
PRINT @saida


SELECT * FROM cliente
