# Índice do Vault

> Este é o índice mestre. Uma linha por nota — título, caminho e um gancho de 1 frase.
> O Claude lê SÓ este arquivo por padrão e abre uma nota específica apenas quando ela for relevante.
> Sempre que criar/renomear/apagar uma nota, atualize a linha correspondente aqui.
>
> **Carregamento de contexto por projeto:** ao trabalhar num projeto, comece por
> ⭐[[mapa-projetos]] — ele diz o hub a abrir, o repositório real no disco e as referências
> `sempre-considerar` daquele projeto. O **estado corrente** ("onde estamos agora") de cada
> projeto mora na seção `## Estado atual` do respectivo **hub**, não aqui — as linhas deste
> índice são só ganchos de 1 frase.
>
> ℹ️ **Vault-base:** este índice começa só com as notas de infraestrutura (processos de
> sync, manutenção, mapa de projetos vazio e template). Conforme criar clientes, projetos e
> referências, adicione a linha de cada nota na seção certa (ver "Como o Claude deve montar
> o `_INDEX.md`" no `CLAUDE.md`).

## Clientes
<!-- ainda sem notas — crie a primeira em clientes/ e adicione a linha aqui -->

## Processos
- [Manutenção do Vault](processos/manutencao-vault.md) — método editorial + regra de pesquisa proativa (pesquisar nas pastas antes de assumir/perguntar)
- [Enviar vault para o GitHub](processos/enviar-vault-github.md) — envio pull-first seguro (enviar-github.bat); conflito para e pede resolução
- [Receber vault do GitHub](processos/receber-vault-github.md) — pull seguro (commita local antes, não perde nada) + tarefa de sexta 12h e/ou sync 1x/dia ao abrir o Claude (hook SessionStart), ambos com aviso por e-mail se falhar
- [Tool-calling seguro na K.E.M.Y](processos/kemy-tool-calling-seguro.md) — passo a passo para validar tool-calls, nunca deixar `tool_call_id` sem resposta e não confundir erro de execução com erro de provider (nasceu do incidente 2026-09-23)

## Projetos
- [GreenFinance](projetos/greenfinance/greenfinance.md) — app PWA de controle financeiro pessoal, carteira de investimentos e conciliação bancária (Pluggy/extratos)
  - [GreenFinance — Onde os dados vivem](projetos/greenfinance/greenfinance-dados.md) — mapa de localização de dados, repositório, APIs, worker e armazenamento do GreenFinance
  - [GreenFinance — Detalhamento das páginas](projetos/greenfinance/greenfinance-paginas.md) — cada rota/tela em detalhe: seções da UI, dados lidos/escritos e cálculos
  - [GreenFinance — Arquitetura e Guia](projetos/greenfinance/greenfinance-arquitetura.md) — arquitetura local-first, gerenciamento de estado no useStore, conciliação bancária e guia de evolução
- [Nexus RPG](projetos/nexus-rpg/nexus-rpg.md) — motor e construtor de sistemas de RPG de mesa 100% offline, com editor visual de fichas e modos Mestre e Jogador
  - [Nexus RPG — Onde os dados vivem](projetos/nexus-rpg/nexus-rpg-dados.md) — mapa de localização de dados, repositório, chaves do LocalStorage e arquitetura de arquivos do Nexus RPG
  - [Nexus RPG — Detalhamento das telas](projetos/nexus-rpg/nexus-rpg-telas.md) — auth, 17 abas do Mestre, editor de fichas (21 blocos), suíte de campanha e modo Jogador, tela a tela
  - [Nexus RPG — Arquitetura e Guia](projetos/nexus-rpg/nexus-rpg-arquitetura.md) — funcionamento interno, motores de regras/dados, canvas de fichas e guia para futuras atualizações
  - [Nexus RPG — Planejamento](projetos/nexus-rpg/nexus-rpg-planejamento.md) — roadmap: checklist entregue vs. pendente, backlog priorizado por área e próximos passos
- [Role SP no trilho](projetos/role-sp/role-sp.md) — mapa interativo das linhas de metrô, trem e monotrilho de SP com pontos turísticos, culturais e integração de ônibus via OpenStreetMap
  - [Role SP no trilho — Onde os dados vivem](projetos/role-sp/role-sp-dados.md) — mapa de localização de dados, repositório, APIs externas e estruturas de dados do Role SP no trilho
  - [Role SP no trilho — Detalhamento da interface](projetos/role-sp/role-sp-interface.md) — painéis, tabela das 14 linhas, ~156 POIs em 20 categorias, funções e fluxo "Quero ir aqui"
  - [Role SP no trilho — Arquitetura e Guia](projetos/role-sp/role-sp-arquitetura.md) — funcionamento do script.js, algoritmos de clustering, cálculo de rotas e guia de expansão de transporte
- [Pokédex + Gerador de Time](projetos/pokedex/pokedex.md) — site com Pokédex completa (tipos, habilidades, movimentos, status, itens) e motor de análise de time (cobertura de tipos, fraquezas, status gerais)
  - [Pokédex — Onde os dados vivem](projetos/pokedex/pokedex-dados.md) — PokéAPI (endpoints, cache/fair use), tabela de tipos embutida e repositório do projeto Pokédex
- [Meu Spotify](projetos/meu-spotify/meu-spotify.md) — app pessoal de música grátis com escuta offline; viabilidade: possível via Audius/Jamendo + biblioteca local, inviável para o catálogo mainstream
  - [Meu Spotify — Onde os dados vivem](projetos/meu-spotify/meu-spotify-dados.md) — APIs de música (Audius/Jamendo/Deezer/Spotify), o que cada uma libera, armazenamento offline e limites legais
- [KEMY_AI](projetos/KEMY_AI/KEMY_AI.md) — assistente K.E.M.Y (Kernel Engine for Modular Yield) em Python, terminal + web (index.html), com 20 ferramentas (web, docs PDF/Word/Excel, e-mail, Obsidian, multiagente); modelos gratuitos via OpenRouter
  - [KEMY_AI — Onde os dados vivem](projetos/KEMY_AI/KEMY_AI-dados.md) — pasta/código, OpenRouter (endpoint/modelo/parâmetros), as 20 ferramentas, variáveis KEMY_*/GROK_*, rodízio de modelo e o loop de turno
- [Megabrain](projetos/megabrain/Megabrain.md) — hub de conhecimento/memória estruturada do vault, segundo cérebro que complementa o KEMY_AI
  - [Megabrain — Onde os dados vivem](projetos/megabrain/Megabrain-dados.md) — pasta, convenção de cor (laranja) e como se relaciona com o contraste amarelo do KEMY_AI-dados
- [Mural de Post-its](projetos/mural/mural.md) — mural interativo de post-its para duas pessoas, leve e com post-its guardados/criptografados via GitHub
  - [Mural — Onde os dados vivem](projetos/mural/mural-dados.md) — mapa de localização de dados, repositório, chaves do LocalStorage e fluxo da API GitHub
  - [Mural — Planejamento](projetos/mural/planejamento-mural-postits.md) — planejamento de arquitetura, funcionalidades, modelo de dados e criptografia do mural de post-its
- [grok-code-cli](projetos/grok-code-cli/grok-code-cli.md) — CLI agente de código estilo Claude Code (Node.js) usando a API xAI/Grok com 4 ferramentas de arquivo/shell
  - [grok-code-cli — Onde os dados vivem](projetos/grok-code-cli/grok-code-cli-dados.md) — endpoint xAI, variáveis GROK_*, ferramentas e arquivos
  - [ESPRO — Revista](projetos/espro/espro.md) — plataforma da empresa fictícia da ESPRO: vitrine, montador de revista a partir de dados enviados e quadro estilo Trello por setor e calendário de atividades (Cloudflare)
  - [ESPRO — Onde os dados vivem](projetos/espro/espro-dados.md) — pasta do código, modelo de dados previsto e armazenamento (a definir)

## Ideias
- [Ideias — hub](ideias/ideias.md) — caixa de entrada + método para não esquecer e realizar ideias
  - [Ideias — Inbox](ideias/ideias-inbox.md) — anote ideias em 1 linha (data, ideia, para quê, status)
  - [Como realizar uma ideia](ideias/ideias-como-realizar.md) — clarear, validar, MVP, stack, plano, virar projeto
  - [Modelo de nota de ideia](ideias/ideia-template.md) — template para detalhar uma ideia

## Estudos
- [Estudos de Programação — hub](estudos/estudos-programacao.md) — trilhas ligadas aos projetos do vault
  - [Front-end](estudos/estudos-front-end.md) — HTML/CSS/JS/TS, React/Angular, PWA, testes
  - [Back-end](estudos/estudos-back-end.md) — REST, SQL, Spring/Node/Python, auth, OWASP
  - [Full-stack](estudos/estudos-full-stack.md) — integrar front+back+banco, deploy e CI
  - [Jogos](estudos/estudos-jogos.md) — game loop, Godot/Unity/Phaser, sistemas de RPG
  - [Modelagem de software](estudos/estudos-modelagem-software.md) — requisitos, UML, DER, arquitetura, padrões
  - [MTS (a confirmar)](estudos/estudos-mts.md) — placeholder até a sigla ser definida

## Vida pessoal
- [Vida pessoal — hub-mestre](vida/vida.md) — liga os hubs de gostos e hobbies (música, hobbies, jogos, filmes/séries, livros)
  - [Gostos & Cultura — hub 1](vida/gostos-cultura.md) — o que eu curto: música, jogos, filmes/séries, livros
    - [Música — hub](vida/musica/musica.md) — gêneros, artistas, álbuns, playlists e shows
    - [Jogos — hub](vida/jogos/jogos.md) — jogos que gostei/zerei com nota, jogando agora, top e wishlist
    - [Filmes, Séries & Animes — hub](vida/filmes-series/filmes-series.md) — assistindo, vistos com nota, quero ver
    - [Livros — hub](vida/livros/livros.md) — lendo, lidos com nota, quero ler
  - [Hobbies & Prática — hub 2](vida/hobbies/hobbies.md) — vôlei, desenho, culinária e novos hobbies
    - [Vôlei](vida/hobbies/volei.md) — posição, autoavaliação, diário de treinos/jogos e metas; hub do guia de vôlei
      - [Vôlei — Fundamentos](vida/hobbies/volei/volei-fundamentos.md) — saque, passe, levantamento, ataque, bloqueio, defesa
      - [Vôlei — Regras](vida/hobbies/volei/volei-regras.md) — quadra, rally point, toques, faltas, substituições
      - [Vôlei — Posições e rodízio](vida/hobbies/volei/volei-posicoes-rotacao.md) — posições, zonas 1–6, rodízio
      - [Vôlei — Jogadas e sistemas](vida/hobbies/volei/volei-jogadas-sistemas.md) — china/pipe/meia, 4-2/6-2/5-1
      - [Vôlei — Treinos e glossário](vida/hobbies/volei/volei-treinos-glossario.md) — glossário, treino e lesões
    - [Desenho](vida/hobbies/desenho.md) — estilo, materiais, referências, estudos e galeria
    - [Culinária](vida/hobbies/culinaria.md) — receitas dominadas/para testar, técnicas, modelo de receita

## Projetos Faculdade
- [Bueno's House](projetos-faculdade/bueno-s-house/bueno-s-house.md) — sistema de gestão para restaurantes (Spring Boot + React/Angular), reaproveitado como base técnica para o trabalho acadêmico "Comanda Digital"
  - [Bueno's House — Onde os dados vivem](projetos-faculdade/bueno-s-house/bueno-s-house-dados.md) — repo, MySQL/Flyway, endpoints REST, credenciais demo e ambiente local
  - [Comanda Digital — SRS v3.2](projetos-faculdade/bueno-s-house/comanda-digital-srs.md) — especificação oficial completa do professor (requisitos, modelo de dados, regras, roteiro, critérios de nota)
  - [Comanda Digital — Estado Atual vs. SRS](projetos-faculdade/bueno-s-house/comanda-digital-estado.md) — comparativo bloco a bloco do que já está feito e o que falta (primeira estimativa, ver plano para versão auditada)
  - [Comanda Digital — Plano de Implementação](projetos-faculdade/bueno-s-house/comanda-digital-plano.md) — plano faseado com base em auditoria real do código (backend + os dois frontends)

## Referências
- ⭐ [Mapa de Dados](referencias/mapa-dados.md) — hub de todas as notas `-dados` (onde cada repo/API/credencial/armazenamento mora)
- [Vault — Onde os dados vivem](referencias/vault-dados.md) — remoto GitHub, scripts de sync, config local, preview servers, o que fica fora do Git
- ⭐ [Mapa de Projetos](referencias/mapa-projetos.md) — carregamento de contexto: por projeto, o hub, o repo real no disco e as refs sempre-considerar (COMECE AQUI ao entrar num projeto)

## Templates
- [Template de Nota](templates/nota-template.md) — modelo com frontmatter para criar notas novas
