---
name: nexus-rpg-telas
description: detalhamento tela a tela do Nexus RPG (auth, 17 abas do Mestre, editor de fichas com 21 blocos, campanha e modo Jogador)
tags: [proj/nexus-rpg, telas, ui, referencia-tecnica]
updated: 2026-09-09
---

# Nexus RPG — Detalhamento de Todas as Telas

Mapa tela a tela do [[nexus-rpg]], derivado da leitura direta do código
(`index.html`, `src/**`). Como é um SPA em JS puro sem rotas de URL, cada "tela" é um
estado de `S.view` / `S.tab` renderizado por `render()` dentro de `#root`. Para a
engenharia dos motores ver [[nexus-rpg-arquitetura]]; para chaves e persistência ver
[[nexus-rpg-dados]].

## Estrutura de navegação
- `S.view`: `'mestre'` (editor de sistema/ficha) ou `'jogador'` (wizard + ficha de jogo);
  há ainda a suíte de **Campanha** do Mestre.
- `S.tab`: aba ativa no Mestre. `S.step`: passo no wizard do Jogador.
- O tipo do personagem logado (`kind: 'mestre' | 'jogador'`) define quais ferramentas
  aparecem.

---

## 0. Autenticação e seleção de personagem (`src/auth/auth-ui.js`)
- **Login / Registro:** contas locais (`nexus_accounts`), sem servidor. Senha em texto
  puro (protótipo — ver aviso em [[nexus-rpg-dados]]).
- **Seleção de personagem:** cada conta tem N personagens; escolher um define o `kind`
  (Mestre ou Jogador) e portanto o conjunto de telas liberadas. Sessão em `nexus_session`.

## Modo Mestre — abas de regras (`src/master/master-nav.js` + `master-pieces.js`)
As abas são organizadas em **4 grupos** (`TAB_GROUPS`): 🏗 **Fundação**, 🧍 **Personagem**,
🌍 **Mundo & Regras**, 📤 **Saída**. Abas marcadas `adv` só aparecem no modo avançado.
São **17 abas** (`TAB_META`):

| k (id) | Aba | Grupo | O que edita / gera |
|---|---|---|---|
| `inicio` | 🧭 Início | Fundação | Checklist de prontidão do sistema; lista problemas por aba e leva até eles |
| `campanha` | 📛 Campanha | Fundação | Nome da campanha, nome do sistema e temas (≥1 dos 10 presets) |
| `regras` | ⚙️ Regras | Fundação | Faixa de atributo (inicial × máximo), orçamento de pontos, modo de atributo (valor direto vs. modificador com fórmula) |
| `atributos` | 💪 Atributos | Personagem | Criação de atributos (FOR, AGI…) |
| `recursos` | ❤️ Recursos | Personagem | Recursos de barra (Vida/Mana) ou valor (Defesa), com fórmulas e regras de descanso curto/longo |
| `pericias` | 🎯 Perícias | Personagem | Perícias, vínculo com atributo, treinamento e modo de proficiência |
| `classes` | 🎭 Classes | Personagem | Classes com habilidades, requisitos e efeitos |
| `racas` | 🌱 Origem / Raça | Personagem | Origens/raças com características (`traits`) e habilidades |
| `progressao` | 📈 Progressão | Fundação `adv` | Tabela de degraus (Nível/NEX/Grau), linear ou por classe |
| `escolhas` | 🌿 Escolhas | Personagem `adv` | Pontos de escolha dinâmicos ("escolha N de M"), trilhas/talentos com pré-requisitos |
| `itens` | 🎒 Itens | Mundo | Itens por categoria (arma, armadura, acessório, ferramenta, consumível, outro), carga e sintonização |
| `dados` | 🎲 Dados | Mundo | Configuração de rolagens do sistema |
| `condicoes` | 🩸 Condições | Mundo `adv` | Estados cumulativos/compostos (`noStack`, níveis, efeitos) |
| `tags` | 🏷 Tags | Mundo `adv` | Tags + **matriz direcional** de interação (`tagMatrix`: from→to, mult, dice) |
| `tecnicas` | 🌀 Técnicas | Mundo `adv` | Construtor de feitiços/técnicas em tiers com orçamento de componentes e fórmula de custo |
| `ficha` | 🖼️ Ficha | Saída | **Editor visual de fichas** (canvas) — ver abaixo |
| `sistema` | 💾 Sistema | Saída | Exportar/importar `.nexus`, salvar e gerenciar o sistema |

> A aba **Início** roda um validador (`problemasDaAba`) que checa itens como "dar um
> nome à campanha/sistema", "criar atributos", "definir faixa de atributo válida",
> "pontos de atributo que cabem na faixa", "criar ao menos um recurso com fórmulas
> válidas", "criar perícias", "≥1 classe e ≥1 origem" e "montar a ficha". Cada item é
> um botão que leva direto à aba responsável.

## Editor Visual de Fichas (aba 🖼️ Ficha)
Canvas de largura fixa **`CANVAS_W = 860`px** (escalado para caber na tela), grid de 10px.
- **Paleta de 21 blocos (`BLOCK_TYPES`):**
  - **16 blocos dinâmicos (únicos, `multi:false`):** Nome & Identidade, Foto,
    Atributos, Valores (Defesa etc.), Recursos (barras), Perícias, Habilidades,
    Características físicas, Anotações, Rolador de Dados, Progressão, Inventário,
    Condições, Ataques & Armas, Técnicas Autorais, Escolhas (trilhas/talentos).
  - **5 blocos decorativos (repetíveis, `multi:true`):** Texto livre, Divisor/Linha,
    Forma decorativa, Imagem/Selo, Painel/Moldura vazia.
- **Ferramentas de layout:** arrastar da paleta (fantasma segue o cursor) ou clicar
  para encaixar sozinho no primeiro espaço livre (`freeSpot`); **snap** magnético nas
  bordas/centros; guias vertical/horizontal; painel de **camadas** (ordem e
  visibilidade); seleção múltipla e ações de grupo (alinhar/distribuir, precisa de ≥3
  para distribuir); redimensionar; trazer para frente / enviar para trás.
- **Estilização de atributos (`styleOpts` / `SHAPE_CLIP` / `SHAPE_PRESETS`):** formas
  hexágono, losango, escudo, octógono, círculo, caixa; arranjos grade, colmeia e
  **flor/roseta** (núcleo central + peças ao redor); **6 presets** prontos: ✿ Ritual
  (roseta), ⬣ Colmeia, 📜 Pergaminho, 🛡 Marcial, ◆ Arcano, ▢ Limpo.
- **Undo/Redo:** `pushUndo()` antes de cada mudança; `Ctrl+Z` / `Ctrl+Shift+Z` / `Ctrl+Y`.

## Suíte de Campanha do Mestre (`src/master/campaign/`)
- **Dashboard (`dashboard.js`) — dois menus laterais + MÚLTIPLOS painéis
  (2026-09-09):** substituiu a antiga fita única de abas no topo. Dois *rails*
  verticais fixos (`.mrail`): **esquerda (índigo)** = `Painel`, `Sistema`,
  `Jogadores`, `Bestiário`, `Itens`; **direita (âmbar)** = `Mapa`, `Notas`, `Dados`.
  Estado em `S.mopen` = **lista** de seções abertas (inicializada em `state.js`):
  clicar num item do menu faz toggle (`toggleMtab`) e **quantas seções quiser ficam
  abertas ao mesmo tempo**; os painéis abertos se distribuem em `.mpanes`
  (flex-wrap) e quebram em linha, reordenados por `ordemAbertos()` (esquerda antes
  da direita). Cada painel tem cabeçalho com ✕ (`fecharPainel`); item ativo no rail
  recebe `.mrail-dot`. Atalhos do `painelView` usam `irMtab(k)` (garante aberto). As
  **barras de rolagem** de `.mrail` e `.mpane-body` ficam ocultas (scroll continua):
  `scrollbar-width:none` + `::-webkit-scrollbar{display:none}`. CSS `.mdash2/.mrail/
  .mpane*` (responsivo: empilha abaixo de 1100px).
- **Dados (`campaign-dice.js`) — construtor visual de rolagem (2026-09-09):** além da
  expressão livre (`rolagemRapida` → `rollExpr`), agora tem uma **paleta de dados
  poliédricos** (`DICE_TYPES` 4/6/8/10/12/20/100) desenhados em SVG inline
  (`diceIcon(faces,size)` com `DICE_SHAPES` + `DICE_COLOR`; d100 = forma do d10 com
  `%`). Tocar num dado soma ao pool (`S.diceB={pool:{faces:qtd}, mod}`); cada grupo
  aparece como **“qtd · ícone · faces”** com +/− (`diceAdd`) e há um chip de
  modificador (`diceModAdd`). `diceBExpr()` monta a expressão exibida e
  `diceBExprExec()` a versão p/ `rollExpr`; resultado atual em destaque
  (`.dice-result`) lendo `diceLog[0]`. CSS novo: `.dice-palette/.dice-type/.dice-pool/
  .dice-chip/.dice-step/.dice-expr-big/.dice-result` e `.die-ic/.die-num`.
- **Bestiário (`bestiary.js`):** inimigos com statblocks dinâmicos gerados a partir
  dos atributos do sistema; NPCs com cards de relacionamento.
- **Jogadores (`players.js`):** gestão dos personagens dos jogadores na campanha.
- **Itens da campanha (`campaign-items.js`):** itens específicos da mesa.
- **Mapa tático (`campaign-map.js`):** upload de imagem (DataURL), grid quadriculado
  configurável (tamanho em px + toggle) e tokens arrastáveis em percentual relativo
  (`xPct`/`yPct`) para manter alinhamento em qualquer tela.
- **Log de dados (`campaign-dice.js`):** histórico das últimas ~60 rolagens da mesa
  com data/hora e autor.
- **Modelo (`campaign-model.js`):** estrutura de dados da campanha (carregado cedo no
  `index.html`, antes de `state.js`).

## Modo Jogador — Wizard e Ficha (`src/player/player.js`)
- **Wizard de criação (passos dinâmicos):** `Identidade` → `Atributos` → `Perícias` →
  (`Escolhas`, só se o sistema tiver pontos de escolha) → `Ficha`. Navegação
  Voltar/Avançar com validação (`canNext`) e "↻ Recomeçar ficha" (`initDraft`).
  - *Identidade:* nome, escolha de **Classe** e **Origem/Raça**.
  - *Atributos:* distribuição dentro do orçamento/faixa definidos pelo Mestre.
  - *Perícias:* seleção respeitando o teto de perícias escolhíveis.
  - *Escolhas:* talentos/subclasses disponíveis para o nível.
- **Ficha dinâmica de jogo:** renderiza o layout desenhado pelo Mestre com dados
  reais — calcula defesas, valores e rolagens; botões de **descanso curto/longo**
  (recuperam recursos conforme a regra), rolador com **Vantagem/Desvantagem**,
  toggles de condições ativas, inventário com sintonização (teto `sintoniaMax`) e
  foto do personagem (base64).

---

## Atalhos de teclado (`src/ui/shortcuts.js`)
Só ativos para um **personagem Mestre logado**; na aba Ficha não sequestram teclas
enquanto se digita em `input/textarea/select`.
- **Ctrl+K** — busca global (vale em qualquer aba, mesmo digitando).
- **Escape** — fecha busca/glossário.
- **Ctrl+Z** — desfazer · **Ctrl+Shift+Z** / **Ctrl+Y** — refazer.
- **Ctrl+A** — selecionar todos os blocos.
- **Ctrl+D** — duplicar bloco (recusa em blocos únicos `multi:false`).
- **Delete** — remover bloco (ou o grupo selecionado).

## Componentes de UI reutilizáveis (`src/ui/`)
- **ui-basic.js** — componentes básicos (cards, campos, toasts).
- **glossary.js** — dicas de contexto e termos do sistema (aberto pela busca/`gloss`).
- **formula-field.js** — campo com realce de sintaxe de fórmulas (usa o `formula-engine`).
- **shortcuts.js** — atalhos acima.

## Motores por trás das telas
Fórmulas, dados e efeitos são detalhados em [[nexus-rpg-arquitetura]]; resumo:
`formula-engine` (funções `min/max/menor/maior/round/arredondar/floor/piso/ceil/teto/abs/modulo/se/if`),
`dice-engine` (`NdX`, `kh/kl/dh/dl`, vantagem/desvantagem que se cancelam, dice pool
estilo Ordem), migração de schema `SCHEMA=10` (migra de `SCHEMA_MIN=6`).
