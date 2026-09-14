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

- **Fase:** **v1 construída, rodando e testada no navegador.** Repositório real em
  `C:\Users\v.tozeti\Desktop\Vitor\teste\poke` (git local iniciado, **sem remoto ainda**).
  Ver localização completa em [[pokedex-dados]].
- **Decisão de stack:** **site estático em JS puro (zero build)**, não React+Vite. Motivo:
  o ambiente **não tem Node/npm instalado**, e os demais projetos do vault ([[role-sp]],
  [[greenfinance]]) já são estáticos e publicam no GitHub Pages. Abre direto no `index.html`
  ou via `python -m http.server`. (Se um dia instalar Node, dá para migrar para React.)
- **Fonte de dados:** **PokéAPI** (`https://pokeapi.co/api/v2`) — gratuita, sem chave.
  Endpoints e estratégia de cache em [[pokedex-dados]].
- **Eficiência / fair-use resolvido:** em vez de 1 request por Pokémon só p/ saber o tipo,
  o app busca os **18 endpoints `/type` uma única vez** e monta um índice nome→tipos de
  TODOS os Pokémon; lista completa em 1 request; ficha só sob demanda. Tudo em `localStorage`.
- **Time = construtor competitivo (2ª iteração, entregue):** cada membro é montado "de
  verdade" — **habilidade**, **nature** (25, com +10%/−10%), **nível**, **EVs (0–252, teto
  510) e IVs (0–31)** que **calculam os status finais** (fórmula Gen 3+ em `calcStat`) e
  **4 movimentos** escolhidos entre os que o Pokémon aprende (dropdowns agrupados por método,
  com nível). Editor abre ao clicar no membro. Chave nova de storage: `poke:team:v2`.
- **Motor de análise (o diferencial) — entregue e refinado:** a **cobertura ofensiva agora
  usa os TIPOS DOS GOLPES de dano escolhidos** (fallback = STAB do Pokémon quando o membro
  ainda não tem golpes). Mais: fraquezas compartilhadas (tipos que ferem 2+ membros), perfil
  de status pelas **médias dos status finais**, leitura de estilo, sugestões e matriz 18×18.
- **Pokédex — movimentos ricos (entregue):** a ficha mostra os movimentos numa **tabela**
  com tipo, **categoria** (Físico/Especial/Status), poder, precisão, PP e **como aprende**
  (Nível X / MT-HM / Ovo / Tutor), com **filtros** (método, tipo, categoria e busca). Detalhe
  de cada golpe é buscado sob demanda (enxuto) e cacheado — ver [[pokedex-dados]].
- **Layout:** aba **Time** e aba **Tipos** centralizadas.
- **Telas entregues:** **Pokédex** (grid + busca + filtro tipo/geração + ficha modal com
  movimentos filtráveis), **Tipos** (efetividade 18×18) e **Time** (construtor + análise).
- **Pendências (próximos passos):** criar repo remoto no GitHub + deploy (Pages); item
  segurado por seleção de lista real (hoje é campo de texto livre); páginas dedicadas de
  habilidades/itens; gerador automático de time por objetivo.

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
