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

## Projetos Faculdade
- [Bueno's House](projetos-faculdade/bueno-s-house/bueno-s-house.md) — sistema de gestão para restaurantes (Spring Boot + React/Angular), reaproveitado como base técnica para o trabalho acadêmico "DaHorta"

## Referências
- ⭐ [Mapa de Projetos](referencias/mapa-projetos.md) — carregamento de contexto: por projeto, o hub, o repo real no disco e as refs sempre-considerar (COMECE AQUI ao entrar num projeto)

## Templates
- [Template de Nota](templates/nota-template.md) — modelo com frontmatter para criar notas novas
