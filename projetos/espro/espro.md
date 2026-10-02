---
name: espro
description: plataforma da empresa fictícia exigida pela ESPRO — montar a revista a partir dos dados enviados e organizar as tarefas de cada setor em um quadro estilo Trello
tags: [projeto, proj/espro, app, web, revista, kanban, calendario, cloudflare, ideia]
updated: 2026-10-02
---

# ESPRO — Revista da Empresa Fictícia

Projeto obrigatório da ESPRO: criar/apresentar uma **empresa fictícia**. A plataforma é o
lugar central para **publicar a empresa**, **montar de verdade a revista** dela e
**organizar o trabalho de cada setor** para produzi-la.

Dados e localização: [[espro-dados]].

## Estado atual (2026-10-02)

- **MVP mobile-first funcionando** em `C:\Users\v.tozeti\Desktop\Vitor\teste\Espro` (HTML/CSS/JS puro, sem build; sem Git ainda). Testado em 375×812 no preview (`espro-static`, porta 8793, em `.claude/launch.json`).
- **4 telas** (navegação inferior no celular, barra lateral ≥960px): Início (progresso da edição, próximos compromissos, setores), Quadro (colunas com scroll-snap, filtro por setor, botão "avançar"), Agenda (calendário mensal com pontos coloridos por setor; mostra eventos **e** prazos dos cartões) e Revista (lista de páginas reordenável, 5 modelos, prévia deslizável, exportar PDF A5 via impressão).
- **Visual:** papel quente + títulos em Fraunces/Inter, tema claro/escuro automático, alvos de toque ≥44px, bottom sheets para edição, exclusão com toque duplo, `safe-area` e `prefers-reduced-motion`.
- **Dados:** ainda em `localStorage` (+ exportar/importar backup JSON). `js/store.js` isola isso para trocar por API/D1.
- **Próximos passos:** Functions + D1 (cartões/eventos/páginas), R2 para imagens, login (se for o grupo todo), `git init` + deploy no Cloudflare Pages, arrastar-e-soltar no quadro, nome/identidade da empresa fictícia.
- Estrutura de arquivos e armazenamento: [[espro-dados]].

## Visão — 4 pilares

1. **Vitrine da empresa fictícia** — página pública com a empresa (nome, missão, setores,
   produtos/serviços, equipe).
2. **Montador de revista** — subir os dados da revista (textos, matérias, fotos, anúncios,
   capa) e gerar uma **revista real**: páginas diagramadas, leitura tipo flipbook e
   exportação para PDF/impressão.
3. **Quadro estilo Trello por setor** — colunas (ex.: A fazer / Fazendo / Revisão /
   Pronto), cartões com responsável, setor, prazo e vínculo com a matéria/página da revista
   que o cartão produz.
4. **Calendário de planejamento** — marcar atividades e eventos da produção (reuniões,
   prazos de fechamento, sessões de foto, entrega à ESPRO). Visões mês/semana/lista;
   eventos com setor (cor), responsável e vínculo opcional a um cartão do quadro ou a uma
   matéria; cartões do quadro com prazo aparecem automaticamente no calendário.

## Ideias de funcionalidades (backlog inicial)

- Cadastro dos setores da empresa (Marketing, RH, Financeiro, Redação, Design...) e dos membros.
- Upload de conteúdo por matéria (título, texto, imagens) com status ligado ao quadro.
- Templates de página (capa, sumário, matéria, anúncio, contracapa) e ordenação das páginas.
- Sumário gerado automaticamente; prévia da revista em tempo real.
- Filtro do quadro por setor; visão "o que falta para fechar a edição".
- Várias edições da revista (nº 1, nº 2...).
- Calendário: criar/arrastar eventos, filtrar por setor, lembretes de prazo, marco "fechamento da edição".

## Perguntas em aberto

- Quantas pessoas vão usar (só eu ou o grupo todo)? → define se precisa de login/backend.
- Front-end: JS puro como no [[mural]] ou framework (ex.: Vite)? Biblioteca de calendário (FullCalendar) ou feito à mão?
- Formato final exigido pela ESPRO (PDF impresso? link online? apresentação?).

## Relacionados

- [[mural]] — já resolve quadro colaborativo com post-its; pode servir de base para o kanban.
- [[mapa-projetos]]
