CREATE DATABASE exercicioSQL
GO
USE exercicioSQL

-- *************  RESETAR EXERCICIO  ************* --
/*
-- 0. Nenhum consulta deve estar usando esse BD

-- 1. limpar as Tabelas
DELETE user_has_projects
GO
DELETE users
DELETE projects

GO

-- 2. apagar Tabelas
DROP TABLE user_has_projects
GO
DROP TABLE users
DROP TABLE projects

GO

-- 3. apagar DATA BASE
USE master
GO
DROP DATABASE exercicioSQL

-- 4. Recriar tudo
*/

-- *************  CONFERIR EXERCICIO  ************* --
/*
-- 1-2. Verificar as Tabelas - Estrutura
EXEC sp_help users
EXEC sp_help projects
EXEC sp_help user_has_projects

-- 3-4. Verificar Registros
SELECT * FROM users
SELECT * FROM projects
SELECT * FROM user_has_projects
*/

-- 1. Criando tabelas
CREATE TABLE users
(
	id				INT			NOT NULL IDENTITY(1, 1),
	name			VARCHAR(45)	NULL,
	username		VARCHAR(45)	NULL,
	password		VARCHAR(45)	NOT NULL CONSTRAINT DF_password DEFAULT('123mudar'),
	email			VARCHAR(45)	NULL,
	CONSTRAINT	UQ_username UNIQUE (username),
	PRIMARY	KEY (id)
)

CREATE TABLE projects
(
	id				INT			NOT NULL IDENTITY(10001, 1),
	name			VARCHAR(45)	NULL,
	description		VARCHAR(45)	NULL,
	date			DATE		NULL CHECK(date > '2014-09-01')
	PRIMARY	KEY (id)
)
GO
CREATE TABLE user_has_projects
(
	users_id		INT		NOT NULL,
	projects_id		INT		NOT NULL
	PRIMARY	KEY(users_id, projects_id)
	FOREIGN	KEY(users_id)		REFERENCES users	(id),
	FOREIGN	KEY(projects_id)	REFERENCES projects	(id)
)

/*
DROP TABLE user_has_projects
GO
DROP TABLE users
DROP TABLE projects
*/

EXEC sp_help users
EXEC sp_help projects
EXEC sp_help user_has_projects

-- 2. ALTERAR COLUNAS
/*
# Para alterar colunas com CONSTRAINTS:
1. remover a CONSTRAINT (� bom ela ter um nome)
2. alterar a coluna (de preferencia sem dados nela)
3. readicionar a CONSTRAINT (� bom usar o mesmo nome)
*/
-- =============== Alterando a Coluna 'username' =============== --
-- 1. remover a CONSTRAINT
ALTER TABLE users
DROP CONSTRAINT UQ_username
GO
EXEC sp_help users
-- 2. alterar a coluna
ALTER TABLE users
ALTER COLUMN username VARCHAR(10) NULL
GO
EXEC sp_help users
-- 3. readicionar a CONSTRAINT
ALTER TABLE users
ADD CONSTRAINT UQ_username UNIQUE (username)
GO
EXEC sp_help users

-- =============== Alterando a Coluna 'password' =============== --
-- 1. remover a CONSTRAINT
ALTER TABLE users
DROP CONSTRAINT DF_password
GO
EXEC sp_help users
-- 2. alterar a coluna
ALTER TABLE users
ALTER COLUMN password VARCHAR(10) NULL
GO
EXEC sp_help users

-- 3. readicionar a CONSTRAINT
ALTER TABLE users
ADD CONSTRAINT DF_password DEFAULT ('123mudar') FOR password
GO
EXEC sp_help users


-- 3. Inser��o de Valores
DELETE user_has_projects
GO
DELETE users
DELETE projects


INSERT INTO users VALUES
	('Maria', 'Rh_maria', '123mudar', 'maria@empresa.com'),
	('Paulo', 'Ti_paulo', '123@456', 'paulo@empresa.com'),
	('Ana', 'Rh_ana', '123mudar', 'ana@empresa.com'),
	('Clara', 'Ti_clara', '123mudar', 'clara@empresa.com'),
	('Aparecido', 'Rh_apareci', '55@!cido', 'aparecido@empresa.com')
GO
SELECT * FROM users

INSERT INTO projects VALUES
	('Re-folha', 'Refatora��o das Folhas', ' 05/09/2014'),
	('Manuten��o PC s', 'Manuten��o PC s', ' 06/09/2014'),
	('Auditoria', NULL, ' 07/09/2014')
GO

SELECT * FROM projects


SELECT id FROM projects
ORDER BY id ASC
SELECT id FROM users
ORDER BY id ASC


INSERT INTO user_has_projects
VALUES
	(1, 10001),
	(5, 10001),
	(3, 10003),
	(4, 10002),
	(2, 10002)
GO
SELECT * FROM user_has_projects
ORDER BY projects_id

-- 4. ====================== Considerar as situa��es: ====================== --

-- O projeto de Manuten��o atrasou, mudar a data para 12/09/2014

UPDATE projects
SET date = '12/09/2014'
WHERE id = 10002
GO
SELECT * FROM projects

-- O username de aparecido (usar o nome como condi��o de mudan�a) est� feio, mudar para Rh_cido
UPDATE users
SET username = 'Rh_cido'
WHERE name = 'Aparecido'
GO
SELECT * FROM users

-- Mudar o password do username Rh_maria (usar o username como condi��o de mudan�a) 
--				para 888@*, mas a condi��o deve verificar se o password dela ainda � 123mudar
UPDATE users
SET password = '888@*'
WHERE password = '123mudar' AND username = 'Rh_maria'
GO
SELECT * FROM users

-- O user de id 2 n�o participa mais do projeto 10002, remov�-lo da associativa
DELETE user_has_projects
WHERE users_id = 2
GO
SELECT * FROM user_has_projects
ORDER BY projects_id
