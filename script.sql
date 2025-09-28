-- Cria DataBase

Create Database if Not exists AutoSimula DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_0900_ai_ci;

-- Usa DataBase

use AutoSimula;

-- Cria Tabelas

CREATE TABLE Carros (
    id_carro INT AUTO_INCREMENT PRIMARY KEY,
    id_combustivel INT,
    id_localizacao INT,
    id_fabricante INT,
    preço float,
    cilindradas FLOAT,
    usado BOOLEAN NOT NULL, 
    quilometragem INT,
    ano_modelo YEAR NOT NULL,
    automatico boolean,             
    versao VARCHAR(100) NOT NULL,
	modelo VARCHAR(100),
    FOREIGN KEY (id_combustivel) REFERENCES Combustivel(id_combustivel),
    FOREIGN KEY (id_localizacao) REFERENCES Localizacao(id_localizacao),
    foreign key (id_fabricante) references Fabricante(id_fabricante)
);

CREATE TABLE Fabricante(
	id_fabricante INT AUTO_INCREMENT PRIMARY KEY,
	nome varchar(60)
);

CREATE  TABLE Localizacao(
    id_localizacao INT AUTO_INCREMENT PRIMARY KEY,
    estado CHAR(2) NOT NULL,
    cidade VARCHAR(100) NOT NULL
);

CREATE TABLE combustivel(
id_combustivel INT AUTO_INCREMENT PRIMARY KEY,
descricao VARCHAR(50) NOT NULL  #gasolina, alcool, flex, diesel, eletrico
);

-- Querys para pegar os dados

-- Quantidade de carros por fabricante (gráfico de barras):
SELECT f.nome AS fabricante, COUNT(*) AS quantidade
FROM Carros c
JOIN Fabricante f ON c.id_fabricante = f.id_fabricante
GROUP BY f.nome
ORDER BY quantidade DESC;

-- Média de quilometragem por ano de modelo (gráfico de linhas):
SELECT ano_modelo, AVG(quilometragem) 
FROM Carros
GROUP BY ano_modelo
ORDER BY ano_modelo;

-- Média de preço por fabricante (gráfico de barras):
SELECT f.nome AS fabricante, AVG(c.preco) AS media_preco
FROM Carros c
JOIN Fabricante f ON c.id_fabricante = f.id_fabricante
GROUP BY f.nome
ORDER BY media_preco DESC;

-- Média de preço por tipo de combustível (gráfico de barras):
SELECT c.id_combustivel, AVG(c.preco) AS media_preco
FROM Carros c
JOIN Combustivel co ON c.id_combustivel = co.id_combustivel
GROUP BY c.id_combustivel
ORDER BY media_preco DESC;

-- Média de preço por ano de modelo (gráfico de linhas):
SELECT ano_modelo, AVG(preco) AS media_preco
FROM Carros
GROUP BY ano_modelo
ORDER BY ano_modelo;