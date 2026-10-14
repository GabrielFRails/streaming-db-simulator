-- =====================================================================
-- Plataforma de Streaming - Dados de demonstração
-- Este arquivo pode ser executado novamente sem duplicar os registros.
-- =====================================================================

BEGIN;

TRUNCATE TABLE
    historico_reproducao,
    avaliacao,
    favorito,
    credito_producao,
    midia_genero,
    episodio,
    temporada,
    filme,
    serie,
    artista,
    genero,
    perfil,
    assinante,
    plano,
    midia
RESTART IDENTITY CASCADE;

INSERT INTO plano
    (id_plano, nome, descricao, preco, resolucao_maxima, limite_telas, ativo)
VALUES
    (1, 'Básico',  'Uma tela em alta definição',             19.90, 'HD',  1, TRUE),
    (2, 'Padrão',  'Duas telas em resolução Full HD',         32.90, 'FHD', 2, TRUE),
    (3, 'Premium', 'Quatro telas com resolução Ultra HD 4K',  45.90, '4K',  4, TRUE);

INSERT INTO assinante
    (id_assinante, id_plano, nome, cpf, data_nascimento, email_login,
     senha_hash, telefone, data_cadastro, status_conta)
VALUES
    (1, 2,    'Ana Martins',   '11111111111', '1994-03-12', 'ana@example.com',
     'hash_demo_ana',   '62999990001', '2025-01-10 09:00:00', 'ATIVA'),
    (2, 3,    'Bruno Oliveira','22222222222', '1988-07-21', 'bruno@example.com',
     'hash_demo_bruno', '62999990002', '2025-02-05 14:30:00', 'ATIVA'),
    (3, 1,    'Carla Souza',   '33333333333', '2000-11-08', 'carla@example.com',
     'hash_demo_carla', '62999990003', '2025-03-18 18:20:00', 'ATIVA'),
    (4, NULL, 'Diego Lima',    '44444444444', '1997-05-30', 'diego@example.com',
     'hash_demo_diego', NULL,          '2025-04-02 11:10:00', 'INATIVA');

INSERT INTO perfil
    (id_perfil, id_assinante, nome_perfil, avatar, classificacao_maxima,
     idioma_preferido, data_criacao)
VALUES
    (1, 1, 'Ana',      'avatar-ana.png',      18, 'pt-BR', '2025-01-10 09:10:00'),
    (2, 1, 'Crianças', 'avatar-kids.png',     10, 'pt-BR', '2025-01-10 09:15:00'),
    (3, 2, 'Bruno',    'avatar-bruno.png',    18, 'pt-BR', '2025-02-05 14:35:00'),
    (4, 2, 'Família',  'avatar-familia.png',  12, 'pt-BR', '2025-02-05 14:40:00'),
    (5, 3, 'Carla',    'avatar-carla.png',    16, 'pt-BR', '2025-03-18 18:25:00'),
    (6, 4, 'Diego',    'avatar-diego.png',    18, 'pt-BR', '2025-04-02 11:15:00');

INSERT INTO midia
    (id_midia, tipo, titulo, titulo_original, ano_lancamento, sinopse,
     classificacao_etaria, idioma_original, pais_origem, poster_url, data_cadastro)
VALUES
    (1, 'F', 'Horizonte Final',       'Final Horizon',       2024,
     'Uma equipe atravessa o oceano em busca de uma nova fonte de energia.',
     12, 'en-US', 'Estados Unidos', 'horizonte-final.jpg', '2025-01-02 10:00:00'),
    (2, 'F', 'Código Sombrio',        'Dark Code',           2023,
     'Uma programadora encontra uma mensagem escondida em um sistema antigo.',
     16, 'en-US', 'Canadá', 'codigo-sombrio.jpg', '2025-01-03 10:00:00'),
    (3, 'F', 'Riso Solto',            'Riso Solto',          2022,
     'Amigos tentam salvar o pequeno teatro de seu bairro.',
     10, 'pt-BR', 'Brasil', 'riso-solto.jpg', '2025-01-04 10:00:00'),
    (4, 'F', 'Além das Estrelas',     'Beyond the Stars',    2025,
     'Cientistas recebem um sinal vindo de fora do sistema solar.',
     12, 'en-US', 'Reino Unido', 'alem-das-estrelas.jpg', '2025-02-01 10:00:00'),
    (5, 'S', 'Cidade de Vidro',       'Cidade de Vidro',     2024,
     'Moradores investigam acontecimentos incomuns em uma cidade litorânea.',
     14, 'pt-BR', 'Brasil', 'cidade-de-vidro.jpg', '2025-01-05 10:00:00'),
    (6, 'S', 'Arquivo Aurora',        'Aurora Files',        2025,
     'Uma equipe científica estuda fenômenos luminosos no extremo norte.',
     12, 'en-US', 'Canadá', 'arquivo-aurora.jpg', '2025-02-10 10:00:00'),
    (7, 'S', 'Pequenos Exploradores', 'Little Explorers',    2023,
     'Crianças viajam pelo mundo aprendendo sobre ciência e natureza.',
     0, 'pt-BR', 'Brasil', 'pequenos-exploradores.jpg', '2025-01-06 10:00:00');

INSERT INTO filme (id_midia, duracao_min, url_streaming)
VALUES
    (1, 118, 'https://stream.example/filmes/1'),
    (2, 105, 'https://stream.example/filmes/2'),
    (3,  96, 'https://stream.example/filmes/3'),
    (4, 132, 'https://stream.example/filmes/4');

INSERT INTO serie (id_midia, emissora_produtora, status_producao)
VALUES
    (5, 'Estúdio Cerrado', 'EM_ANDAMENTO'),
    (6, 'Northlight',      'EM_ANDAMENTO'),
    (7, 'Mundo Curioso',   'FINALIZADA');

INSERT INTO temporada
    (id_temporada, id_midia, numero_temporada, nome, ano_lancamento)
VALUES
    (1, 5, 1, 'Maré Alta',       2024),
    (2, 5, 2, 'Novos Reflexos',  2025),
    (3, 6, 1, 'Primeiro Sinal',  2025),
    (4, 7, 1, 'Volta ao Mundo',  2023);

INSERT INTO episodio
    (id_episodio, id_temporada, numero_episodio, titulo, sinopse,
     duracao_min, url_streaming, data_estreia)
VALUES
    (1, 1, 1, 'O Farol',          'Uma luz reaparece depois de décadas.',          48, 'https://stream.example/episodios/1', '2024-04-05'),
    (2, 1, 2, 'Água Escura',      'A equipe encontra marcas sob o cais.',          51, 'https://stream.example/episodios/2', '2024-04-12'),
    (3, 2, 1, 'O Retorno',        'Um antigo morador traz novas pistas.',           50, 'https://stream.example/episodios/3', '2025-05-02'),
    (4, 2, 2, 'Reflexos',         'As pistas apontam para o centro da cidade.',     53, 'https://stream.example/episodios/4', '2025-05-09'),
    (5, 3, 1, 'Luzes no Céu',     'A equipe registra o primeiro fenômeno.',         44, 'https://stream.example/episodios/5', '2025-06-07'),
    (6, 3, 2, 'Frequência',       'Um padrão é encontrado nos sinais captados.',   46, 'https://stream.example/episodios/6', '2025-06-14'),
    (7, 4, 1, 'Floresta Tropical','Os exploradores conhecem a biodiversidade.',    24, 'https://stream.example/episodios/7', '2023-08-10'),
    (8, 4, 2, 'Fundo do Mar',     'Uma viagem mostra diferentes animais marinhos.',25, 'https://stream.example/episodios/8', '2023-08-17');

INSERT INTO genero (id_genero, nome, descricao)
VALUES
    (1, 'Drama',            'Narrativas centradas em conflitos humanos.'),
    (2, 'Ficção científica','Histórias baseadas em ciência e tecnologia.'),
    (3, 'Suspense',         'Tramas construídas em torno de mistério e tensão.'),
    (4, 'Comédia',          'Obras voltadas ao humor.'),
    (5, 'Família',          'Conteúdo adequado para toda a família.'),
    (6, 'Aventura',         'Jornadas, descobertas e exploração.');

INSERT INTO midia_genero (id_midia, id_genero)
VALUES
    (1, 1), (1, 6),
    (2, 2), (2, 3),
    (3, 4), (3, 5),
    (4, 1), (4, 2), (4, 6),
    (5, 1), (5, 3),
    (6, 2), (6, 3),
    (7, 5), (7, 6);

INSERT INTO artista
    (id_artista, nome, nome_artistico, data_nascimento, nacionalidade, biografia, foto_url)
VALUES
    (1, 'Marina Alves',    NULL,          '1987-02-14', 'Brasileira', 'Atriz de cinema e televisão.',       'marina-alves.jpg'),
    (2, 'Rafael Nogueira', NULL,          '1979-09-03', 'Brasileira', 'Diretor e roteirista.',               'rafael-nogueira.jpg'),
    (3, 'Lucas Ferraz',    'Luca Ferraz', '1990-06-18', 'Brasileira', 'Ator e comediante.',                  'lucas-ferraz.jpg'),
    (4, 'Emily Carter',    NULL,          '1985-12-01', 'Canadense',  'Atriz canadense.',                    'emily-carter.jpg'),
    (5, 'Noah Williams',   NULL,          '1976-04-22', 'Britânica',  'Diretor especializado em ficção.',   'noah-williams.jpg'),
    (6, 'Júlia Campos',    NULL,          '1995-08-09', 'Brasileira', 'Atriz e apresentadora.',              'julia-campos.jpg'),
    (7, 'Miguel Santos',   NULL,          '1982-10-27', 'Brasileira', 'Ator de teatro e televisão.',         'miguel-santos.jpg'),
    (8, 'Sofia Mendes',    NULL,          '2008-01-16', 'Brasileira', 'Atriz e narradora juvenil.',          'sofia-mendes.jpg'),
    (9, 'Oliver Brown',    NULL,          '1989-03-11', 'Canadense',  'Ator e produtor.',                    'oliver-brown.jpg');

INSERT INTO credito_producao
    (id_midia, id_artista, papel, personagem, ordem_credito)
VALUES
    (1, 4, 'Ator',       'Dra. Helen Ward', 1),
    (1, 5, 'Diretor',    NULL,              1),
    (2, 4, 'Ator',       'Maya Reed',       1),
    (2, 9, 'Ator',       'Ethan Cole',      2),
    (2, 5, 'Diretor',    NULL,              1),
    (3, 3, 'Ator',       'Caio',            1),
    (3, 2, 'Diretor',    NULL,              1),
    (4, 9, 'Ator',       'Dr. Owen Clark',  1),
    (4, 5, 'Diretor',    NULL,              1),
    (5, 1, 'Ator',       'Laura',           1),
    (5, 7, 'Ator',       'André',           2),
    (5, 2, 'Diretor',    NULL,              1),
    (6, 4, 'Ator',       'Sarah North',     1),
    (6, 9, 'Ator',       'Mark Evans',      2),
    (6, 5, 'Diretor',    NULL,              1),
    (7, 6, 'Apresentador','Júlia',          1),
    (7, 8, 'Narrador',   NULL,              2);

INSERT INTO historico_reproducao
    (id_historico, id_perfil, id_filme, id_episodio, minuto_parada,
     concluido, data_hora, dispositivo)
VALUES
    (1,  1, 1,    NULL, 118, TRUE,  '2026-09-20 20:10:00', 'TV'),
    (2,  1, NULL, 1,     48, TRUE,  '2026-09-22 21:00:00', 'TV'),
    (3,  1, NULL, 2,     27, FALSE, '2026-09-23 21:15:00', 'Celular'),
    (4,  2, 3,    NULL,  96, TRUE,  '2026-09-21 15:30:00', 'Tablet'),
    (5,  2, NULL, 7,     24, TRUE,  '2026-09-24 16:00:00', 'Tablet'),
    (6,  3, 2,    NULL, 105, TRUE,  '2026-09-25 22:00:00', 'Web'),
    (7,  3, 4,    NULL,  68, FALSE, '2026-09-27 22:20:00', 'TV'),
    (8,  3, NULL, 4,     53, TRUE,  '2026-09-28 19:40:00', 'TV'),
    (9,  4, NULL, 5,     44, TRUE,  '2026-09-26 18:30:00', 'TV'),
    (10, 4, NULL, 6,     21, FALSE, '2026-09-27 18:45:00', 'TV'),
    (11, 5, 1,    NULL,  73, FALSE, '2026-09-29 20:05:00', 'Celular'),
    (12, 5, NULL, 3,     50, TRUE,  '2026-10-01 21:10:00', 'Notebook'),
    (13, 6, 2,    NULL,  32, FALSE, '2026-04-03 10:00:00', 'Web');

INSERT INTO avaliacao
    (id_perfil, id_midia, nota, comentario, data_avaliacao)
VALUES
    (1, 1, 5, 'Aventura emocionante.',              '2026-09-20 22:15:00'),
    (1, 5, 4, 'Ótimo começo de série.',             '2026-09-23 22:00:00'),
    (2, 3, 5, 'Muito divertido.',                   '2026-09-21 17:15:00'),
    (2, 7, 5, 'Aprendi bastante.',                  '2026-09-24 16:30:00'),
    (3, 2, 4, 'Bom suspense e boas atuações.',      '2026-09-26 00:10:00'),
    (3, 4, 5, 'Visual impressionante.',             '2026-09-28 01:00:00'),
    (3, 5, 4, 'A segunda temporada melhorou.',      '2026-09-28 20:45:00'),
    (4, 6, 4, 'Interessante para assistir em grupo.','2026-09-27 19:30:00'),
    (5, 1, 4, 'Boa história.',                      '2026-09-29 22:10:00'),
    (5, 5, 5, 'Minha série favorita.',              '2026-10-01 22:05:00');

INSERT INTO favorito (id_perfil, id_midia, data_adicao)
VALUES
    (1, 1, '2026-09-18 10:00:00'),
    (1, 5, '2026-09-18 10:05:00'),
    (1, 6, '2026-09-25 09:00:00'),
    (2, 3, '2026-09-19 11:00:00'),
    (2, 7, '2026-09-19 11:05:00'),
    (3, 2, '2026-09-20 12:00:00'),
    (3, 4, '2026-09-20 12:05:00'),
    (4, 6, '2026-09-21 13:00:00'),
    (5, 1, '2026-09-22 14:00:00'),
    (5, 5, '2026-09-22 14:05:00');

-- Sincroniza as sequências após a inserção de identificadores explícitos.
SELECT setval(pg_get_serial_sequence('plano', 'id_plano'),
              (SELECT MAX(id_plano) FROM plano));
SELECT setval(pg_get_serial_sequence('assinante', 'id_assinante'),
              (SELECT MAX(id_assinante) FROM assinante));
SELECT setval(pg_get_serial_sequence('perfil', 'id_perfil'),
              (SELECT MAX(id_perfil) FROM perfil));
SELECT setval(pg_get_serial_sequence('midia', 'id_midia'),
              (SELECT MAX(id_midia) FROM midia));
SELECT setval(pg_get_serial_sequence('temporada', 'id_temporada'),
              (SELECT MAX(id_temporada) FROM temporada));
SELECT setval(pg_get_serial_sequence('episodio', 'id_episodio'),
              (SELECT MAX(id_episodio) FROM episodio));
SELECT setval(pg_get_serial_sequence('genero', 'id_genero'),
              (SELECT MAX(id_genero) FROM genero));
SELECT setval(pg_get_serial_sequence('artista', 'id_artista'),
              (SELECT MAX(id_artista) FROM artista));
SELECT setval(pg_get_serial_sequence('historico_reproducao', 'id_historico'),
              (SELECT MAX(id_historico) FROM historico_reproducao));

COMMIT;
