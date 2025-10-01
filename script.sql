-- Cria DataBase

Create Database if Not exists PressagiosDoRagnarok DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_0900_ai_ci;

-- Usa DataBase

use PressagiosDoRagnarok;

-- Cria Tabelas

CREATE TABLE Usuarios (
    id_usuario INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    senha_hash VARCHAR(255) NOT NULL, -- Sempre armazene senhas com hash!
    data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Tabela de Campanhas
CREATE TABLE Campanhas (
    id_campanha INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(150) NOT NULL,
    descricao TEXT,
    sistema_jogo VARCHAR(50),
    data_criacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    -- Chave Estrangeira que conecta a campanha ao seu mestre na tabela Usuarios
    id_mestre INT NOT NULL,
    FOREIGN KEY (id_mestre) REFERENCES Usuarios(id_usuario)
        ON DELETE RESTRICT -- Impede que um usuário seja deletado se ele for mestre de uma campanha ativa
        ON UPDATE CASCADE
);

-- Tabela de Associação entre Campanhas e Jogadores
CREATE TABLE Campanha_Jogadores (
    -- Chave Estrangeira que aponta para a campanha
    id_campanha INT NOT NULL,
    FOREIGN KEY (id_campanha) REFERENCES Campanhas(id_campanha)
        ON DELETE CASCADE -- Se a campanha for deletada, remove os jogadores dela
        ON UPDATE CASCADE,
    
    -- Chave Estrangeira que aponta para o jogador (usuário)
    id_jogador INT NOT NULL,
    FOREIGN KEY (id_jogador) REFERENCES Usuarios(id_usuario)
        ON DELETE CASCADE -- Se o jogador for deletado, ele sai das campanhas
        ON UPDATE CASCADE,
    
    nome_personagem VARCHAR(100),
    data_entrada DATETIME DEFAULT CURRENT_TIMESTAMP,
    
    -- Chave Primária composta para garantir que cada jogador só entre uma vez na campanha
    PRIMARY KEY (id_campanha, id_jogador)
);