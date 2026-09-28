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
- **Hospedagem / Pages:** GitHub Pages (estático, sem backend proprietário).
- **Estrutura de arquivos:**
  - `index.html`: casca da aplicação, layout do quadro e modais.
  - `css/style.css`: textura de cortiça/quadro, post-its com rotação e responsividade.
  - `js/app.js`: orquestração do estado, UI e rotina de polling/sync.
  - `js/board.js`: canvas e lógica de drag-and-drop.
  - `js/postit.js`: renderização dos blocos e templates dos post-its.
  - `js/crypto.js`: derivação PBKDF2 e criptografia AES-GCM via Web Crypto API nativa.
  - `js/github.js`: integração REST com a GitHub Contents API.
  - `data.json`: persistência dos post-its versionada no repositório.

## 2. "Banco de dados" (GitHub Contents API)

- **Arquivo no repo:** `/data.json`
- **Endpoint:** `GET/PUT https://api.github.com/repos/{owner}/{repo}/contents/data.json`
- **Autenticação:** Fine-grained Personal Access Token com escopo restrito a `Contents: Read and write`.
- **Tratamento de conflito (HTTP 409):** o client obtém o novo `sha`, mescla/reaplica os dados e repete a requisição.
- **Cadência de polling:** 15 segundos + evento `focus` da aba do navegador.

## 3. Armazenamento Local (LocalStorage)

Chaves mantidas localmente em cada navegador (nunca commitadas no repositório):
- `mural_author`: identificador do usuário (`eu` ou `ela`).
- `mural_github_token`: Fine-grained Personal Access Token.
- `mural_github_repo`: repositório alvo no formato `usuario/repositorio`.
- `mural_local_data`: cache offline do último estado do `data.json`.
