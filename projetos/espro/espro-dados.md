---
name: espro-dados
description: onde os dados do projeto ESPRO vivem — pasta do código, repositório, armazenamento (a definir)
tags: [projeto, proj/espro, dados]
updated: 2026-10-06
---

# ESPRO — Onde os dados vivem

Mapa de dados do [[espro]].

## 1. Código
- **Pasta local:** `C:\Users\v.tozeti\Desktop\Vitor\teste\Espro`.
- **Repositório remoto:** `https://github.com/VitorTozeti/Espro_frame` (`main`).
- **Hospedagem:** Cloudflare (Pages + Functions/Workers).

- **Arquivos:** `index.html`, `css/style.css`, `js/store.js` (estado + persistência), `js/ui.js` (helpers, sheet, ícones), `js/rich.js` (sanitizador, editor de texto rico), `js/editor.js` (editor de páginas em tela cheia), `js/extras.js` (modelos, planejar, biblioteca, Ctrl+K), `js/qualidade.js` (verificador, exportar, apresentar), `js/equipe.js` (comentários, revisão, versões, alertas), `js/sync.js` (cliente de sincronização), `functions/` + `schema.sql` + `wrangler.toml` (servidor), `js/views.js` (4 telas e formulários), `js/app.js` (roteador por hash), `manifest.webmanifest`, `README.md`.
- **Estado hoje:** **IndexedDB** (banco `espro`, store `kv`, chave `state`; fallback localStorage `espro.v1` se o navegador não oferecer), campo `v:2` (empresa, setores, cards, eventos, paginas); imagens da revista guardadas como data-URL JPEG ≤1000px (limite ~5MB do navegador → migrar para R2).
- **Servidor de preview:** `espro-static` (porta 8793) em `Obsidian-vitor/.claude/launch.json`.

## 2. Dados previstos (modelo inicial)
- **Empresa** — nome, missão, logo, setores.
- **Setores / membros** — quem pertence a qual setor.
- **Revista / edições** — páginas, ordem, template, capa.
- **Matérias** — texto, imagens, autor, setor, status.
- **Quadro (kanban)** — colunas, cartões (título, setor, responsável, prazo, matéria vinculada, criador, criadoEm).
- **Eventos (calendário)** — título, início/fim, dia inteiro, setor, responsável, tipo (reunião/prazo/evento), cartão ou matéria vinculada.

## 3. Armazenamento (Cloudflare)
- **D1 (SQLite):** empresa, setores, membros, edições, matérias, cartões e eventos.
- **R2:** imagens e arquivos da revista (uploads).
- **Pages Functions / Workers:** API (`/api/...`) entre o site e o D1/R2.
- Mesmo padrão já usado no [[mural-dados]] (Cloudflare D1/Pages).

## 4. Ordem dos cartões
- A ordem visual de cada coluna é a ordem do array `cards` (função `Store.placeCard(id, col, beforeId)`); na futura tabela D1 isso vira uma coluna `posicao`.
- Cada cartão possui metadados de autoria: `criador` (nome do usuário logado ou perfil local) e `criadoEm` (timestamp ms da criação).

## 5. Páginas da revista
- Cada página: `id, tpl, titulo, texto, img, secao (id do setor ou ''), status (rascunho|revisao|pronta)`. A ordem final é calculada (`ordenadas()`/`folhas()` em `js/views.js`); aberturas de seção **não** são gravadas, são geradas na hora. Na tabela D1 vira `paginas(posicao, secao_id, status, ...)`.

## 6. Texto rico e imagens (formato novo da página)
- Página: `html` (HTML sanitizado: p, h2, h3, b, i, u, s, listas, blockquote, a, span com `color`, classes `fs-sm|fs-lg|fs-xl` e `ff-serif|ff-sans|ff-mono`, `text-align`), `texto` (versão só texto), `colunas` (1|2) e `imgs: [{src, pos, tam, forma, legenda}]` (`pos`: fundo|topo|acima|esquerda|direita|abaixo). Páginas antigas (`texto` + `img`) são convertidas na leitura (`conteudo()` / `imagensDe()`).
- As imagens são data-URLs ≤1000px dentro do JSON (limite ~5MB do localStorage) → no D1 o `html` vai em coluna TEXT e as imagens para o R2 (guardar só a URL em `imgs[].src`).

- **Imagem livre:** `{src, pos:'livre', x, y, w, h, rot, atras, forma, legenda}` — `x,y,w` em % da largura da folha e `y,h` em % da altura (folha A5 148×210); `rot` em graus; `atras:true` fica atrás do texto. Imagens livres têm `position:absolute` na página (índice no array = ordem de empilhamento).

## 7. Objetos da página (Fase 1 do editor)
- A página guarda `objs: []` (substitui `imgs`): imagens `{tipo:'img', src, pos, tam, forma, legenda, x,y,w,h,rot,atras}` e **caixas de texto** `{tipo:'texto', html, x,y,w,h, rot, atras, fundo}` (`fundo`: ''|branco|sec|preto|amarelo). A posição no array é a ordem de empilhamento. `Store.upsert(kind,item,{silent:true})` grava sem re-renderizar (usado pelo autosave); `Store.remove` devolve `{item,index}` e `Store.restore` desfaz.

## 8. Fases 2–5: novos campos e coleções
- **Imagens/objetos:** `fx, fy, cz` (recorte: ponto focal % e zoom), `alt`, `ph` (imagem de exemplo); quadro do texto móvel em `pagina.quadro = {x,y,w,h,rot}`; `pagina.fonte` (escala 0.6–1 do texto corrido); `pagina.cardId` ↔ `card.paginaId`.
- **Mídia:** `state.midia = {id: dataURL}`; as páginas guardam `src:'img:<id>'` (hash do conteúdo, sem duplicar). `img:ph` = imagem de exemplo.
- **Novas coleções:** `comentarios [{id,paginaId,autor,texto,quando,resolvido}]`, `versoes [{id,paginaId,quando,autor,motivo,snap}]`, `apagados [{kind,id,_u}]` (tombstones), `marca {cores}`, `_metaU {empresa,marca}`.
- **Sincronização:** todo item sincronizável tem `_u` (ms; "último a editar vence"). Cliente: `localStorage espro.auth` (token) e `espro.sync` (cursor, lastPush, ordem, mídia enviada). Servidor (`functions/_lib/api.js`): `POST /api/login`, `POST /api/sync` (push + pull por cursor `rev`), `GET|PUT /api/midia/:id`, `POST /api/presence`, `GET /api/ping`. Token = `base64(json).HMAC-SHA256`, vale 30 dias. D1: tabelas `items(kind,id,u,del,data,rev)`, `meta(rev)`, `midia`, `presence`.
- **Limites conhecidos:** relógios dos aparelhos entram na regra "último vence"; D1 guarda a mídia em linhas de até ~3 MB (se crescer, migrar para R2); sem edição simultânea em tempo real (só aviso de presença).

## 9. Edições, identidade da marca e link público (2026-10-05)
- **Edições:** `state.edicoes [{id, numero, nome, data, status: andamento|publicada, pub?: {id, em}, _u}]` (sincroniza). Cada página guarda `ed` (id da edição; páginas antigas sem `ed` vão para a 1ª edição na migração `ensureEd()` em `js/store.js`). `state.edicaoAtiva` é escolha **local do aparelho** (não sincroniza). API: `Store.paginasEd(id?)`, `Store.edicaoAtual()`, `Store.setEdicaoAtiva(id)`; `ordenadas(ed)`/`folhas(ed)` aceitam o id da edição. **Cartões do Quadro, eventos e setores são globais** (não por edição).
- **Estante:** `js/edicoes.js` (rota `#/edicoes`, 5ª aba "Edições"): cartões com miniatura da capa, progresso, Abrir/Ler/Link/⋯; "Nova edição" = em branco, copiar estrutura (páginas vazias) ou duplicar inteira; editar nº/nome/data/situação; excluir (confirma, apaga as páginas).
- **Identidade:** `js/marca.js`. `state.marca = {cores, primaria, fonte, slogan, logo:'img:<id>'}` (sincroniza como `meta marca`). `aplicarMarca()` injeta `<style id="marca-style">` (`--accent`, `--accent-ink`, `--accent-soft`, `--serif`), fonte Google escolhida, favicon SVG dinâmico; logo/monograma no cabeçalho, capa e contracapa. Fontes: Fraunces, Playfair Display, DM Serif Display, Lora, Space Grotesk, Poppins.
- **Link público + QR:** botão "Link" da edição. Cliente gera `htmlLeitura(edId, true)` (`js/qualidade.js`, imagens trocadas por `/api/pm/<id>`) e envia `POST /api/publicar {id,nome,html}` (precisa estar logado na equipe; id aleatório 18 chars). Servidor (`functions/_lib/api.js`): `GET /api/p/<id>` (HTML público, CSP restrita), `GET /api/pm/<mid>` (imagem pública por hash), `POST /api/publicar`, `DELETE /api/publicar/<id>`. D1: nova tabela `publico(id, nome, html, u)` — **rodar `wrangler d1 execute espro --remote --file=schema.sql` de novo**. QR gerado no navegador com `qrcode-generator` (CDN cdnjs, carregado só ao abrir o sheet). Limite: HTML ≤ 1,8 MB (D1 ≤ 2 MB por linha). Lógica da API testada com repositório em memória no navegador; **D1 real ainda não testado**.

## 10. Contas e cargos (2026-10-05)
- **Publicado em** `https://espro-frame.pages.dev` (projeto Pages `espro-frame`, repo `VitorTozeti/Espro_frame`, deploy automático a cada push na `main`). D1 `espro` (id `ced36175-205d-4871-a3a5-6ece9932401f`, em `wrangler.toml`).
- **Login trocado** do código único da equipe (`TEAM_CODE`, removido) para **e-mail + senha**: `POST /api/registrar`, `POST /api/login`. Senha com PBKDF2-SHA256 (100 mil voltas, salt por conta) na tabela `usuarios(email, nome, cargo, salt, hash, criado)`. **Sem segredos no painel**: a chave que assina os tokens é criada sozinha na tabela `config` (opcional `TOKEN_SECRET`), e todas as tabelas são criadas sozinhas no 1º acesso (`preparar()` em `functions/_lib/d1.js`).
- **Cargos:** `admin` (fixo pelo e-mail `vitortozeti@gmail.com`, opcional `ADMIN_EMAIL`), `gestor` e `membro` (sem cargo, padrão de quem cria conta). Cargo lido do banco a cada requisição (mudança vale na hora; conta removida perde o acesso). Só o admin muda cargos/remove contas (`GET/PUT/DELETE /api/equipe`, tela "Gerenciar cargos" no menu da empresa → Equipe na nuvem). **Regra provisória:** só gestor/admin publica ou despublica o link público (403 para os demais) — a definir o que mais o gestor pode fazer.
- **Risco:** o cadastro é aberto e o e-mail não é verificado; quem registrar `vitortozeti@gmail.com` primeiro vira admin → **criar a conta do admin antes de divulgar o link**. Sem limite de tentativas de senha.
- Lógica da API testada no navegador (18 casos, repositório em memória); **D1 real ainda sem teste de ponta a ponta**.
- **Portão de login (2026-10-05):** o app só abre depois de entrar (e-mail + senha) ou criar conta (nome de usuário + e-mail + senha) — overlay `.portao` em `js/app.js`; reaparece ao sair da equipe. Sem conexão com o servidor não dá para fazer o 1º login (quem já entrou segue logado por 30 dias).
- **Persistência na nuvem testada (2026-10-05):** push/pull no D1 real do site publicado funcionam (cartões, eventos, páginas, edições, setores, empresa). **Bug achado e corrigido:** no 1º login de um aparelho novo, os dados padrão (setores, edição nº 1, páginas, empresa "Minha Empresa") eram enviados como novos → **setores/edições duplicados** e **nome da empresa sobrescrito**. Agora `Store.ehNovo()` detecta aparelho "virgem" e `Sync.conectar` adota os dados do servidor sem enviar nada (`aplicar(pull, true)` em `js/sync.js`). Ao sair da aba, as pendências são enviadas na hora (`visibilitychange`). Banco limpo por tombstones (2º conjunto de padrões duplicado + 2 itens de teste). Existe uma conta de teste `teste.sync.367@example.com` no D1 (remover em "Gerenciar cargos"). O nome da empresa no banco voltou para "Minha Empresa" (sobrescrito antes da correção).

## 11. Diário de bordo e setor por pessoa (2026-10-06)
- **Setor por pessoa:** coluna `usuarios.setor` (id do setor; criada sozinha via `ALTER TABLE` em `preparar()`, também em `schema.sql`). Só o admin define (`PUT /api/equipe {email, setor?, cargo?}` — setor vale até para o admin; cargo do admin segue fixo). `GET /api/equipe`, login/registro e `ping` devolvem `setor`. Tela "Gerenciar cargos" ganhou um select de setor por pessoa. Cliente: `Sync.setor()`, `Sync.email()`, `Sync.equipe()` / `Sync.carregarEquipe()` (lista de contas lida por qualquer logado).
- **Diário de bordo** (`js/diario.js`, rota `#/diario`, 6ª aba "Diário"): **uma pessoa por quinta-feira**, rodízio pela **ordem alfabética das contas** (`ordemAlfa`) a partir da quinta de referência `2026-01-01`: `índice = semanas desde a referência mod nº de contas`. Mostra a quinta mais recente + responsável + setor, as próximas 4 quintas e o histórico (8 a 52 semanas).
- **Dados:** `state.diario [{id:'q-<ISO da quinta>', data, texto (≤4000), autorEmail, autor, setor, _u}]` — um registro por quinta (id fixo → "último a editar vence"); `diario` entrou em `SYNC_KINDS` e em `KINDS` da API. Escreve/edita quem é o responsável da quinta **ou** gestor/admin (regra só na interface; o servidor `sync` é genérico).
- **Limite conhecido:** o rodízio é calculado, não gravado — entrar/sair conta **desloca as quintas futuras e as passadas sem registro**; quintas com registro mantêm o autor gravado. Não testado com D1 real (só no navegador com a equipe simulada).

- **Revisão (2026-10-06):** o Diário **não tem mais texto nem histórico** — só marca quem é a pessoa de cada quinta (atual + próximas 4). **Só o admin** troca (lápis → grava `state.diario [{id:'q-<quinta>', data, autorEmail, autor}]` como exceção ao rodízio; "Voltar ao automático" apaga). O servidor ignora `diario` no `sync` se o cargo não for admin.
