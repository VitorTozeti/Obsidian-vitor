---
name: mapa-dados
description: hub de todas as notas "onde os dados vivem" (uma por projeto + infra do vault) — ponto único para achar repositórios, APIs, credenciais e armazenamento
tags: [referencia, dados, navegacao, sempre-considerar]
updated: 2026-09-29
---

# Mapa de Dados — todas as notas `<slug>-dados`

Complementa o ⭐[[mapa-projetos]]: ali está *o que abrir por projeto*; aqui, *onde cada dado mora*.

| Projeto | Nota de dados | Resumo do que mapeia |
|---|---|---|
| GreenFinance | [[greenfinance-dados]] | repo, APIs (Pluggy), worker, `useStore`, importação OFX/CSV/PDF |
| Nexus RPG | [[nexus-rpg-dados]] | repo, LocalStorage, arquivos `.nexus`, schema 10 |
| Role SP | [[role-sp-dados]] | repo, APIs externas (OSM), POIs e linhas |
| Pokédex | [[pokedex-dados]] | PokéAPI, cache, tabela de tipos embutida |
| Meu Spotify | [[meu-spotify-dados]] | APIs de música e limites legais |
| KEMY_AI | [[KEMY_AI-dados]] 🟨 | OpenRouter, 20 ferramentas, variáveis `KEMY_*` |
| Megabrain | [[Megabrain-dados]] | pasta/convenção de cor |
| Mural | [[mural-dados]] | Cloudflare D1/Pages, `/data`, LocalStorage |
| Bueno's House | [[bueno-s-house-dados]] | MySQL, Flyway, endpoints REST |
| grok-code-cli | [[grok-code-cli-dados]] | API xAI, `GROK_*` |
| Vault (infra) | [[vault-dados]] | GitHub remoto, scripts, sync, graph |

## Como manter
Projeto novo → nova linha aqui **e** em [[mapa-projetos]]. Mudou um dado (repo, tabela, endpoint, variável) → atualize a nota do projeto e, se preciso, o resumo desta linha.
