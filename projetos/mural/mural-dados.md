---
name: mural-dados
description: mapa de localização de dados, repositório, chaves do LocalStorage e fluxo da API GitHub do projeto Mural
tags: [projeto, proj/mural, dados, api, github]
updated: 2026-09-28
---

# Mural — Onde os dados vivem

Mapa consolidado de repositório, chaves de armazenamento local e endpoints de dados para o [[mural]].

## 1. Repositório e Código

- **Pasta local do código:** `C:\Users\v.tozeti\Desktop\Vitor\teste\Vitor-mural`
- **Repositório remoto:** [github.com/VitorTozeti/Mural](https://github.com/VitorTozeti/Mural) (público, `origin/main` sincronizado com o local).
- **Hospedagem / Pages:** GitHub Pages (estático, sem backend proprietário) — site no ar em [vitortozeti.github.io/Mural](https://vitortozeti.github.io/Mural/).
- **Estrutura de arquivos:**
  - `index.html`: casca da aplicação, layout do quadro e modais.
  - `css/style.css`: textura de cortiça/quadro, post-its com rotação e responsividade.
  - `js/app.js`: orquestração do estado, UI e rotina de polling/sync.
  - `js/board.js`: canvas, lógica de drag-and-drop dos post-its/conexões e pan do quadro (arraste com mouse/toque em área vazia via Pointer Events, `scrollLeft`/`scrollTop` do `#board-container`).
  - `js/postit.js`: renderização dos blocos e templates dos post-its.
  - `js/crypto.js`: (legado, não carregado desde 2026-09-28) criptografia AES-GCM dos antigos post-its guardados.
  - `js/github.js`: integração REST com a GitHub Contents API.
  - `data.json`: persistência dos post-its versionada no repositório.

## 2. "Banco de dados" (GitHub Contents API)

- **Arquivo no repo:** `/data.json`
- **Endpoint:** `GET/PUT https://api.github.com/repos/{owner}/{repo}/contents/data.json`
- **Autenticação:** Fine-grained Personal Access Token com escopo restrito a `Contents: Read and write`.
- **Tratamento de conflito (HTTP 409):** o client obtém o novo `sha`, mescla/reaplica os dados e repete a requisição.
- **Cadência de polling:** 15 segundos + evento `focus` da aba do navegador (pausado enquanto se arrasta/edita).
- **Formato:** `{ version, updatedAt, postits: [...], links: [{id, from, to}] }`. Post-it: `id, author ('eu'|'ela'), text, color, size, status, secret, rotation, x, y, createdAt, resolvedAt?, reactions`.

## 2b. Preview local

- `.claude/launch.json` do vault tem a config `mural-static` (python http.server na porta 8792 servindo a pasta do código).

## 2b'. Armazenamento atual: Cloudflare D1 (commit `1ece63a`, 2026-09-28)

- As notas saíram do GitHub: ficam no banco **D1** ligado ao Pages com o nome de variável **`DB`**.
- Tabela `mural (id INTEGER PRIMARY KEY, data TEXT, version INTEGER)`, criada automaticamente; uma linha (`id = 1`) com o JSON inteiro.
- Controle de conflito: o campo `sha` do protocolo agora é o `version` do D1 (`UPDATE ... WHERE version = ?`; se não bateu → 409).
- `wrangler.toml` foi removido (ele faria o Pages ignorar ligações feitas pelo painel). Token do GitHub não é mais necessário.
- Sem senha: aceita só pedidos do próprio `muralzinho.pages.dev` (+ `ALLOWED_ORIGINS`, opcional).
- As seções abaixo sobre GitHub Contents API / `GITHUB_TOKEN` são **históricas**.

## 2c. Cloudflare Pages + Function (desde 2026-09-28)

- Site principal: **https://muralzinho.pages.dev** (Cloudflare Pages, deploy automático do `main`).
- Servidor: `functions/data.js` (Pages Function em `/data`) → reusa `worker/index.js`.
- Config: `wrangler.toml` na raiz, formato Pages (`name = "muralzinho"`, `pages_build_output_dir = "."`, vars `REPO`, `ALLOWED_ORIGINS`).
- Endpoint: `GET/PUT /data`. GET → `{sha, data}`; PUT `{data, sha}` → `{sha}` ou 409. Sem `MURAL_PASSWORD`, aceita só o próprio endereço + `ALLOWED_ORIGINS`.
- Painel do Pages: só o segredo **`GITHUB_TOKEN`** (Contents: Read and write no repo Mural). `MURAL_PASSWORD` opcional.
- Modelo local das variáveis: `worker/cloudflare.env` (no `.gitignore`, nunca commitar preenchido).

## 3. Armazenamento Local (LocalStorage)

Chaves mantidas localmente em cada navegador (nunca commitadas no repositório):
- `mural_author`: identificador do usuário (`kemily` — padrão — ou `eu`).
- `mural_custom_colors`: cores de post-it criadas pelo usuário (array hex, máx. 12).
- `mural_custom_theme`: `{board, dot, link, noDots}` da paleta "Personalizado" (`mural_theme = custom`).
- `mural_key`: senha do mural enviada ao Worker.
- `mural_server_url`: endereço do Worker, se diferente do `WORKER_URL` fixo.
- (legado, não usados desde o Worker: `mural_github_token`, `mural_github_repo`.)
- `mural_local_data`: cache offline do último estado do `data.json`.
- `mural_theme`: paleta do fundo (`claro|creme|cinza|azulado|rosado|escuro`).
- `mural_last_color`: última cor de post-it usada.
- `author_color_<autor>`: cor da etiqueta do autor.
