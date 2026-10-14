# Streaming DB Simulator

Trabalho prático em grupo da disciplina de Banco de Dados 2 da Universidade Federal de Goiás (UFG).

## Descrição geral do problema

Plataformas de streaming precisam gerenciar um grande volume de informações relacionadas aos seus usuários, planos de assinatura, perfis e conteúdos disponíveis no catálogo. Além do armazenamento dos filmes e séries, o sistema deve organizar esses conteúdos em gêneros, temporadas e episódios, bem como registrar os profissionais envolvidos em suas produções.

Também é necessário controlar as interações realizadas pelos usuários na plataforma, como a reprodução de conteúdos, a adição de títulos aos favoritos e a realização de avaliações.

Cada assinante pode possuir diferentes perfis, e cada perfil pode assistir, avaliar e favoritar títulos distintos.

## Produto a ser desenvolvido

Como solução para o problema apresentado, será desenvolvido um sistema de streaming de conteúdo audiovisual.

O sistema permitirá que um usuário assine um plano e possua diferentes perfis, cada um com suas próprias preferências e interações. O catálogo será composto por filmes e séries, organizados por gêneros. As séries serão divididas em temporadas e episódios. Também serão armazenadas informações sobre os artistas e demais profissionais participantes das produções.

Durante o uso da plataforma, o sistema permitirá que os perfis assistam aos conteúdos, adicionem títulos aos favoritos e realizem avaliações. Todas essas informações serão armazenadas em um banco de dados, garantindo a integridade e a organização dos dados para suportar as funcionalidades da aplicação.

## Escopo do sistema

- Gerenciamento de assinantes e planos de assinatura.
- Criação e gerenciamento de perfis.
- Cadastro e organização de filmes e séries.
- Classificação de títulos por gêneros.
- Organização de séries em temporadas e episódios.
- Registro de artistas e participação em produções.
- Controle das interações dos perfis na plataforma: reprodução, favoritos e avaliações.

O trabalho tem como foco a modelagem e o armazenamento das informações necessárias para essas funcionalidades. Neste momento, o escopo não contempla processamento financeiro de pagamentos, mecanismos avançados de recomendação ou funcionalidades de download.

## Módulos do sistema

### Assinatura e acesso

| Entidade | Descrição e informações armazenadas |
| --- | --- |
| `Assinante` | Dados pessoais, como CPF, e-mail de login e status da conta (ativa/inativa). |
| `Plano` | Preço, resolução máxima e limite de telas simultâneas. |
| `Perfil` | Nome do perfil, avatar e classificação indicativa máxima permitida (controle parental). |

### Conteúdo

| Entidade | Descrição e informações armazenadas |
| --- | --- |
| `Titulo` | Conjunto maior: título, ano de lançamento, sinopse e classificação etária. |
| `Filme` | Subconjunto de `Titulo`: duração e URL/arquivo de streaming. |
| `Serie` | Subconjunto de `Titulo`: emissora/produtora original. |
| `Temporada` | Pertence a uma `Serie` e armazena o número da temporada. |
| `Episodio` | Pertence a uma `Temporada`: número do episódio, título, duração e URL/arquivo. |
| `Genero` | Gêneros como Ação, Drama e Comédia, com relação N:N com `Titulo`. |

### Pessoal e produção

| Entidade | Descrição e informações armazenadas |
| --- | --- |
| `Artista` | Nome, data de nascimento e nacionalidade. |
| `Credito_Producao` | Entidade associativa N:N entre `Titulo` e `Artista`, armazenando papel e personagem. |

### Interação e métricas

| Entidade | Descrição e informações armazenadas |
| --- | --- |
| `Historico_Reproducao` | Entidade associativa entre `Perfil` e a mídia reproduzida, armazenando `minuto_parada`, `concluido` e `data_hora`. |
| `Avaliacao` | Associação entre `Perfil` e `Titulo`, armazenando nota de 1 a 5 e `comentario`. |
| `Favorito` / `Minha_Lista` | Associação entre `Perfil` e `Titulo`, armazenando a data em que o título foi salvo. |

## Modelagem do banco de dados

### Modelo entidade-relacionamento

![Modelo entidade-relacionamento do sistema de streaming](modelo_entidade_relacionamento.png)

### Modelo relacional

![Modelo relacional do sistema de streaming](modelo_relacional.jpeg)
