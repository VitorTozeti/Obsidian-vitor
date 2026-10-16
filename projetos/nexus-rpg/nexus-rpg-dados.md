---
name: nexus-rpg-dados
description: mapa de localização de dados, repositório, chaves do LocalStorage e arquitetura de arquivos do Nexus RPG
tags: [proj/nexus-rpg, dados, infra, arquitetura]
updated: 2026-10-16
---

# Nexus RPG — Onde os Dados Vivem

Nota de localização técnica e persistência do projeto [[nexus-rpg]].

## Repositórios e Links

- **Repositório Local no Disco:** `C:\Users\Vitor\Desktop\projetos\The-One-System` (máquina original)
  - **Nesta máquina (v.tozeti):** `C:\Users\v.tozeti\Desktop\Vitor\teste\The-One-System`
- **Repositório GitHub:** `VitorTozeti/The-One-System` (`https://github.com/VitorTozeti/The-One-System`)
- **Deploy / Execução:** 100% offline, executável diretamente via navegador abrindo `index.html` (protocolo `file://`). Não requer servidor HTTP local nem etapas de build.

## Estrutura de Arquivos e Código-fonte

O projeto não utiliza bundlers (Vite/Webpack) nem módulos ES para manter a portabilidade direta via `file://`. A aplicação é composta por scripts clássicos ordenados em `index.html`:

```
index.html                  # Casca HTML e inclusão sequencial de scripts
assets/css/styles.css       # Folha de estilo global e variáveis CSS em :root
src/
  auth/
    accounts.js             # Modelagem de contas, sessões e isolamento de personagens
    auth-ui.js              # Telas de login, registro e seleção de personagens
  core/
    helpers.js              # Utilitários de DOM (h/node), persistência e strings
    formula-engine.js       # Tokenizer e avaliador de fórmulas matemáticas
    dice-engine.js          # Parser e executor de rolagens de dados
    state.js                # Estado global reativo (S) e despachante de renderização
    history.js              # Pilhas de Desfazer/Refazer (Undo/Redo)
  data/
    example-system.js       # Definição do sistema de exemplo e migração de ficha
    arquetipos.js           # Motor de classes/origens: fórmulas de recurso, técnicas, resistências, efeito por código
  ui/
    atributos-pericias.js   # Abas Atributos e Perícias (criação rápida + biblioteca de 41 perícias) — 2026-10-14
    classes-origens.js      # Editor de Classes/Origens (master-detail, técnicas, traços, código) — [[nexus-rpg-classes-origens]]
    master-detail.js        # Layout lista+editor reutilizável (mdLayout/mdCab/mdAbas…) — [[nexus-rpg-editores-itens]]
    icon-picker.js          # Seletor de ícones (iconePicker) — [[nexus-rpg-codigo-icones-tecnicas]]
    codigo-editor.js        # Editor de efeito por código (realce, autocomplete, montar, prévia)
    tecnicas-editor.js      # Modelos de técnica, uso/liga-desliga (usarHabilidade)
    itens-editor.js         # Itens: abas Básico/Combate/Efeitos/Uso, biblioteca com mecânica, usarItem
    recursos-tecnicas.js    # Recursos (fórmula/recarga/quem mexe) e tiers de técnica com simulador
    shortcuts.js            # Mapeamento de atalhos de teclado do editor
    ui-basic.js             # Componentes reutilizáveis de interface
    glossary.js             # Dicas de contexto e termos do sistema
    formula-field.js        # Campo com realce de sintaxe de fórmulas
  master/
    master-nav.js           # Barra de navegação e abas do Mestre
    master-pieces.js        # Formulários das 16 peças do sistema
  player/
    player.js               # Assistente de criação e renderizador da ficha
  app.js                    # Bootstrap final e chamada de inicialização render()
```

### Ordem Estrita de Carregamento (`<script>`)
Por utilizarem escopo global, a ordem das tags `<script>` no `index.html` é crítica:
1. `core/helpers` → `core/formula-engine` → `core/dice-engine`
2. `data/example-system`
3. `core/state` → `core/history`
4. `ui/*`
5. `master/*`
6. `player/player`
7. `app.js` (executa por último disparando a renderização inicial)

## Armazenamento e Persistência de Dados (LocalStorage)

Todos os dados da aplicação residem no `localStorage` do navegador do usuário:

| Chave | Formato | Conteúdo |
|---|---|---|
| `nexus_accounts` | JSON Array | Lista de contas: `[ { id, name, salt, hash, algo, createdAt } ]` — senha como **hash salgado** (SHA-256 × 12 000, JS puro síncrono). Contas antigas com `pass` em texto são convertidas no próximo login. |
| `nexus_session` | JSON Object | Sessão ativa: `{ accountId, personagemId }` |
| `nexus_acct_<id>` | JSON Object | Dados da conta: `{ personagens: [ { id, kind, name, system | draft+saved } ] }` |

> ⚠️ **Nota sobre segurança de credenciais:** o app foi concebido como protótipo offline e armazena senhas em texto puro no `localStorage`. Não utilize senhas reais.

## Mesa (mapa + tokens) — 2026-10-14

- Editor de mapas antigo **removido** (`campaign-map.js`, `map-editor.js`, `map-gen.js`); no lugar, `src/master/campaign/mesa-mapa.js` + `assets/css/mapa.css`. Detalhes em [[nexus-rpg-mesa-tokens]].
- Campos novos em `campaign`: `tokenCats[]`, `tokenLib[]`, `tokenConds[]`; em cada mapa: `aspect`; em cada token: `conds[]`, `libId`; em cada atributo: `desc`. `sanitizeCampaign` migra tudo.
- `render()` (state.js) agora preserva rolagem/foco na mesma tela.
- O preview local usa o servidor `the-one-system` (porta 8794) cadastrado em `.claude/launch.json` deste vault.

## Mapas — campos e arquivos (2026-10-13, **histórico**: substituídos pela Mesa)

- Arquivo `src/master/campaign/map-gen.js` (geradores). Em `campaign.maps[]`: `genMeta {g,seed}`, `compass`, `scale {on,total,unit}`, `grid.type` (`square`|`hex`); pins/props/reinos gerados têm `gen:true`. A imagem gerada fica em `m.image` (JPEG). Detalhes em [[nexus-rpg-mapas-geradores]].
- Backup da conta: botão **💾 Backup** → JSON `nexus-backup-AAAA-MM-DD.json` (`{app,versao,conta,exportadoEm,dados}`).

- **v2 (2026-10-13):** mapas ganham `objs/bg/fx`; campanha ganha `notebook, handouts, combat, clocks, resources, tables, xp, present, meta, prep`; formato `.campanha` v1 e backup de conta restaurável — ver [[nexus-rpg-v2-sistema-mapa-campanha]].

## Arquivos Intermediários e Formatos de Exportação

- **Arquivos `.nexus` (JSON):** formato completo de exportação e importação de sistemas de RPG (regras, fórmulas, tabelas, blocos de ficha e configurações de campanha).
- **Versionamento de Schema:** mantido no código como `SCHEMA = 10`, suportando migração automática para estruturas salvas a partir do schema 6.

## Ver também
- [[mapa-dados]] — hub de todas as notas de dados · ⭐[[mapa-projetos]]

## 2026-10-14 — Rolagem preservada ao editar
- `render()` em `src/core/state.js` agora também guarda/restaura a rolagem **interna** (painéis laterais, listas, `.mpane-body`, `.mt-side`…) via `capturaRolagem`/`restauraRolagem`, além do scroll da janela e do foco. O `painel-aberto` é aplicado antes de restaurar (evita deslocamento de layout).
- `dashboard.js` refocus usa `focus({preventScroll:true})`.

## 2026-10-14 — Paletas de cores (temas)
- Novo `src/ui/temas.js` (carregado 1º no `index.html`): 8 paletas (Noite, Meia-noite, Oceano, Floresta, Vinho, Grafite, Claro, Pergaminho, Alto contraste) + **Personalizada** (4 cores: fundo, painéis, texto, destaque; o resto é derivado com `color-mix`). Botão 🎨 flutuante (canto inferior esquerdo), fora do `#root` → trocar tema não chama `render()`. Salvo em `localStorage` (`nexus-tema`, `nexus-tema-custom`).
- CSS: cores fixas viraram variáveis (`--surf`, `--surf2`, `--line2`, `--acc-txt`, `--warn-txt`, `--rose-txt`, `--ok-txt`). Canvas da ficha, mapas e tela de apresentação continuam escuros de propósito.
- **Ainda sem commit** (a pedido do usuário, aguardando aprovação).

## 2026-10-16 — Gatilhos, contador, CSP e senha com hash
Resposta ao teste às cegas [[nexus-rpg-teste-rezero-ux]].
- **Novos arquivos:** `src/core/gatilhos.js` (motor + editor da aba ⚡ Gatilhos do recurso; carregado depois de `history.js`) e `assets/css/melhorias.css` (carregado por último).
- **Recurso (`sys.resources[]`) ganhou:** `start` (fórmula "Começa em"; vazio = começa cheio), `contador` (bool; só rótulo/atalho, equivale a `start:'0'`) e `gatilhos:[{id,quando:'zero'|'cheio',acoes:[{k:'restaurar'|'somar'|'aviso',alvo,modo,n,texto}]}]`. `sys.semNiveis` (bool) esconde nível no app. Tudo validado em `migrateSystem` (arquivo importado pode vir malformado; limites de 20 gatilhos/20 ações).
- **Ficha:** `computeSheet` devolve `inicio` por recurso; `recursosInner/setRes` chama `executarGatilhos` (só no modo `play`). `aplicarDescanso` usa `inicio`.
- **Combate/Bestiário:** `x.res[resId]={cur,max}` por combatente (`cbIniciaRecursos`); `statblock.recs[resId]` = máximo manual do inimigo (vazio = fórmula do sistema com os atributos do statblock).
- **Mesa:** `focarPainel(k)` (scroll + flash ao abrir painel); botão "🧪 Adicionar meu personagem de teste" cria player `{teste:true, sheet:<draft>}`.
- **Render:** `render()` guarda no `mousedown` qual campo foi clicado e devolve o foco depois de reconstruir (causa raiz do "texto digitado some": `onchange`→`render()` trocava o DOM antes do foco chegar). `ajustaBlocosJogo` faz os blocos da ficha do jogador crescerem até caber o conteúdo (sem rolagem interna) e empurra os de baixo.
- **Segurança:** `<meta http-equiv="Content-Security-Policy">` em `index.html` — `connect-src 'none'`, `default-src 'none'`, `script-src 'self' 'unsafe-eval'` (eval só por causa do "efeito por código"), estilos inline permitidos. Nada sai do navegador, nem por código liberado. Sistema importado continua chegando com `codigoBloqueado`.
- **Dev:** `python -m http.server` entrega 52 scripts em série e o navegador pode cachear versões velhas — para testar use um servidor com `Cache-Control: no-store` e **espere ~6 s** antes de ler a página (uma leitura em branco logo após o carregamento foi só lentidão, não bug).
