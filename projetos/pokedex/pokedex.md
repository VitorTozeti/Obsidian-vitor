---
name: pokedex
description: site Pokédex completa (tipos, habilidades, movimentos, status, itens) com gerador de time avançado que analisa cobertura de tipos, sinergia e status gerais
tags: [projeto, proj/pokedex, site, web, pokeapi, ideia]
updated: 2026-09-14
---

# Pokédex + Gerador de Time

Site (aplicação web) que reúne uma **Pokédex completa** — Pokémon com seus tipos,
habilidades, movimentos, status base e itens — e um **gerador/analisador de time
avançado**: o usuário monta um time e a ferramenta avalia o *estilo* dele, os status
gerais (ofensivo/defensivo/velocidade), a cobertura de tipos, fraquezas compartilhadas e
sugere ajustes.

## Estado atual (2026-09-14)

- **Fase:** ideia registrada — ainda **sem repositório** no disco e sem código. Próximo
  passo é escolher a stack e fazer a prova de conceito consumindo a [[pokedex-dados|PokéAPI]].
- **Fonte de dados definida:** **PokéAPI** (`https://pokeapi.co/api/v2`) — gratuita, sem
  chave, cobre 1350+ Pokémon, tipos, habilidades, movimentos, itens, cadeias de evolução e
  sprites. Detalhes de endpoints em [[pokedex-dados]].
- **Ponto de atenção:** a PokéAPI pede **cache** (dados estáticos, política de *fair use*).
  O plano é cachear no cliente e/ou pré-baixar o dataset, nunca marteladas de request.
- **Diferencial do projeto:** não é só uma Pokédex de consulta — o **motor de análise de
  time** (matriz de fraquezas/resistências por tipo + leitura de status agregados) é o que
  agrega valor. Ver "Motor de análise de time" abaixo.

## Funcionalidades principais

1. **Pokédex de consulta**
   - Lista/busca de Pokémon com filtros por tipo, geração, habilidade.
   - Ficha detalhada: tipos, habilidades (com descrição), status base (HP, Atk, Def, SpA,
     SpD, Spe), movimentos aprendíveis, cadeia de evolução e sprites.
2. **Enciclopédia de apoio**
   - Páginas de **tipos** (tabela de efetividade), **habilidades**, **movimentos**
     (poder, precisão, categoria, efeito) e **itens**.
3. **Montador de time (até 6)**
   - Adicionar Pokémon ao time; escolher itens/habilidades/movesets.
4. **Motor de análise de time (o diferencial)**
   - **Cobertura ofensiva:** contra quais dos 18 tipos o time bate forte / é neutro / é
     fraco (com base nos tipos dos movimentos).
   - **Perfil defensivo:** fraquezas **compartilhadas** (quantos membros são fracos ao
     mesmo tipo = risco) e resistências em comum.
   - **Status gerais:** médias/somatórios do time (muro? hiper-ofensivo? veloz?), leitura
     do "estilo" resultante.
   - **Sugestões:** apontar buracos de cobertura e recomendar tipos/Pokémon que os cobrem.
5. **(Futuro) Gerador automático:** montar um time sugerido a partir de um objetivo
   (ex.: "balanceado", "ofensivo rápido", "mono-tipo água viável").

## Arquitetura e tecnologias (proposta a validar)

- **Frontend:** app web SPA. Opções: **React + Vite** (ecossistema grande, bom p/ estado do
  time) ou **JS puro** como no [[role-sp]] se quiser leve. Recomendação: React + Vite.
- **Dados:** PokéAPI em runtime **com cache** (ver [[pokedex-dados]]); alternativa robusta é
  **pré-baixar** o dataset (a PokéAPI oferece cópia hospedável) e servir localmente para não
  depender da rede nem esbarrar em *fair use*.
- **Motor de análise:** tabela de efetividade dos 18 tipos embutida no app (é fixa e pequena)
  — a matemática de cobertura/fraqueza roda 100% no cliente, sem depender de API.
- **Hospedagem:** estático (GitHub Pages / Vercel / Netlify), como os outros projetos.

## Notas detalhadas

- [[pokedex-dados]] — onde os dados vivem: PokéAPI (endpoints usados), estratégia de cache,
  tabela de tipos embutida e, quando existir, o repositório real no disco.
