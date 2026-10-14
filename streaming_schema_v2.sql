-- =====================================================================
-- Plataforma de Streaming - Modelo Físico (PostgreSQL)
-- A superclasse "midia" é especializada de forma total e disjunta
-- em filme ou série. O histórico liga o perfil diretamente a filme/episódio.
-- Importar no DrawSQL: New Diagram > Import > SQL (dialeto PostgreSQL)
-- =====================================================================

-- ---------------------------------------------------------------------
-- MÓDULO DE ASSINATURA E ACESSO
-- ---------------------------------------------------------------------

CREATE TABLE plano (
    id_plano            SERIAL PRIMARY KEY,
    nome                VARCHAR(50)    NOT NULL UNIQUE,
    descricao           VARCHAR(255),
    preco               NUMERIC(8,2)   NOT NULL CHECK (preco >= 0),
    resolucao_maxima    VARCHAR(10)    NOT NULL
                        CHECK (resolucao_maxima IN ('SD', 'HD', 'FHD', '4K')),
    limite_telas        SMALLINT       NOT NULL CHECK (limite_telas > 0),
    ativo               BOOLEAN        NOT NULL DEFAULT TRUE
);

CREATE TABLE assinante (
    id_assinante        SERIAL PRIMARY KEY,
    id_plano            INTEGER,
    nome                VARCHAR(100)   NOT NULL,
    cpf                 CHAR(11)       NOT NULL UNIQUE,
    data_nascimento     DATE           NOT NULL,
    email_login         VARCHAR(150)   NOT NULL UNIQUE,
    senha_hash          VARCHAR(255)   NOT NULL,
    telefone            VARCHAR(20),
    data_cadastro       TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status_conta        VARCHAR(10)    NOT NULL DEFAULT 'ATIVA'
                        CHECK (status_conta IN ('ATIVA', 'INATIVA')),
    CONSTRAINT fk_assinante_plano
        FOREIGN KEY (id_plano) REFERENCES plano (id_plano)
);

CREATE TABLE perfil (
    id_perfil            SERIAL PRIMARY KEY,
    id_assinante         INTEGER       NOT NULL,
    nome_perfil          VARCHAR(50)   NOT NULL,
    avatar               VARCHAR(255),
    classificacao_maxima SMALLINT      NOT NULL DEFAULT 18
                         CHECK (classificacao_maxima IN (0, 10, 12, 14, 16, 18)),
    idioma_preferido     VARCHAR(10)   NOT NULL DEFAULT 'pt-BR',
    data_criacao         TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_perfil_assinante
        FOREIGN KEY (id_assinante) REFERENCES assinante (id_assinante)
        ON DELETE CASCADE,
    CONSTRAINT uq_perfil_assinante_nome UNIQUE (id_assinante, nome_perfil)
);

-- ---------------------------------------------------------------------
-- MÓDULO DE CONTEÚDO
-- ---------------------------------------------------------------------

-- Superclasse (especialização total e disjunta: Filme ou Série)
CREATE TABLE midia (
    id_midia             SERIAL PRIMARY KEY,
    tipo                 CHAR(1)       NOT NULL CHECK (tipo IN ('F', 'S')),  -- F = Filme, S = Série
    titulo               VARCHAR(150)  NOT NULL,
    titulo_original      VARCHAR(150),
    ano_lancamento       SMALLINT      NOT NULL CHECK (ano_lancamento >= 1888),
    sinopse              TEXT,
    classificacao_etaria SMALLINT      NOT NULL
                         CHECK (classificacao_etaria IN (0, 10, 12, 14, 16, 18)),
    idioma_original      VARCHAR(10),
    pais_origem          VARCHAR(50),
    poster_url           VARCHAR(255),
    data_cadastro        TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE filme (
    id_midia            INTEGER PRIMARY KEY,
    duracao_min         INTEGER        NOT NULL CHECK (duracao_min > 0),
    url_streaming       VARCHAR(255)   NOT NULL,
    CONSTRAINT fk_filme_midia
        FOREIGN KEY (id_midia) REFERENCES midia (id_midia)
        ON DELETE CASCADE
);

CREATE TABLE serie (
    id_midia            INTEGER PRIMARY KEY,
    emissora_produtora  VARCHAR(100)   NOT NULL,
    status_producao     VARCHAR(15)    NOT NULL DEFAULT 'EM_ANDAMENTO'
                        CHECK (status_producao IN ('EM_ANDAMENTO', 'FINALIZADA', 'CANCELADA')),
    CONSTRAINT fk_serie_midia
        FOREIGN KEY (id_midia) REFERENCES midia (id_midia)
        ON DELETE CASCADE
);

CREATE TABLE temporada (
    id_temporada        SERIAL PRIMARY KEY,
    id_midia            INTEGER        NOT NULL,  -- id da série
    numero_temporada    SMALLINT       NOT NULL CHECK (numero_temporada > 0),
    nome                VARCHAR(100),
    ano_lancamento      SMALLINT       CHECK (ano_lancamento >= 1888),
    CONSTRAINT fk_temporada_serie
        FOREIGN KEY (id_midia) REFERENCES serie (id_midia)
        ON DELETE CASCADE,
    CONSTRAINT uq_temporada_serie_numero UNIQUE (id_midia, numero_temporada)
);

CREATE TABLE episodio (
    id_episodio         SERIAL PRIMARY KEY,
    id_temporada        INTEGER        NOT NULL,
    numero_episodio     SMALLINT       NOT NULL CHECK (numero_episodio > 0),
    titulo              VARCHAR(150)   NOT NULL,
    sinopse             TEXT,
    duracao_min         INTEGER        NOT NULL CHECK (duracao_min > 0),
    url_streaming       VARCHAR(255)   NOT NULL,
    data_estreia        DATE,
    CONSTRAINT fk_episodio_temporada
        FOREIGN KEY (id_temporada) REFERENCES temporada (id_temporada)
        ON DELETE CASCADE,
    CONSTRAINT uq_episodio_temporada_numero UNIQUE (id_temporada, numero_episodio)
);

CREATE TABLE genero (
    id_genero           SERIAL PRIMARY KEY,
    nome                VARCHAR(50)    NOT NULL UNIQUE,
    descricao           VARCHAR(255)
);

-- Relação N:N Mídia <-> Gênero
CREATE TABLE midia_genero (
    id_midia            INTEGER        NOT NULL,
    id_genero           INTEGER        NOT NULL,
    PRIMARY KEY (id_midia, id_genero),
    CONSTRAINT fk_midia_genero_midia
        FOREIGN KEY (id_midia) REFERENCES midia (id_midia)
        ON DELETE CASCADE,
    CONSTRAINT fk_midia_genero_genero
        FOREIGN KEY (id_genero) REFERENCES genero (id_genero)
);

-- ---------------------------------------------------------------------
-- MÓDULO DE PESSOAL E PRODUÇÃO
-- ---------------------------------------------------------------------

CREATE TABLE artista (
    id_artista          SERIAL PRIMARY KEY,
    nome                VARCHAR(100)   NOT NULL,
    nome_artistico      VARCHAR(100),
    data_nascimento     DATE,
    nacionalidade       VARCHAR(50),
    biografia           TEXT,
    foto_url            VARCHAR(255)
);

-- Relação N:N Mídia <-> Artista (guarda papel e personagem)
CREATE TABLE credito_producao (
    id_midia            INTEGER        NOT NULL,
    id_artista          INTEGER        NOT NULL,
    papel               VARCHAR(50)    NOT NULL,  -- ex.: 'Ator', 'Diretor', 'Roteirista'
    personagem          VARCHAR(100),             -- preenchido apenas para atores
    ordem_credito       SMALLINT,                 -- ordem de exibição nos créditos
    PRIMARY KEY (id_midia, id_artista, papel),
    CONSTRAINT fk_credito_midia
        FOREIGN KEY (id_midia) REFERENCES midia (id_midia)
        ON DELETE CASCADE,
    CONSTRAINT fk_credito_artista
        FOREIGN KEY (id_artista) REFERENCES artista (id_artista)
);

-- ---------------------------------------------------------------------
-- MÓDULO DE INTERAÇÃO E MÉTRICAS
-- ---------------------------------------------------------------------

-- Perfil assiste Filme OU Episódio (exatamente um dos dois é preenchido)
CREATE TABLE historico_reproducao (
    id_historico        SERIAL PRIMARY KEY,
    id_perfil           INTEGER        NOT NULL,
    id_filme            INTEGER,       -- referencia filme (id_midia)
    id_episodio         INTEGER,       -- referencia episodio
    minuto_parada       INTEGER        NOT NULL DEFAULT 0 CHECK (minuto_parada >= 0),
    concluido           BOOLEAN        NOT NULL DEFAULT FALSE,
    data_hora           TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    dispositivo         VARCHAR(30),   -- ex.: 'TV', 'Celular', 'Web'
    CONSTRAINT fk_historico_perfil
        FOREIGN KEY (id_perfil) REFERENCES perfil (id_perfil)
        ON DELETE CASCADE,
    CONSTRAINT fk_historico_filme
        FOREIGN KEY (id_filme) REFERENCES filme (id_midia),
    CONSTRAINT fk_historico_episodio
        FOREIGN KEY (id_episodio) REFERENCES episodio (id_episodio),
    CONSTRAINT ck_historico_filme_ou_episodio
        CHECK ((id_filme IS NOT NULL AND id_episodio IS NULL)
            OR (id_filme IS NULL AND id_episodio IS NOT NULL))
);

-- Perfil avalia Mídia (uma avaliação por perfil/mídia)
CREATE TABLE avaliacao (
    id_perfil           INTEGER        NOT NULL,
    id_midia            INTEGER        NOT NULL,
    nota                SMALLINT       NOT NULL CHECK (nota BETWEEN 1 AND 5),
    comentario          TEXT,
    data_avaliacao      TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_perfil, id_midia),
    CONSTRAINT fk_avaliacao_perfil
        FOREIGN KEY (id_perfil) REFERENCES perfil (id_perfil)
        ON DELETE CASCADE,
    CONSTRAINT fk_avaliacao_midia
        FOREIGN KEY (id_midia) REFERENCES midia (id_midia)
        ON DELETE CASCADE
);

-- Perfil favorita Mídia (Minha Lista)
CREATE TABLE favorito (
    id_perfil           INTEGER        NOT NULL,
    id_midia            INTEGER        NOT NULL,
    data_adicao         TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_perfil, id_midia),
    CONSTRAINT fk_favorito_perfil
        FOREIGN KEY (id_perfil) REFERENCES perfil (id_perfil)
        ON DELETE CASCADE,
    CONSTRAINT fk_favorito_midia
        FOREIGN KEY (id_midia) REFERENCES midia (id_midia)
        ON DELETE CASCADE
);
