---
name: Megabrain-dados
description: mapa de onde os dados do Megabrain vivem — pasta, notas, convenção de cor (laranja) e como o KEMY_AI-dados (amarelo) se relaciona sem se sobrepor
tags: [projeto, proj/megabrain, dados, arquitetura]
updated: 2026-09-23
---

# Megabrain — Onde os dados vivem

Nota de dados/arquitetura do [[Megabrain]]. O que existe, onde mora e a convenção de cor.

## Pasta / estrutura

- **Pasta real:** `projetos/megabrain/` dentro do vault Obsidian-vitor.
- **Hub:** [[Megabrain]] — ponto de entrada, estado atual e propósito.
- **Esta nota:** onde ficam listados os dados/sub-notas do Megabrain conforme forem criados.

## Convenção de cor (graph view)

- **Megabrain:** família **laranja**, tom **#FB923C** (decimal `16495164`), aplicado em
  `.obsidian/graph.json` nos grupos `path:projetos/megabrain/` e `tag:#proj/megabrain`.
  Escolhido **diferente** do laranja já usado pelo `role-sp` (#EA580C), para não colidir
  no graph. Notas novas do Megabrain devem permanecer na família laranja e **evitar
  amarelo**.
- **KEMY_AI-dados (contraste):** família **amarelo**, tom **#EAB308** (decimal
  `15381256`), aplicado via `path:projetos/KEMY_AI/KEMY_AI-dados.md` e a tag
  `#dados-amarelo` (adicionada ao front matter de [[KEMY_AI-dados]]). Serve para destacar
  a nota de dados da KEMY no graph sem usar tons de laranja.

## Estado atual (2026-09-23)

- Hub e nota de dados criados; ainda sem sub-notas de conteúdo cognitivo.
- Próximo passo natural: à medida que o Megabrain acumular sub-temas (memória,
  indexação, raciocínio), criar notas atômicas aqui e linkar de volta para esta nota e
  para [[mapa-projetos]].

## Relacionado
- [[Megabrain]] — hub do projeto
- [[KEMY_AI-dados]] — nota de dados irmã (contraste amarelo)
- ⭐[[mapa-projetos]]
