---
name: espro-dados
description: onde os dados do projeto ESPRO vivem — pasta do código, repositório, armazenamento (a definir)
tags: [projeto, proj/espro, dados]
updated: 2026-10-02
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
