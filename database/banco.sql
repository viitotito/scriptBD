\echo ' '
\echo '--- Resetando banco techlog_db ---'

\encoding UTF8

SET client_encoding = 'UTF8';

\set ON_ERROR_STOP on

DROP DATABASE IF EXISTS techlog_db;

CREATE DATABASE techlog_db;
\echo ' '
\echo '--- Conectando com techlog_db... ---'

-- Conectando ao banco de dados recém-criado
\connect techlog_db;

\echo '******** BANCO CONECTADO ********'
\echo ' '
\echo '       Criando as Tabelas...     '

-- Tabela de clientes
CREATE TABLE IF NOT EXISTS clientes (
  id              SERIAL       PRIMARY KEY,
  nome            VARCHAR(255) NOT NULL,
  contato         VARCHAR(255) NOT NULL,
  dataCriacao     TIMESTAMP    NOT NULL DEFAULT NOW()
);

-- Tabela de entregas
CREATE TABLE IF NOT EXISTS entregas (
  id              SERIAL       PRIMARY KEY,
  cliente_id      INT NOT NULL REFERENCES clientes,
  dataEntrega     DATE         NOT NULL,
  statusEntrega   VARCHAR(50)  NOT NULL,
  endereco        VARCHAR(255) NOT NULL,
  dataCriacao     TIMESTAMP    NOT NULL DEFAULT NOW()
);

-- Tabela de comprovantes
CREATE TABLE IF NOT EXISTS comprovantes (
  id              SERIAL       PRIMARY KEY,
  entrega_id      INT NOT NULL REFERENCES entregas,
  tipo            VARCHAR(100) NOT NULL,
  nomeArquivo     VARCHAR(255) NOT NULL,
  dataUpload      TIMESTAMP    NOT NULL DEFAULT NOW()
);

-- Tabela de mensagens_clientes
CREATE TABLE IF NOT EXISTS mensagens_clientes (
  id              SERIAL       PRIMARY KEY,
  cliente_id      INT NOT NULL REFERENCES clientes,
  dataMensagem    TIMESTAMP    NOT NULL DEFAULT NOW(),
  tipo            VARCHAR(100) NOT NULL,
  resumo          VARCHAR(255) NOT NULL
);

-- Tabela de sensores_IOT
CREATE TABLE IF NOT EXISTS sensores_IOT (
  id              SERIAL       PRIMARY KEY,
  veiculo_id      INT NOT NULL REFERENCES veiculos,
  horarioRegistro TIMESTAMP    NOT NULL DEFAULT NOW(),
  tipoDado        VARCHAR(100) NOT NULL,
  valor           VARCHAR(255) NOT NULL
);

-- Tabela de veiculos
CREATE TABLE IF NOT EXISTS veiculos (
  id              SERIAL       PRIMARY KEY,
  placa           VARCHAR(50)  NOT NULL,
  modelo          VARCHAR(100) NOT NULL,
  marca           VARCHAR(100) NOT NULL,
  ano             INT          NOT NULL,
  statusVeiculo   VARCHAR(50)  NOT NULL,
  dataCriacao     TIMESTAMP    NOT NULL DEFAULT NOW()     
);


\echo ' '
\echo '--- Tabelas criadas, inserindo dados... ---'

-- Inserção dados tabela clientes
INSERT INTO clientes (nome, contato) VALUES
('Maria Silva', 'maria.silva@example.com'),
('João Pereira', 'joao.pereira@example.com'),
('Ana Costa', 'ana.costa@example.com'),
('Carlos Oliveira', 'carlos.oliveira@example.com'),
('Fernanda Ramos', 'fernanda.ramos@example.com'),
('Ricardo Santos', 'ricardo.santos@example.com'),
('Patrícia Gomes', 'patricia.gomes@example.com'),
('Luiz Carvalho', 'luiz.carvalho@example.com'),
('Beatriz Souza', 'beatriz.souza@example.com'),
('Marcos Almeida', 'marcos.almeida@example.com');

-- Inserção dados tabela veiculos
INSERT INTO veiculos (placa, modelo, marca, ano, statusVeiculo) VALUES
('ABC1A23', 'Fiorino', 'Fiat', 2018, 'ativo'),
('DEF4B56', 'Sprinter', 'Mercedes', 2020, 'ativo'),
('GHI7C89', 'Ducato', 'Fiat', 2019, 'manutenção'),
('JKL0D12', 'Master', 'Renault', 2017, 'ativo'),
('MNO3E45', 'HR', 'Hyundai', 2021, 'ativo'),
('PQR6F78', 'Daily', 'Iveco', 2016, 'inativo'),
('STU9G01', 'Kangoo', 'Renault', 2018, 'ativo'),
('VWX2H34', 'Partner', 'Peugeot', 2019, 'ativo'),
('YZA5J67', 'Transit', 'Ford', 2020, 'manutenção'),
('BCD8K90', 'S10', 'Chevrolet', 2022, 'ativo');

-- Inserção dados tabela entregas
INSERT INTO entregas (cliente_id, dataEntrega, statusEntrega, endereco) VALUES
(1, '2025-01-10', 'pendente', 'Rua A, 100'),
(2, '2025-01-11', 'concluído', 'Rua B, 200'),
(3, '2025-01-12', 'pendente', 'Rua C, 300'),
(4, '2025-01-13', 'concluído', 'Rua D, 400'),
(5, '2025-01-14', 'pendente', 'Rua E, 500'),
(6, '2025-01-15', 'pendente', 'Rua F, 600'),
(7, '2025-01-16', 'concluído', 'Rua G, 700'),
(8, '2025-01-17', 'pendente', 'Rua H, 800'),
(9, '2025-01-18', 'concluído', 'Rua I, 900'),
(10, '2025-01-19', 'pendente', 'Rua J, 1000');

-- Inserção dados tabela comprovantes
INSERT INTO comprovantes (entrega_id, tipo, nomeArquivo) VALUES
(1, 'foto', 'comp_1.jpg'),
(2, 'assinatura', 'comp_2.png'),
(3, 'documento', 'comp_3.pdf'),
(4, 'foto', 'comp_4.jpg'),
(5, 'assinatura', 'comp_5.png'),
(6, 'foto', 'comp_6.jpg'),
(7, 'documento', 'comp_7.pdf'),
(8, 'foto', 'comp_8.jpg'),
(9, 'assinatura', 'comp_9.png'),
(10, 'foto', 'comp_10.jpg');

-- Inserção dados tabela mensagens_clientes
INSERT INTO mensagens_clientes (cliente_id, tipo, resumo) VALUES
(1, 'texto', 'Solicitando atualização da entrega'),
(2, 'áudio', 'Cliente enviou instruções adicionais'),
(3, 'texto', 'Confirmação de recebimento'),
(4, 'texto', 'Reclamação sobre atraso'),
(5, 'áudio', 'Endereço corrigido'),
(6, 'texto', 'Pedido de remarcação'),
(7, 'texto', 'Agradecimento pelo serviço'),
(8, 'áudio', 'Cliente enviou anexos'),
(9, 'texto', 'Dúvida sobre horário'),
(10, 'texto', 'Solicitação de nota fiscal');

-- Inserção dados sensores_iot
INSERT INTO sensores_IOT (veiculo_id, tipoDado, valor) VALUES
(1, 'temperatura', '32.5°C'),
(2, 'vibração', '0.8g'),
(3, 'temperatura', '28.1°C'),
(4, 'localização', '-22.90,-43.20'),
(5, 'umidade', '51%'),
(6, 'temperatura', '30.2°C'),
(7, 'vibração', '1.1g'),
(8, 'localização', '-22.88,-43.23'),
(9, 'temperatura', '29.7°C'),
(10, 'umidade', '49%');


\echo '@@@@@@@ DADOS INSERIDOS COM SUCESSO @@@@@@@'
\echo ' '