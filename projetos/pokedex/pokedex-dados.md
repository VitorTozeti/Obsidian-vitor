---
name: pokedex-dados
description: onde os dados vivem no projeto Pokédex — PokéAPI (endpoints usados), estratégia de cache/pré-download, tabela de tipos embutida e repositório
tags: [projeto, proj/pokedex, dados, pokeapi, api]
updated: 2026-09-14
---

# Pokédex — Onde os dados vivem

Mapa de **localização** dos dados do [[pokedex]] (não é regra de negócio — isso fica no hub).

## Repositório real no disco

- **Ainda não criado.** Projeto em fase de ideia. Quando o repo nascer, registrar aqui o
  caminho local (`C:\...`) e o repositório GitHub (`VitorTozeti/<repo>`).

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

- **Sprites:** URLs vêm dentro de `/pokemon` (`sprites.*`); há também o repositório de
  sprites `PokeAPI/sprites` no GitHub para uso offline.

## Dados embutidos no app (não vêm de API)

- **Tabela de efetividade dos 18 tipos:** matriz fixa (18×18) usada pelo **motor de análise
  de time**. É pequena e imutável — fica **hardcoded** no app para calcular cobertura e
  fraquezas sem chamar a API. (Pode ser derivada de `/type` uma vez e congelada.)

## Estratégia de cache / offline

- Cachear respostas da PokéAPI no cliente (IndexedDB) por Pokémon consultado; **ou**
- Pré-baixar o dataset completo (via dataset oficial ou script varrendo os índices) e servir
  como JSON estático junto do site — elimina dependência de rede e respeita o *fair use*.
