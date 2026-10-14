-- Etapa 5: três consultas de recuperação de informação no streaming.
-- Compatíveis com streaming_schema_v2.sql. Somente leitura.

-- 1. Continuar assistindo: última sessão de cada filme/episódio por perfil.
-- Uma sessão antiga incompleta não reaparece após uma sessão concluída.
-- Considera conta ativa, plano ativo e classificação permitida pelo perfil.
WITH ultima_reproducao AS (
    SELECT h.*,
           ROW_NUMBER() OVER (
               PARTITION BY h.id_perfil, h.id_filme, h.id_episodio
               ORDER BY h.data_hora DESC, h.id_historico DESC
           ) AS ordem
    FROM historico_reproducao AS h
)
SELECT p.id_perfil,
       p.nome_perfil,
       m.id_midia,
       m.titulo AS titulo_midia,
       m.tipo,
       t.numero_temporada,
       e.numero_episodio,
       e.titulo AS titulo_episodio,
       h.minuto_parada,
       COALESCE(f.duracao_min, e.duracao_min) AS duracao_min,
       h.data_hora AS ultima_reproducao
FROM ultima_reproducao AS h
JOIN perfil AS p ON p.id_perfil = h.id_perfil
JOIN assinante AS a ON a.id_assinante = p.id_assinante
JOIN plano AS pl ON pl.id_plano = a.id_plano
LEFT JOIN filme AS f ON f.id_midia = h.id_filme
LEFT JOIN episodio AS e ON e.id_episodio = h.id_episodio
LEFT JOIN temporada AS t ON t.id_temporada = e.id_temporada
JOIN midia AS m ON m.id_midia = COALESCE(f.id_midia, t.id_midia)
WHERE h.ordem = 1
  AND NOT h.concluido
  AND a.status_conta = 'ATIVA'
  AND pl.ativo
  AND m.classificacao_etaria <= p.classificacao_maxima
ORDER BY p.id_perfil, h.data_hora DESC, h.id_historico DESC;

-- 2. Minha Lista: favoritos permitidos, com gêneros e nota do próprio perfil.
-- LEFT JOIN preserva favoritos sem avaliação ou gênero cadastrado.
-- A agregação mantém uma linha por favorito, mesmo com vários gêneros.
SELECT p.id_perfil,
       p.nome_perfil,
       m.id_midia,
       m.titulo,
       m.tipo,
       m.classificacao_etaria,
       STRING_AGG(g.nome, ', ' ORDER BY g.nome) AS generos,
       av.nota AS nota_do_perfil,
       fv.data_adicao
FROM favorito AS fv
JOIN perfil AS p ON p.id_perfil = fv.id_perfil
JOIN assinante AS a ON a.id_assinante = p.id_assinante
JOIN midia AS m ON m.id_midia = fv.id_midia
LEFT JOIN midia_genero AS mg ON mg.id_midia = m.id_midia
LEFT JOIN genero AS g ON g.id_genero = mg.id_genero
LEFT JOIN avaliacao AS av
       ON av.id_perfil = fv.id_perfil AND av.id_midia = fv.id_midia
WHERE a.status_conta = 'ATIVA'
  AND m.classificacao_etaria <= p.classificacao_maxima
GROUP BY p.id_perfil, p.nome_perfil, m.id_midia, m.titulo, m.tipo,
         m.classificacao_etaria, av.nota, fv.data_adicao
ORDER BY p.id_perfil, fv.data_adicao DESC, m.id_midia;

-- 3. Audiência por plano atual e mídia: sessões, perfis e conclusões.
-- Episódios são associados à mídia da série pela temporada.
-- LEFT JOIN plano inclui histórico de assinantes atualmente sem plano.
SELECT pl.id_plano,
       COALESCE(pl.nome, 'Sem plano') AS plano_atual,
       m.id_midia,
       m.titulo,
       m.tipo,
       COUNT(*) AS sessoes_reproducao,
       COUNT(DISTINCT p.id_perfil) AS perfis_distintos,
       COUNT(*) FILTER (WHERE h.concluido) AS sessoes_concluidas
FROM historico_reproducao AS h
JOIN perfil AS p ON p.id_perfil = h.id_perfil
JOIN assinante AS a ON a.id_assinante = p.id_assinante
LEFT JOIN plano AS pl ON pl.id_plano = a.id_plano
LEFT JOIN episodio AS e ON e.id_episodio = h.id_episodio
LEFT JOIN temporada AS t ON t.id_temporada = e.id_temporada
JOIN midia AS m ON m.id_midia = COALESCE(h.id_filme, t.id_midia)
GROUP BY pl.id_plano, pl.nome, m.id_midia, m.titulo, m.tipo
ORDER BY pl.id_plano NULLS LAST, sessoes_reproducao DESC, m.id_midia;
