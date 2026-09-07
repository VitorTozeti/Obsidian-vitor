---
name: mapa-projetos
description: mapa de carregamento de contexto — por projeto, o que abrir (hub, notas, refs sempre-considerar, repo real no disco)
tags: [referencia, mapa, navegacao, sempre-considerar]
updated: 2026-09-07
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
