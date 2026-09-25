---
name: pokedex
description: site Pokédex completa (tipos, habilidades, movimentos, status, itens) com gerador de time avançado que analisa cobertura de tipos, sinergia e status gerais
tags: [projeto, proj/pokedex, site, web, pokeapi, ideia]
updated: 2026-09-25 (11ª iteração: filtros da Pokédex por habilidade, golpe e ranking por status maior/menor)
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
- **Itens de verdade — catálogo curado + no motor de análise (8ª iteração, entregue):** o item
  deixou de ser campo de texto livre. Novo `js/items.js` (`window.ITEMS`) traz ~43 itens
  competitivos curados (id = slug da PokéAPI p/ o sprite em `sprites/items/{id}.png`), cada um
  com rótulo PT, categoria, efeito e — o diferencial — anotações que o motor lê: `mod`
  (multiplicadores de status finais: Choice Scarf ×1.5 Vel, Choice Band ×1.5 Atk, Assault Vest
  ×1.5 Def.Esp., Eviolite ×1.5 Def/Def.Esp.), `dmg/se/phys/spec` (Life Orb, Expert Belt, Muscle
  Band, Wise Glasses) usados pela calc de dano, e flags `locks`/`blocksStatus`/`nfeOnly`. No
  editor do time o campo virou um **seletor rico** (busca + filtro por categoria + ícone +
  efeito), o item aparece no card do slot, e a análise agrega os **status já ajustados pelo
  item** (`adjustedStats`). Novo cartão de **coerência de item** nas sugestões +
  penalização na nota da IA: Colete de Combate + golpe de status, item Choice + status/setup,
  item ofensivo sem golpe de dano, Eviolite em mega — tudo detectado sem fetch extra.
- **Import/Export no formato Pokémon Showdown + compartilhar por URL (8ª iteração, entregue):**
  novo `js/tools.js` (`window.PokeTools`). **Exportar** gera o texto padrão Showdown do time
  ativo (Species @ Item / Ability / Level / EVs / Nature / IVs / - Golpes). **Importar** parseia
  um time colado (parser tolerante a nickname, gênero, linhas extras) e monta um **time novo**,
  resolvendo espécie via `getPokemon`, mapeando nome→slug de item/golpe/nature e enriquecendo
  tipo/categoria dos golpes escolhidos p/ a análise nascer correta (`Team.importSets`).
  **Compartilhar** codifica o texto Showdown em base64 no `#hash` da URL (sem backend); ao abrir
  um link com `#team=…` o app oferece importar. Botões na barra da aba Time.
- **Calculadora de dano (8ª iteração, entregue):** modal `🧮 Dano` (em `js/tools.js`) com a
  **fórmula oficial Gen 3+**: escolhe atacante, golpe de dano e alvo (todos do time ativo),
  usa os **status finais já ajustados por item**, aplica STAB, efetividade de tipo e itens de
  dano (Life Orb ×1.3, Expert Belt ×1.2 em SE, Muscle Band/Wise Glasses ×1.1), e mostra faixa
  de dano mín–máx, % do HP do alvo, barra visual e leitura de nocaute (OHKO garantido / possível
  / nº de golpes). Deixa claro que é estimativa (sem habilidades/clima/campo/telas/boosts).
- **Redesign profissional + responsividade + MODO CLARO (8ª iteração, entregue):** o `settings.js`
  ganhou um 2º eixo independente do acento — **modo de exibição** (Escuro / Claro / Automático =
  segue `prefers-color-scheme`), salvo em `poke:mode` e aplicado por `data-mode` (script inline no
  `<head>` evita flash). O CSS separou variáveis **estruturais** (fundo/painéis/texto/linha,
  agora via `--topbar-bg`/`--overlay` também) das de **acento**: um bloco `:root[data-mode="light"]`
  (depois das paletas, pra vencer por ordem) reescreve só as estruturais → qualquer paleta funciona
  em claro e escuro. **+2 paletas** (Brasa, Aurora → 8 no total). Responsividade real com breakpoints
  880/720/560/400px (topbar/abas, barra de ferramentas em grade, slots e grid adaptáveis, modais e
  editor empilhando), `color-scheme` correto e respeito a `prefers-reduced-motion`.
- **Habilidades com efeito em PT (9ª iteração, entregue):** novo `js/abilities.js` (`window.ABILITY_PT`
  + helper `abilityInfo`/`abilityLabel`). A ficha do Pokémon deixou de listar habilidades como só
  nomes — agora renderiza **cartões** (`.ability-card` no `pokedex.js`) com o nome em PT e **o que a
  habilidade faz**. Origem do texto: dicionário curado de ~90 habilidades comuns/competitivas em
  português; para as fora do dicionário, cai para a PokéAPI (`API.getAbility`, já existia) usando o
  `short_effect` (pt-br→pt→en) e cacheia. No **editor de time** o `<select>` de habilidade ganhou uma
  caixa `#f-ability-effect` que mostra o efeito da habilidade selecionada (atualiza ao trocar).
- **Mega pedras reais ligadas à mega (9ª iteração, entregue):** `js/items.js` ganhou
  `window.MEGA_STONES` (mapa variedade-mega → `{id da pedra, rótulo PT}`, ~48 megas) + `STONE_TO_MEGA`;
  as pedras entram no catálogo de itens numa **categoria "Mega Pedras"** (com sprite oficial). No
  editor (`team.js`): escolher uma **mega** já segura a **pedra certa** automaticamente (e mostra
  `.mega-stone-hint` com sprite + "Segurando Charizardita X"); escolher a **pedra** no seletor de item
  ativa a **mega** correspondente (bidirecional). O seletor de item só mostra as mega pedras que
  **aquele** Pokémon pode usar (filtra por `megaForms`). Bônus: a mega agora **adota a habilidade da
  forma mega** (`selectMega`/`applyMegaAbility`/`abilitiesOf` — ex. Mega Charizard X vira Garras
  Rígidas), capturada junto com tipos/status ao carregar `megaData`.
- **Configurações melhoradas (9ª iteração, entregue):** `settings.js` ganhou um 3º eixo —
  **Animações** (Ligadas/Reduzidas, salvo em `poke:anim`, aplicado por `data-anim` já no `<head>`; um
  bloco `:root[data-anim="off"]` no CSS zera transições/animações) — e um botão **↺ Restaurar padrões**
  que volta paleta/modo/animações ao default. Modal reorganizado (seções + `.settings-footer`).
- **Polimento visual profissional (9ª iteração, entregue):** cartões de habilidade em grid responsivo
  com hover, caixa de efeito no editor (borda de acento à esquerda), dica de mega pedra com sprite,
  todos usando as variáveis de tema (funcionam em todas as 8 paletas + claro/escuro).
- **Mega evoluções customizadas / fan-made (10ª iteração, entregue):** além das megas
  oficiais (que já vinham por `species.varieties` da PokéAPI — e o mirror deste ambiente até
  já traz fan-megas completas como `raichu-mega-x/y`, `dragonite-mega`, `lucario-mega-z`), o
  app agora embute um catálogo próprio de **megas não-oficiais** em `js/items.js`
  (`window.CUSTOM_MEGAS`): **Mega Flygon** (Terra/Dragão, Levitação), Milotic (Água,
  Competitivo), Arcanine (Fogo, Intimidação), Crobat (Venenoso/Voador, Infiltrador), Luxray
  (Elétrico/Sombrio, Coragem), Zoroark (Sombrio, Ilusão), Hydreigon (Sombrio/Dragão,
  Levitação), Togekiss (Fada/Voador, Graça Serena) e Weavile (Sombrio/Gelo, Garras Rígidas).
  Cada uma traz **tipos, status base e habilidade da forma mega prontos** (não existem na API,
  então não há fetch — os dados vêm embutidos) e reaproveita o **sprite/nº da forma base**. Só
  adicionei megas que o mirror **não** tinha, pra não duplicar/sobrescrever as reais (por isso
  Raichu e Dragonite ficaram de fora — já vêm do mirror). No `team.js`: `appendCustomMegas`
  junta as customizadas ao `m.megaForms` (rótulo "Mega ✨" marca que é fan-made) e `selectMega`
  detecta `CUSTOM_MEGAS` e usa os dados embutidos em vez de chamar `getPokemon`. Cada mega
  ganhou também a **pedra própria** (Flygonita, Miloticita, …) registrada em `MEGA_STONES` →
  entra no seletor de item (categoria Mega Pedras) e é segurada automaticamente, igual às
  oficiais. Testado no navegador: selecionar a Mega Flygon troca tipos/status/habilidade e
  segura a Flygonita, sem erros de console.
- **Filtros avançados na Pokédex (11ª iteração, 2026-09-25, entregue):** a barra de filtros
  ganhou **Habilidade** e **Golpe** (inputs com autocompletar via `<datalist>`, aceitam espaço
  ou hífen e, para habilidade, também o nome PT curado de `abilities.js`), além de
  **ordenação por status base** (HP/Atq/Def/AtE/DfE/Vel/Total) com **Maior→menor / Menor→maior**
  e botão **Limpar**. Tudo combina com busca, tipo e geração (filtro de geração já existia). O
  card mostra o valor do status ordenado. Código: `applyFilters` (agora async, com `filterRun`
  p/ descartar resultados velhos) em `js/pokedex.js`; novos em `js/api.js`: `getAbilityNames`,
  `getMoveNames`, `pokemonWithAbility`, `pokemonWithMove`, `getStatsIndex` (fontes em
  [[pokedex-dados]]). Testado no navegador: Levitate → 32, False Swipe → 126, Gen 1 por
  Velocidade: Electrode 150 no topo / Slowpoke 15 no fim.
  **Redesign UX dos filtros (mesma data):** a barra solta virou um **painel** (`.filters-panel`)
  com busca grande + contador (spinner enquanto carrega), grade de campos **rotulados**
  (Tipo · Geração · Habilidade · Golpe · Ordenar por status), direção como **controle
  segmentado** "↓ Maior / ↑ Menor" (desabilitado até escolher um status), campos preenchidos
  com destaque de acento (`.is-set`), **chips dos filtros ativos** removíveis com ✕ + "Limpar
  tudo", Enter aplica na hora e layout responsivo (5 col → 2 col → mobile).
- **Pendências (próximos passos):** ~~criar repo remoto no GitHub + deploy (Pages)~~ **feito**
  (remoto `VitorTozeti/Vitor-Pokemon` + workflow Pages commitado 2026-09-14; falta só
  confirmar que a página publicada está no ar e linkar a URL do Pages aqui);
  ~~item por seleção de lista real (era campo de texto livre)~~ **feito (8ª it.)**;
  **página dedicada de itens no menu principal** (o catálogo `items.js` já existe, falta a tela
  de consulta) e **página/aba dedicada de habilidades** (o efeito já aparece na ficha e no editor
  desde a 9ª it. via `abilities.js`, mas ainda não há uma tela de enciclopédia só de habilidades);
  gerador automático de time por objetivo (hoje só
  avalia e dá parecer sobre a meta declarada, não monta o time sozinho); a calc de dano ainda
  não considera habilidades/clima/campo/telas/boosts; layout de árvore evolutiva ainda é
  aproximado em ramificações complexas (não desenha um grafo real).

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
