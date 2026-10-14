# Consultas da etapa 5

Proposta para discussão, baseada em `streaming_schema_v2.sql` e `sql/02_dados.sql` do repositório GabrielFRails/streaming-db-simulator, commit `213b2101a9db11c0737372e6d51fbcd2d2d49d93`. O schema e os dados originais foram preservados. As consultas são propostas para revisão do grupo.

| Consulta | Pergunta do domínio | Junções | Resultado com a carga original |
| --- | --- | --- | --- |
| Continuar assistindo | Que filmes ou episódios cada perfil pode retomar, e em qual minuto? | Histórico, perfil, assinante, plano, filme, episódio, temporada e mídia | 4 linhas |
| Minha Lista | Quais favoritos estão permitidos para o perfil, com seus gêneros e a nota dada por ele? | Favorito, perfil, assinante, mídia, mídia/gênero, gênero e avaliação | 10 linhas |
| Audiência por plano | Quais títulos tiveram sessões de reprodução em cada plano atual? | Histórico, perfil, assinante, plano, episódio, temporada e mídia | 11 grupos; 13 sessões; 8 concluídas |

## Escolhas para discussão

1. **Continuar assistindo:** seleciona a última sessão de cada item reproduzível (filme ou episódio), antes de filtrar sessões incompletas. Uma sessão antiga incompleta não reaparece quando a última já foi concluída. Empates de data usam o maior ID do histórico. Exige conta e plano ativos e classificação etária permitida. Retorna todos os perfis para a demonstração; uma consulta de perfil específico pode acrescentar `AND p.id_perfil = 1` ao WHERE. É por episódio, não apenas o último episódio da série.
2. **Minha Lista:** retorna favoritos de contas ativas que respeitam o controle parental. Preserva favoritos sem avaliação ou sem gênero com LEFT JOIN; a agregação reúne gêneros sem multiplicar as linhas. Recupera a lista salva, sem exigir plano ativo. Essa diferença para a reprodução é intencional e pode ser discutida.
3. **Audiência:** conta sessões, perfis distintos e sessões concluídas, agrupando episódios pela série. Inclui contas atualmente inativas e assinantes sem plano para manter o histórico completo. Usa o plano atual, pois não existe histórico de troca de plano no modelo. Não representa minutos efetivamente assistidos nem plano vigente na data da sessão. Considera todas as datas disponíveis, sem filtro de período.

## Exemplos de resultado

Continuar assistindo: Ana em Cidade de Vidro / Água Escura, minuto 27; Bruno em Além das Estrelas, minuto 68; Família em Arquivo Aurora / Frequência, minuto 21; Carla em Horizonte Final, minuto 73. Diego fica fora porque a conta está inativa e não tem plano.

Minha Lista: os dez favoritos originais, com uma linha por perfil/mídia. Arquivo Aurora na lista de Ana permanece com nota NULL, pois ela não avaliou essa mídia.

Audiência: Cidade de Vidro no plano Padrão soma duas sessões de um perfil; Arquivo Aurora no Premium soma duas sessões de um perfil. Código Sombrio também aparece no grupo Sem plano, com a sessão histórica de Diego.

## Como executar no ambiente Docker já existente

Na raiz do projeto, com o container do colega em execução:

```bash
docker compose exec -T postgres psql -U streaming -d streaming_db -v ON_ERROR_STOP=1 -f /scripts/03_consultas.sql
```

O `compose.yaml` já monta `sql/` em `/scripts`, então não é necessário recriar o volume ou recarregar os dados para executar este arquivo. No pgAdmin, abra o banco do projeto no Query Tool e execute `03_consultas.sql`. As três consultas são somente SELECT; podem ser executadas separadamente.

O Docker do projeto usa a porta 5432 por padrão. Se o servidor PostgreSQL nativo também estiver em execução nesse computador, configure outra porta para o container conforme o README do projeto. O comando `docker compose exec` acima executa dentro do container e não depende da porta publicada.

## Validação local

Executada primeiro em PostgreSQL nativo **18.6** e depois no container **PostgreSQL 16.15**, usando `postgres:16` e a carga original do colega. As três consultas foram executadas com `ON_ERROR_STOP=1` e retornaram 4, 10 e 11 linhas também no container. O ambiente possui 15 tabelas, 4 assinantes, 6 perfis, 7 mídias e 13 registros de reprodução. Os casos adicionais abaixo foram testados na transação isolada do servidor nativo; o teste no container verificou a carga original e as três consultas.

Na validação nativa, o schema original e os dados do projeto foram carregados em um schema temporário, dentro de uma transação no servidor local. A transação foi revertida ao final, e foi confirmada a ausência do schema temporário. Essa validação nativa não criou banco persistente. A validação Docker utilizou um container e um volume exclusivos do projeto, sem alterar bancos ou volumes existentes.

Verificados os resultados originais e casos adicionais: conclusão posterior remove sessão antiga da lista de continuidade; empate de data usa ID; conteúdo acima da classificação do perfil é excluído; favorito sem gênero e sem nota permanece; plano inativo impede retomada; vários episódios ou gêneros não inflam as contagens.
