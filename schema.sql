-- Criação das tabelas para o projeto Presságios do Ragnarok

-- Tabela de Usuários
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

-- Exemplos de Uso

INSERT INTO Usuarios (nome, email, senha_hash) VALUES
('Carlos Silva', 'carlos.mestre@email.com', 'hash_seguro_123'), -- ID 1 (Será o Mestre)
('Ana Souza', 'ana.player@email.com', 'hash_seguro_456'),    -- ID 2 (Será Jogadora)
('Bruno Lima', 'bruno.player@email.com', 'hash_seguro_789');   -- ID 3 (Será Jogador)

INSERT INTO Campanhas (nome, sistema_jogo, id_mestre) VALUES
('O Enigma da Montanha de Gelo', 'D&D 5e', 1);

INSERT INTO Campanha_Jogadores (id_campanha, id_jogador, nome_personagem) VALUES
(1, 2, 'Lyra, a Elfa Arqueira'),
(1, 3, 'Grom, o Bárbaro Anão');

SELECT C.nome AS NomeDaCampanha, Mestre.nome AS Mestre, Jogador.nome AS NomeDoJogador, CJ.nome_personagem AS Personagem
    FROM Campanhas C
-- Junta com a tabela de usuários para pegar o nome do Mestre
JOIN Usuarios Mestre ON C.id_mestre = Mestre.id_usuario
-- Junta com a tabela de ligação para encontrar os IDs dos jogadores
JOIN Campanha_Jogadores CJ ON C.id_campanha = CJ.id_campanha
-- Junta novamente com a tabela de usuários para pegar os nomes dos Jogadores
JOIN Usuarios Jogador ON CJ.id_jogador = Jogador.id_usuario
WHERE C.id_campanha = 1;

CREATE TABLE IF NOT EXISTS Login (
    id INT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(200) NOT NULL,
    senha VARCHAR(200) NOT NULL,
    tipo_usuario ENUM('ambulancia', 'enfermeiro') NOT NULL DEFAULT 'enfermeiro',
    
);

-- Inserir alguns dados de exemplo nos setores
INSERT INTO setores_hospital (setor, capacidade_maxima, descricao) VALUES
('UTI', 20, 'Unidade de Terapia Intensiva'),
('Emergência', 30, 'Pronto Socorro'),
('Pediatria', 25, 'Ala Infantil'),
('Cardiologia', 15, 'Centro Cardíaco'),
('Ortopedia', 20, 'Centro Ortopédico');

-- Inserir alguns pacientes de exemplo
INSERT INTO pacientes (nome, data_nascimento, status) VALUES
('João Silva', '1980-05-15', 'internado'),
('Maria Santos', '1992-08-22', 'internado'),
('Pedro Oliveira', '1975-03-10', 'internado'),
('Ana Costa', '1988-12-03', 'internado');

-- Inserir alguns atendimentos
INSERT INTO atendimentos (paciente_id, data_entrada, data_saida, tipo_atendimento) VALUES
(1, CURRENT_DATE, NULL, 'Emergência'),
(2, CURRENT_DATE, DATE_ADD(CURRENT_DATE, INTERVAL 2 HOUR), 'Consulta'),
(3, CURRENT_DATE, NULL, 'Internação'),
(4, CURRENT_DATE, NULL, 'Emergência');

-- Inserir ocupações de leitos
INSERT INTO ocupacao_leitos (setor_id, paciente_id, data_registro) VALUES
(1, 1, CURRENT_TIMESTAMP),
(2, 2, CURRENT_TIMESTAMP),
(3, 3, CURRENT_TIMESTAMP),
(4, 4, CURRENT_TIMESTAMP);
