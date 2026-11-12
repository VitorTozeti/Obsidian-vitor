---
name: mural
description: mural de post-its interativo para duas pessoas, leve e com post-its guardados/criptografados sincronizados via GitHub
tags: [projeto, proj/mural, app, postits, web, sincronizacao]
updated: 2026-09-28
---

# Mural de Post-its para Conversas

Um mural de post-its só para duas pessoas, com assuntos que queremos conversar, post-its customizáveis e post-its "guardados" que só aparecem quando quem criou decide revelar.

## Estado atual (2026-09-28)

- **Zoom do quadro — pinça no celular, ctrl+scroll e botões +/- (2026-09-28, publicado no `main` no commit `3d375fc`):**
  - `js/board.js`: `#board` ganhou escala via CSS `transform: scale()` (`transform-origin: 0 0`); `BoardModule` guarda `scale` (limite `0.4`–`2.5`) e reescreve o gesto de pan/drag para rastrear até 2 ponteiros por `pointerId` (`activePointers`).
  - **Pinça (touch):** ao detectar 2 ponteiros simultâneos no `#board-container`, cancela o pan e entra em modo `pinch`; a cada `pointermove` recalcula a escala pela razão da distância entre os dois dedos e reposiciona `scrollLeft/scrollTop` para manter o ponto do mural sob o centro dos dedos fixo na tela (testado via `PointerEvent` sintético no preview: ponto de foco ficou bit a bit igual antes/depois do gesto).
  - **Desktop:** `ctrl/cmd + scroll` no `#board-container` também ajusta o zoom, com o mesmo foco no cursor (trackpad de notebook manda `ctrlKey` no gesto de pinça).
  - **Botões:** novo `#zoom-controls` (canto inferior direito, dentro do `#board-container`) com `+`, rótulo clicável mostrando `%` atual (reseta pra 100% ao clicar) e `−`; usa o centro do container como foco.
  - Drag de post-it (`startDrag`/`onPointerMove`) e criação por duplo clique (`toBoardCoords`) foram ajustados para dividir o delta de tela pela escala atual — sem isso o post-it "escorregaria" do cursor/dedo quando dado zoom ≠ 100%. Validado no preview: post-it acompanha o dedo/mouse exatamente com zoom em 150%.
  - `css/style.css`: `#board { transform-origin: 0 0 }` e estilo de `.zoom-controls`/`.zoom-btn` usando as variáveis de tema (`--ui-bg`, `--ui-border`, `--ui-hover`, `--ui-text`) — some junto com o tema escolhido.
  - Meta `viewport` continua com `user-scalable=no`: o zoom nativo do navegador fica desligado de propósito (conflitaria com o pan/zoom customizado); todo o zoom é este controle próprio.
  - Testado no preview local (`mural-static`, porta 8792) em viewport mobile (375×812): botões de zoom funcionam, e gestos de pinça/drag simulados via `PointerEvent` no console confirmam a matemática do foco e do arraste sob zoom.

- **Quadro sem scrollbar + pan por arraste (2026-09-28, publicado no `main` no commit `47e0166`):**
  - `#board-container` (`css/style.css`) ganhou `scrollbar-width: none`, `-ms-overflow-style: none` e `::-webkit-scrollbar { display: none }` — barras de rolagem horizontal/vertical ficaram invisíveis, mas o container continua `overflow: auto` (ainda navegável).
  - `js/board.js` ganhou pan do quadro: `pointerdown` em área vazia do `#board-container` (excluindo `.postit`, `.link-hit`, `.link-handle`, botões, inputs e `#composer`) inicia arraste que move `scrollLeft`/`scrollTop` direto; classe `.is-panning` troca o cursor para `grabbing` (padrão `grab`).
  - Funciona também por toque (mobile/tablet) sem handlers separados, porque tudo já roda em Pointer Events unificados e `#board-container`/post-its já tinham `touch-action: none`.
  - Testado no preview local (`mural-static`, porta 8792): pan por arraste do mouse funciona, post-it individual continua arrastável sem disparar o pan do quadro, e o layout se comporta bem em viewport mobile (375×812) sem scrollbar visível.
  - Commit `47e0166`, push feito no `main`; deploy automático no Cloudflare Pages.

- **Fase:** **Esqueleto completo (MVP + V2 + Extras de UX)** implementado e funcional em `C:\Users\v.tozeti\Desktop\Vitor\teste\Vitor-mural`.
- **Arquitetura aplicada:**
  - Front-end modular HTML5, CSS e JS nativo sem frameworks pesados.
  - Temas visuais (Cortiça, Madeira, Escuro) e suporte a arrastar com mouse ou touch em smartphones/tablets.
  - Post-its customizáveis (6 cores, 5 fontes manuscritas, 3 tamanhos, rotações orgânicas, badges de sensibilidade do assunto e reações rápidas ❤️/👀/😅).
  - Post-its guardados com criptografia de ponta a ponta (Web Crypto API AES-GCM + PBKDF2) e dicas públicas.
  - Sincronização Serverless via GitHub Pages com polling de 15s e tratamento automático de conflitos (HTTP 409).
  - Gaveta de Histórico de conversas resolvidas com opção de reabertura rápida.
- **Repositório e site no ar:** código sincronizado com `origin/main` em [github.com/VitorTozeti/Mural](https://github.com/VitorTozeti/Mural); GitHub Pages ativo em [vitortozeti.github.io/Mural](https://vitortozeti.github.io/Mural/) (confirmado carregando o mural em produção) — mas essa versão publicada ainda é a **anterior à leva de polish de UX abaixo** (ver "pendente de commit").
- **Leva de polish de UX/UI feita localmente em 2026-09-28** (arquivos modificados na pasta local, ainda **não commitados nem enviados ao GitHub**):
  - Botão dedicado de alternância de tema (🎨 cicla Cortiça → Madeira → Escuro) e barra de filtros rápidos por status (Todos / Quero falar / Em pauta / Resolvidos).
  - Sistema de notificações toast e indicador visual de status de sincronização (online/offline/sincronizando) na barra superior.
  - Modais redesenhados com cabeçalho/corpo/rodapé consistentes; modal dedicado para revelar post-it guardado (substituiu o `prompt()` do navegador) e modal de Histórico com botão de reabrir.
  - Cor de identificação do autor customizável (paleta na tela de Configurações) e reações rápidas (❤️/👀/😅) agora contam por autor e ficam destacadas quando o próprio usuário já reagiu.
  - Ações rápidas no rodapé do post-it (✅ resolver/↩️ reabrir, ✏️ editar, 🗑️ excluir) e suporte a arrastar por toque (mobile) via `touchstart/touchmove/touchend`.
  - `README.md` do repositório já atualizado descrevendo esse conjunto de funcionalidades.
- **Redesign "mural branco" + simplificação (2026-09-28, publicado no `main` no commit `9574337`):**
  - Fundo liso branco com pontilhado sutil; 6 paletas de fundo (Branco, Creme, Cinza, Azulado, Rosado, Escuro) num menu 🎨.
  - Fonte única **Nunito** (substituiu as 5 fontes manuscritas) — mais legível.
  - 12 cores de post-it; última cor usada fica lembrada.
  - **Criação rápida:** duplo clique no mural abre o post-it editável naquele ponto (ou botão "+ Post-it" / tecla **N**); Enter salva, Shift+Enter quebra linha, Esc cancela. Removido o modal grande, emoji, fonte e "tom/delicadeza".
  - **Conexões estilo Obsidian:** bolinha **+** na borda do post-it → arrastar até outro cria uma linha; clicar na linha remove. Salvas em `links` no `data.json`.
  - **Secreto:** checkbox "só eu vejo" (`secret: true`) — o post-it (e as linhas até ele) só aparece para o autor. Substituiu a criptografia com senha; `js/crypto.js` não é mais carregado (arquivo ainda existe, pode ser apagado).
  - **Histórico removido** — resolvidos aparecem no filtro "Resolvidos" (e esmaecidos em "Todos").
  - ⚠️ O secreto esconde só na interface: o texto continua legível no `data.json` do repositório público.
- **Cores personalizáveis + Kemily (2026-09-28, commit `4485cc0` no `main`):**
  - Usuários: **Kemily** (`kemily`, padrão quando nada está salvo) e **Vitor** (`eu`). O antigo `ela` é exibido como Kemily.
  - Post-it aceita qualquer cor (seletor "🎨 Outra cor"); cores novas viram quadradinhos na paleta (até 12, clique direito remove). Cor escura → texto claro automático.
  - Menu 🎨 tem seção "Personalizado": cor do fundo, dos pontinhos, das linhas e opção "sem pontinhos".
- **Sincronização via Cloudflare Worker (2026-09-28, commit `7f667a7` no `main`):**
  - O site não fala mais direto com o GitHub: chama o Worker (`worker/index.js`, config `wrangler.toml` na raiz, nome `mural`), que guarda o token em segredo e lê/grava o `data.json`.
  - O site pede só a **senha do mural** (uma vez por aparelho) + endereço do servidor em ⚙️. Senha errada → "Senha incorreta" e abre ⚙️.
  - Se o mural remoto estiver vazio e o aparelho tiver notas locais, elas são enviadas (não apagadas).
  - Colocar o token direto no site foi descartado: repo público → GitHub revoga o token e qualquer um poderia editar.
  - **Senha opcional (commit `510558b`, a pedido do Vitor):** sem o secret `MURAL_PASSWORD`, o Worker aceita só pedidos com `Origin` em `ALLOWED_ORIGINS` — conecta sem digitar nada. Risco aceito pelo usuário: quem souber o endereço do Worker pode editar o mural (histórico do `data.json` no GitHub serve de backup).
  - **Virou Cloudflare Pages (commit `b7160e1`):** o projeto no Cloudflare é **Pages** em [muralzinho.pages.dev](https://muralzinho.pages.dev), ligado ao repo (deploy a cada push). O servidor roda como Pages Function em `functions/data.js` → `/data` (reusa `worker/index.js`). `WORKER_URL` fixo em `https://muralzinho.pages.dev`; o próprio endereço é liberado automaticamente (usa `Origin` ou `Referer`, pois GET do mesmo site não manda `Origin`).
  - **Notas no Cloudflare D1 (commit `1ece63a`):** substituiu o GitHub como armazenamento — sem token, sem dados no repo público, sem commit/deploy a cada nota. Ligação no painel do Pages: D1 com nome `DB`. Ver [[mural-dados]].
  - (histórico) `wrangler.toml` na raiz estava no formato Pages (`pages_build_output_dir = "."`) e define `REPO`/`ALLOWED_ORIGINS`; **única variável no painel: segredo `GITHUB_TOKEN`**.
- **Próximos passos:**
  - Revisar o `git diff` local, commitar e dar `git push` para publicar essa leva de UX no GitHub Pages (arquivos alterados: `css/style.css`, `index.html`, `js/app.js`, `js/board.js`, `js/postit.js`; `README.md` está novo/untracked).
  - Gerar o Fine-grained Personal Access Token para os dois (Vitor e ela) e configurar cada um na tela de engrenagem ⚙️ do site.
  - Testar o uso em tempo real nos dois navegadores/celulares (criar post-it de um lado, confirmar que aparece do outro dentro do polling de 15s).
- **Onde os dados vivem:** consulte [[mural-dados]] para o mapa de persistência e repositório.

## Notas detalhadas do projeto

- [[mural-dados]] — mapa de localização de dados, repositório, chaves do LocalStorage e fluxo da API GitHub
- [[planejamento-mural-postits]] — especificação completa de design, funcionalidades e fases
