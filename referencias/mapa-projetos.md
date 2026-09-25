---
name: mapa-projetos
description: mapa de carregamento de contexto — por projeto, o que abrir (hub, notas, refs sempre-considerar, repo real no disco)
tags: [referencia, mapa, navegacao, sempre-considerar]
updated: 2026-09-23 (adicionado Megabrain; KEMY_AI-dados marcado com contraste amarelo)
---

# Mapa de Projetos — Carregamento de Contexto

> **Para que serve:** quando a conversa mencionar um projeto, esta é a nota que diz
> **exatamente o que carregar** — o hub, o repositório real no disco, as referências
> `sempre-considerar` que valem e onde está o **estado atual** (a seção `## Estado atual`
> mora no hub de cada projeto). Comece pela linha do projeto; abra o hub; só então desça
> às notas detalhadas que o hub indexar. Não leia tudo "por garantia" — o hub já é o índice.

| Projeto | `proj/` (cor) | Pasta | Hub (abrir 1º) | Onde os dados | Repositório real | Refs sempre-considerar |
|---|---|---|---|---|---|---|
| GreenFinance | `greenfinance` 🟩 #16A34A | `projetos/greenfinance/` | [[greenfinance]] | [[greenfinance-dados]] | `C:\Users\Vitor\Desktop\projetos\greenfinance` (`VitorTozeti/Vitor_finan-as`) | ⭐[[mapa-projetos]] |
| Nexus RPG | `nexus-rpg` 🟪 #9333EA | `projetos/nexus-rpg/` | [[nexus-rpg]] | [[nexus-rpg-dados]] | `C:\Users\Vitor\Desktop\projetos\The-One-System` (`VitorTozeti/The-One-System`) | ⭐[[mapa-projetos]] |
| Role SP no trilho | `role-sp` 🟧 #F97316 | `projetos/role-sp/` | [[role-sp]] | [[role-sp-dados]] | `C:\Users\Vitor\Desktop\projetos\Linhas metros e pontos de interesse proj\Roles-na-linha-verde` (`VitorTozeti/Roles-na-linha-verde`) | ⭐[[mapa-projetos]] |
| Pokédex + Time | `pokedex` 🟥 #DC2626 | `projetos/pokedex/` | [[pokedex]] | [[pokedex-dados]] | `C:\Users\v.tozeti\Desktop\Vitor\teste\poke` (git local, sem remoto) | ⭐[[mapa-projetos]] |
| Meu Spotify | `meu-spotify` 🟦 #0D9488 | `projetos/meu-spotify/` | [[meu-spotify]] | [[meu-spotify-dados]] | (a definir — projeto novo, sem repo ainda) | ⭐[[mapa-projetos]] |
| KEMY_AI | `kemy-ai` 🟦 #2196F3 | `projetos/KEMY_AI/` | [[KEMY_AI]] | [[KEMY_AI-dados]] 🟨 #EAB308 | `C:\Users\v.tozeti\Desktop\Vitor\teste\Obsidian-vitor\projetos\KEMY_AI` (código no vault; `kemy.py`/zip fora do git — chave hardcoded) | ⭐[[mapa-projetos]] |
| Megabrain | `megabrain` 🟧 #FB923C | `projetos/megabrain/` | [[Megabrain]] | [[Megabrain-dados]] | (sem repo — hub de conhecimento/memória do vault, sem código externo) | ⭐[[mapa-projetos]] |
| Bueno's House (faculdade) | `bueno-s-house` 🟦 índigo #4F46E5 | `projetos-faculdade/bueno-s-house/` | [[bueno-s-house]] | (nota única, sem `-dados.md` — projeto de portfólio reaproveitado, não código gerado pelo vault) | `C:\Users\v.tozeti\Desktop\Vitor\teste\thiagolas\Bueno-sHouse` (sem Git iniciado) | ⭐[[mapa-projetos]] |

<!-- Ao passar de um punhado de projetos, quebre em seções por área, ex.:
## Ecossistema A
| ... tabela ... |
## Ecossistema B
| ... tabela ... |
-->

## Referências que valem em (quase) todo projeto
São as `sempre-considerar` — consulte-as **antes de assumir** qualquer código, chave, base
fiscal ou regra de negócio. (Cadastre aqui os links `[[...]]` das suas referências
transversais conforme criá-las.)

## Como manter esta nota
Projeto novo → adicione a linha aqui (com pasta, hub, **nota de dados**, repo, refs)
**junto** com a criação da tag `proj/<slug>`, dos grupos de cor no `.obsidian/graph.json`
**e** da nota `<slug>-dados.md` (obrigatória, ver `CLAUDE.md` regra 10). Mudou o caminho
de um repo, ou uma referência deixou de valer → corrija a linha.
