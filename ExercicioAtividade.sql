USE master
DROP DATABASE academia

CREATE DATABASE academia
GO
USE academia

CREATE TABLE aluno(
codigo	INT	NOT NULL,
nome	VARCHAR(200) NOT NULL
PRIMARY KEY(codigo)
)
GO
CREATE TABLE atividade(
codigo	INT	NOT NULL,
descricao	VARCHAR(200) NOT NULL,
imc	DECIMAL(4,1) NOT NULL,
PRIMARY KEY(codigo)
)
GO
CREATE TABLE aluno_atividades(
codigo_aluno	INT NOT NULL,
atividade	INT NOT NULL,
altura DECIMAL(4,2) NOT NULL,
peso DECIMAL(4,1) NOT NULL,
imc DECIMAL(4,1) NOT NULL
PRIMARY KEY(codigo_aluno, atividade)
FOREIGN KEY(codigo_aluno) REFERENCES aluno(codigo),
FOREIGN KEY(atividade) REFERENCES atividade(codigo)
)

INSERT INTO atividade VALUES
(1, 'Corrida + Step', 18.5),
(2, 'Biceps + Costas + Pernas', 24.9),
(3, 'Esteira + Biceps + Costas + Pernas', 29.9),
(4, 'Bicicleta + Biceps + Costas + Pernas', 34.9),
(5, 'Esteira + Bicicleta', 39.9)

CREATE PROCEDURE sp_setatv(@imc DECIMAL(4,1), @atv INT OUTPUT)
AS
IF(@imc > 40)
BEGIN
	SET @atv = 5
END
ELSE
BEGIN
SELECT TOP 1 @atv = codigo
FROM atividade
WHERE imc > @imc
ORDER BY imc ASC
END

CREATE PROCEDURE sp_alunoatividade(@peso DECIMAL(4,1), @altura DECIMAL(4,2), @nome VARCHAR(200), @codigo INT, @saida BIT OUTPUT)
AS
DECLARE @atv INT,
		@cont INT,
		@imc DECIMAL(4,2)

IF NOT EXISTS (SELECT @codigo FROM aluno)
BEGIN
	INSERT INTO aluno VALUES
	(@codigo, @nome)
END
ELSE
IF NOT EXISTS (SELECT aa.codigo_aluno FROM aluno a, aluno_atividades aa WHERE aa.codigo_aluno = a.codigo)
BEGIN
	SET @imc = @peso / (@altura * @altura)
	EXEC sp_setatv @imc, @atv OUTPUT
	INSERT INTO aluno_atividades VALUES
	(@codigo, @atv, @altura, @peso, @imc)
END
ELSE
BEGIN
	SET @imc = @peso / (@altura * @altura)
	EXEC sp_setatv @imc, @atv OUTPUT
	UPDATE aluno_atividades
	SET imc = @imc, peso = @peso, atividade = @atv, altura = @altura
	WHERE codigo_aluno = @codigo 
END

