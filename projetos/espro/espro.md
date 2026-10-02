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

- **Fase: ideia / planejamento.** Pasta do código criada vazia em
  `C:\Users\v.tozeti\Desktop\Vitor\teste\Espro` — nenhuma linha de código ainda.
- **Hospedagem decidida: Cloudflare** (Pages + Workers/Functions + D1 para dados e R2 para imagens/uploads). Nome da empresa fictícia e front-end **a definir**.

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
