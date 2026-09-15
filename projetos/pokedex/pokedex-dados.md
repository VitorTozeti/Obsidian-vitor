---
name: pokedex-dados
description: onde os dados vivem no projeto Pokédex — PokéAPI (endpoints usados), estratégia de cache/pré-download, tabela de tipos embutida e repositório
tags: [projeto, proj/pokedex, dados, pokeapi, api]
updated: 2026-09-15 (itens.js, tools.js, modo claro)
---

# Pokédex — Onde os dados vivem

Mapa de **localização** dos dados do [[pokedex]] (não é regra de negócio — isso fica no hub).

## Repositório real no disco

- **Local:** `C:\Users\v.tozeti\Desktop\Vitor\teste\poke` — git com **remoto**
  `https://github.com/VitorTozeti/Vitor-Pokemon` (branch `main`) e **workflow de Pages**
  em `.github/workflows/jekyll-gh-pages.yml` (Jekyll padrão, publica o estático).
- **Estrutura:** `index.html`, `css/styles.css`,
  `js/{types,items,api,pokedex,team,tools,app,settings}.js`, `README.md`.
  Site 100% estático, sem dependências/build.
  - `js/types.js` — 18 tipos (id/PT/cor) + **tabela de efetividade embutida** + faixas de
    geração + **25 naturezas** + rótulos de status + **`calcStat`** (fórmula de status Gen 3+).
  - `js/items.js` — **catálogo curado de ~43 itens de segurar** (`window.ITEMS`/`ITEM_BY_ID`):
    id=slug PokéAPI (p/ sprite `sprites/items/{id}.png`), PT, categoria, efeito e as anotações
    lidas pelo motor/calc (`mod`, `dmg`, `se`, `phys`, `spec`, `locks`, `blocksStatus`, `nfeOnly`).
    Itens NÃO vêm da API — é lista fixa embutida (como a tabela de tipos), só o sprite é remoto.
  - `js/tools.js` — **ferramentas do teambuilder** (`window.PokeTools`): export/import no formato
    **Pokémon Showdown**, **compartilhar por URL** (time em base64 no `#hash`, sem backend) e
    **calculadora de dano** (fórmula oficial + itens de dano). Usa a API pública de `Team`.
  - `js/api.js` — PokéAPI + cache; índice de tipos; **`getMove` (detalhe enxuto)**,
    **`normalizeMoves`** (junta métodos/nível) e **`enrichMoves`** (lotes com concorrência).
  - `js/pokedex.js` — grid, busca/filtros, ficha modal e **tabela de movimentos filtrável**.
  - `js/team.js` — **construtor competitivo** (habilidade/nature/nível/EVs/IVs/4 golpes) +
    motor de análise (cobertura pelos tipos dos golpes).
  - `js/app.js` — boot, abas, tela de Tipos.
- **Rodar sem Node:** `python -m http.server 8080` na pasta, ou abrir `index.html` direto.

## Fonte de dados externa — PokéAPI

- **Base URL:** `https://pokeapi.co/api/v2`
- **Autenticação:** nenhuma (aberta, sem chave).
- **Política:** *fair use* — dados são **estáticos**; a PokéAPI **pede cache** e desencoraja
  requests repetidos. Oferece **dataset baixável** e **cópia auto-hospedável** para uso
  pesado. Estratégia recomendada: cachear no cliente (IndexedDB/localStorage) ou pré-baixar.

### Endpoints principais a consumir

| Recurso | Endpoint | Para quê |
|---|---|---|
| Pokémon | `/pokemon/{id ou nome}` | status base, tipos, habilidades, movimentos, sprites |
| Espécie | `/pokemon-species/{id}` | flavor text, geração, taxa de captura, evolução |
| Evolução | `/evolution-chain/{id}` | cadeia de evolução |
| Tipo | `/type/{id ou nome}` | efetividade (dano dobro/metade/nulo) — base do motor |
| Habilidade | `/ability/{id ou nome}` | descrição/efeito das habilidades |
| Movimento | `/move/{id ou nome}` | poder, precisão, PP, categoria, tipo, efeito |
| Item | `/item/{id ou nome}` | itens (held items, evolutivos, etc.) |
| Geração | `/generation/{id}` | filtrar por geração |

- **Sprites (implementado):** construídos direto do ID, sem chamar a API —
  `raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/{id}.png` (grid/slots) e
  `.../other/official-artwork/{id}.png` (artwork da ficha).

### Chaves de cache usadas (localStorage, prefixo `poke:v1:`)
- `list` — lista id+nome de todos os Pokémon (1 request).
- `typeIndex` — índice nome→tipos montado dos 18 `/type` (evita 1 request por Pokémon).
- `type:{t}`, `pokemon:{id}`, `species:{id}`, `evo:{id}`, `ability:{id}` — respostas cruas.
- `movei:{nome}` — detalhe **enxuto** do movimento (tipo, categoria, poder, precisão, PP),
  usado na tabela de movimentos da ficha e para descobrir o tipo dos golpes do time.
- Time do usuário: `poke:teams:v1` (lista de times; migra do antigo `poke:team:v2`). Cada
  membro guarda `build.item` = **id do item** do catálogo (ou texto livre antigo migrado).
  Fora do cache da API, preservado ao "Limpar cache".
- Preferências de UI: `poke:theme` (paleta de acento) e `poke:mode` (modo claro/escuro/auto).
- Ao estourar a cota, o app limpa `pokemon:*` **e `movei:*`** e tenta de novo (`cacheSet`).

## Dados embutidos no app (não vêm de API)

- **Tabela de efetividade dos 18 tipos:** matriz fixa (18×18) usada pelo **motor de análise
  de time**. É pequena e imutável — fica **hardcoded** no app para calcular cobertura e
  fraquezas sem chamar a API. (Pode ser derivada de `/type` uma vez e congelada.)

## Estratégia de cache / offline

- Cachear respostas da PokéAPI no cliente (IndexedDB) por Pokémon consultado; **ou**
- Pré-baixar o dataset completo (via dataset oficial ou script varrendo os índices) e servir
  como JSON estático junto do site — elimina dependência de rede e respeita o *fair use*.
