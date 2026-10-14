-- 1. Quantos assinantes e perfis existem em cada plano atual?
SELECT COALESCE(pl.nome, 'Sem plano') AS plano,
       COUNT(DISTINCT a.id_assinante) AS assinantes,
       COUNT(p.id_perfil) AS perfis
FROM assinante a
LEFT JOIN plano pl ON pl.id_plano = a.id_plano
LEFT JOIN perfil p ON p.id_assinante = a.id_assinante
GROUP BY pl.id_plano, pl.nome
ORDER BY pl.id_plano NULLS LAST;

-- 2. Quantos favoritos estão salvos nos perfis de cada assinante?
SELECT a.nome AS assinante,
       COUNT(f.id_midia) AS favoritos
FROM assinante a
LEFT JOIN perfil p ON p.id_assinante = a.id_assinante
LEFT JOIN favorito f ON f.id_perfil = p.id_perfil
GROUP BY a.id_assinante, a.nome
ORDER BY a.nome;

-- 3. Quantas sessões de reprodução cada assinante fez?
SELECT a.nome AS assinante,
       COUNT(h.id_historico) AS reproducoes
FROM assinante a
LEFT JOIN perfil p ON p.id_assinante = a.id_assinante
LEFT JOIN historico_reproducao h ON h.id_perfil = p.id_perfil
GROUP BY a.id_assinante, a.nome
ORDER BY reproducoes DESC, a.nome;
