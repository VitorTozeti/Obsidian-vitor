---
name: espro-dados
description: onde os dados do projeto ESPRO vivem — pasta do código, repositório, armazenamento (a definir)
tags: [projeto, proj/espro, dados]
updated: 2026-10-02
---

# ESPRO — Onde os dados vivem

Mapa de dados do [[espro]].

## 1. Código
- **Pasta local:** `C:\Users\v.tozeti\Desktop\Vitor\teste\Espro` (criada, vazia em 2026-10-02).
- **Repositório remoto:** ainda não existe.
- **Hospedagem:** Cloudflare (Pages + Functions/Workers).

- **Arquivos:** `index.html`, `css/style.css`, `js/store.js` (estado + persistência), `js/ui.js` (helpers, sheet, ícones), `js/views.js` (4 telas e formulários), `js/app.js` (roteador por hash), `manifest.webmanifest`, `README.md`.
- **Estado hoje:** chave `espro.v1` no `localStorage`, campo `v:2` (empresa, setores, cards, eventos, paginas); imagens da revista guardadas como data-URL JPEG ≤1000px (limite ~5MB do navegador → migrar para R2).
- **Servidor de preview:** `espro-static` (porta 8793) em `Obsidian-vitor/.claude/launch.json`.

## 2. Dados previstos (modelo inicial)
- **Empresa** — nome, missão, logo, setores.
- **Setores / membros** — quem pertence a qual setor.
- **Revista / edições** — páginas, ordem, template, capa.
- **Matérias** — texto, imagens, autor, setor, status.
- **Quadro (kanban)** — colunas, cartões (título, setor, responsável, prazo, matéria vinculada).
- **Eventos (calendário)** — título, início/fim, dia inteiro, setor, responsável, tipo (reunião/prazo/evento), cartão ou matéria vinculada.

## 3. Armazenamento (Cloudflare)
- **D1 (SQLite):** empresa, setores, membros, edições, matérias, cartões e eventos.
- **R2:** imagens e arquivos da revista (uploads).
- **Pages Functions / Workers:** API (`/api/...`) entre o site e o D1/R2.
- Mesmo padrão já usado no [[mural-dados]] (Cloudflare D1/Pages).

## 4. Ordem dos cartões
- A ordem visual de cada coluna é a ordem do array `cards` (função `Store.placeCard(id, col, beforeId)`); na futura tabela D1 isso vira uma coluna `posicao`.

## 5. Páginas da revista
- Cada página: `id, tpl, titulo, texto, img, secao (id do setor ou ''), status (rascunho|revisao|pronta)`. A ordem final é calculada (`ordenadas()`/`folhas()` em `js/views.js`); aberturas de seção **não** são gravadas, são geradas na hora. Na tabela D1 vira `paginas(posicao, secao_id, status, ...)`.
