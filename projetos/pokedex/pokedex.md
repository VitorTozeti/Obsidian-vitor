---
name: pokedex
description: site Pokédex completa (tipos, habilidades, movimentos, status, itens) com gerador de time avançado que analisa cobertura de tipos, sinergia e status gerais
tags: [projeto, proj/pokedex, site, web, pokeapi, ideia]
updated: 2026-09-14 (7ª iteração + registro do remoto/Pages)
---

# Pokédex + Gerador de Time

Site (aplicação web) que reúne uma **Pokédex completa** — Pokémon com seus tipos,
habilidades, movimentos, status base e itens — e um **gerador/analisador de time
avançado**: o usuário monta um time e a ferramenta avalia o *estilo* dele, os status
gerais (ofensivo/defensivo/velocidade), a cobertura de tipos, fraquezas compartilhadas e
sugere ajustes.

## Estado atual (2026-09-14)

- **Fase:** **v1 construída, rodando e testada no navegador.** Repositório real em
  `C:\Users\v.tozeti\Desktop\Vitor\teste\poke`, **agora com remoto no GitHub**
  (`https://github.com/VitorTozeti/Vitor-Pokemon`) e **workflow de deploy do GitHub Pages**
  já commitado (`.github/workflows/jekyll-gh-pages.yml`, Jekyll padrão — serve o estático).
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
- **Redesign visual (3ª iteração, entregue):** nova paleta "Pokédex de bolso" — vermelho-cristal
  (`--accent #ff3b5c`) como acento principal e âmbar (`--gold #ffb020`) como secundário, painéis
  em vidro fosco com gradientes sutis, topbar com glassmorphism, botões com gradiente, barras de
  status e EV com gradiente vermelho→âmbar, cards com glow ao hover. CSS totalmente reescrito em
  `css/styles.css` (mesmas classes reaproveitadas onde possível).
- **Múltiplos times (3ª iteração, entregue):** o construtor deixou de guardar 1 time único e
  passou a guardar uma **lista de times** (`poke:teams:v1` = `{teams:[{id,name,members}], active}`,
  com migração automática do antigo `poke:team:v2`). Seletor de times no topo da aba **Time**:
  criar (＋), renomear (✎, via prompt) e excluir (✕, não deixa remover o último) — cada time tem
  até 6 membros próprios, construídos e analisados independentemente.
- **Seletor de golpes rico (3ª iteração, entregue):** os 4 slots de movimento do editor deixaram
  de ser `<select>` simples e viraram um **popover com busca + filtro por método** (Nível/MT-HM/
  Ovo/Tutor), listando cada golpe já com **tipo, categoria e poder** (os detalhes de todos os
  golpes do Pokémon em edição são pré-carregados em segundo plano ao abrir o editor — cache em
  memória por nome de Pokémon — para a lista já nascer rica, sem esperar clique a clique).
- **Menu de configurações + 6 paletas de cores (4ª iteração, entregue):** botão de engrenagem
  na topbar abre um modal (`js/settings.js`, novo módulo `window.Settings`) com **6 temas**
  (Cristal — padrão, Oceano, Floresta, Elétrico, Sombrio, Fada), cada um um bloco
  `:root[data-theme="id"]` em `css/styles.css` que sobrescreve as variáveis de cor (accent,
  glow do fundo, painéis). Escolha persiste em `localStorage` (`poke:theme`) e é aplicada
  cedo por um `<script>` inline no `<head>` do `index.html` (evita flash da cor errada).
  Refatorei cores que estavam **hardcoded** (gradiente do fundo, `#e0264a` em botões/abas)
  para variáveis (`--glow-1/2`, `--accent-strong`) para que os temas alcancem tudo.
- **EVs/IVs por slider (4ª iteração, entregue):** no editor de membro, os `<input type=number>`
  de EV (0–252, passo 4) e IV (0–31) viraram **sliders** (`<input type=range>` com estilo
  customizado via CSS `::-webkit-slider-thumb`/`::-moz-range-thumb`, cor do tema). Arrastar
  atualiza o valor/total ao vivo (`oninput`, sem re-render pra não perder o thumb); soltar
  (`onchange`) recalcula o status final e a análise do time.
- **Formas alternativas — Mega, Gigamax, regionais (4ª iteração, entregue):** a ficha de
  Pokémon agora lê `species.varieties` da PokéAPI e mostra **chips de forma** (ex.: Charizard
  → Padrão / Mega X / Mega Y / Gigamax) quando existe mais de uma; clicar troca a ficha
  inteira (tipos, status, habilidades) para aquela variedade via `openDetail(nomeDaVariante)`.
  Corrigi de quebra a espécie sempre pela `p.species.name` (antes usava `p.id`, que dava
  errado pra formas com ID alto, ex. Mega Charizard X = #10034).
- **Linha evolutiva na ficha (4ª iteração, entregue):** busca a `evolution_chain` da espécie
  (`API.getEvolutionChain`, já existia e já era cacheada) e renderiza a árvore de evolução
  como uma linha de sprites clicáveis com setas indicando a condição (nível, item, troca,
  felicidade, tipo de golpe conhecido etc.) — lida com ramificações simples (ex. Eeveelutions)
  empilhando os estágios verticalmente. Clicar num estágio abre a ficha dele.
- **Ficha com visual "hero" (5ª iteração, entregue):** o cabeçalho da ficha (modal ao clicar
  num Pokémon) foi redesenhado — `.detail-head` virou `.detail-hero`, com nome bem maior
  (32px), badges de tipo maiores/mais legíveis e o botão **"＋ Adicionar ao time"** destacado
  logo abaixo do nome (antes ficava mais escondido no meio do bloco). Fundo com glow radial
  na cor do tipo primário (`--hero-c`, via `style` inline por Pokémon).
- **Preencher movimentos automaticamente (5ª iteração, entregue):** no editor de membro do
  time, botão **"🎲 Preencher automaticamente"** (`js/team.js: autoFillMoves`) que escolhe
  golpes para os slots vazios usando os dados já enriquecidos em cache (mesmo golpe de
  dano/STAB, ordenado por poder; no máx. 1 golpe de status) — resolve a fricção de montar
  moveset golpe a golpe manualmente. Precisa que o enriquecimento em segundo plano (que já
  roda ao abrir o editor) tenha terminado; se não, avisa por toast pra tentar de novo.
- **Meta do time + "IA" local gratuita para avaliar o time (5ª iteração, entregue):** cada
  time agora tem um campo de **meta/objetivo** (`team.meta`, texto livre + atalhos rápidos:
  ofensivo/hyper offense, defensivo/stall, balanceado, trick room, chuva, sol). Um novo
  motor **100% client-side, sem API/chave/custo** (`detectMetaProfile` + `aiVerdict` em
  `js/team.js`) lê a meta declarada (por palavras-chave) e cruza com os números já calculados
  pela análise (cobertura, fraquezas compartilhadas, completude do moveset, perfil de
  ofensivo/bulk/velocidade) para dar uma **nota 0–10** e um parecer em português (pontos
  fortes/a melhorar) sobre se o time está bom **para a meta declarada**. É deixado claro na UI
  que não é um LLM, é um motor de regras — daí ser "gratuito" de verdade (roda no navegador
  do usuário, sem servidor).
- **Análise da IA sob demanda, não automática (6ª iteração, entregue):** o parecer da "IA
  local" deixou de recalcular sozinho a cada tecla/EV/golpe alterado — agora só roda quando
  o treinador clica **"📤 Enviar time para a IA"** (na caixa de meta) ou **"📤 Enviar de
  novo"** (no próprio cartão de resultado). O resultado fica cacheado por time
  (`aiRuns[teamId]` em memória, em `js/team.js`) junto com um "snapshot" dos números da
  análise no momento do envio; se o time mudar depois, o cartão mostra um aviso amarelo de
  **desatualizado** (`.ai-stale-note`) até o treinador enviar de novo. Antes do primeiro
  envio, o cartão mostra um estado vazio explicando o que fazer.
- **Correção: clique nos golpes filtrados não funcionava (6ª iteração, corrigido):** no
  seletor de golpes do editor de time, buscar ou filtrar por método recriava a lista
  (`renderMoveList` via `innerHTML`) e as novas linhas ficavam **sem o listener de clique**
  — só as linhas do primeiro render (sem filtro) tinham `onclick`, então filtrar e depois
  clicar num golpe não fazia nada. Corrigido trocando o binding por **delegação de evento**
  no `#mvp-list` (que sobrevive aos re-renders), em vez de religar cada linha a cada
  re-render.
- **IA local ganha perfil de "time de captura" + corrige race condition (7ª iteração,
  entregue):** o botão "Enviar time para a IA" tinha um bug — clicar logo depois de digitar
  a meta rodava a análise com o texto ainda não salvo (o autosave do textarea tem debounce de
  300ms), então parecia sempre "sem meta declarada". Corrigido: o clique agora salva a meta
  na hora, sem esperar o debounce. Além disso, `detectMetaProfile` (`js/team.js`) ganhou um
  ramo dedicado pra **times de captura** (gatilho: "capturar", "false swipe", "investida
  falsa" no texto da meta) — em vez de julgar por ofensivo/bulk/velocidade (irrelevante pra
  esse estilo), a nova função `aiVerdictCapture` verifica se o time tem **Investida Falsa**
  (chip damage sem nocautear) e um **golpe de paralisia/sono** (Paralisar, Hipnose, Esporo
  etc.) entre os golpes escolhidos dos membros.
- **Correção: busca de golpe não encontrava nada com espaço (7ª iteração, corrigido):** os
  nomes de golpe na PokéAPI vêm com hífen (`false-swipe`), mas o treinador digita com espaço
  ("false swipe") — a busca comparava direto sem normalizar, então nunca batia. Corrigido nos
  dois lugares que buscam golpe por nome: seletor de golpes do time (`filteredMoves`) e tabela
  de movimentos da ficha (`drawMoves`, `js/pokedex.js`), com um helper `normSearch` que trata
  hífen e espaço como equivalentes.
- **Mega evolução no construtor de time (7ª iteração, entregue):** Pokémon com mega evolução
  (detectado via `species.varieties` da PokéAPI, mesma técnica das formas na ficha) ganham um
  seletor **"💎 Mega pedra"** no editor de membro (`js/team.js: ensureMegaForms`,
  `loadMegaForms`, `selectMega`), com as opções encontradas (ex. Mega X / Mega Y do
  Charizard). Escolher uma mega busca os dados reais daquela forma (`window.API.getPokemon`)
  e passa a usar o sprite, os **tipos** (Mega Charizard X vira Fogo/Dragão, não mais
  Fogo/Voador) e os **status base** dela em tudo — card do slot, cabeçalho do editor, status
  finais (`finalStats`) e o motor de análise (`analyze`) — via um helper `activeForm(m)` que
  resolve pra mega escolhida (se já carregada) ou a forma normal.
- **Pendências (próximos passos):** ~~criar repo remoto no GitHub + deploy (Pages)~~ **feito**
  (remoto `VitorTozeti/Vitor-Pokemon` + workflow Pages commitado 2026-09-14; falta só
  confirmar que a página publicada está no ar e linkar a URL do Pages aqui); item segurado por
  seleção de lista real (hoje é campo de texto livre); páginas dedicadas de habilidades/itens;
  gerador automático de time por objetivo (hoje só avalia e dá parecer sobre a meta declarada,
  não monta o time sozinho); layout de árvore evolutiva ainda é aproximado em ramificações
  complexas (não desenha um grafo real).

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
