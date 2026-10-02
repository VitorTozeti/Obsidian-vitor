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
- **4 telas** (navegação inferior no celular, barra lateral ≥960px): Início (progresso da edição, próximos compromissos, setores), Quadro, Agenda (calendário mensal com pontos coloridos por setor; mostra eventos **e** prazos dos cartões) e Revista (ver seções abaixo).
- **Setores padrão (2026-10-02):** Moda, Geek, Pop, Eventos, Notícias Gerais, RH, Marketing (cada um com cor). Dados antigos migram sozinhos (`v:2` no estado; cartões de setor extinto vão para o 1º setor).
- **Quadro (melhorado 2026-10-02):** 4 colunas (A fazer / Fazendo / Revisão / Pronto) com **abas-atalho com contagem** acima do quadro (tocar rola até a coluna; a aba acompanha o scroll — é assim que se chega ao "Pronto" no celular), scroll horizontal com snap (barra visível no mouse), filtro por setor, botão "avançar" e **arrastar e soltar** por Pointer Events: no celular pela alça ⠿ do cartão (não briga com o scroll), no mouse pelo cartão inteiro; mostra fantasma + linha de inserção, reordena dentro da coluna, auto-scroll nas bordas e vibra ao pegar. Em ≥960px as 4 colunas cabem lado a lado.
- **Revista com seções (2026-10-02):** Notícias Gerais, Pop, Moda e Geek têm **seção própria** (nesta ordem); Eventos, RH e Marketing não têm seção (conteúdo deles entra em "Capa e abertura" ou como anúncio). A ordem impressa é automática: capa → sumário → geral → seções → contracapa; dentro de cada grupo vale a ordem manual (setas ↑↓). Cada seção ganha uma **página de abertura gerada sozinha** (cor do setor, título e índice) e as páginas da seção levam faixa/etiqueta na cor dela. O **sumário é automático**, agrupado por seção, com nº de página. 7 modelos: capa, sumário, matéria, destaque (foto grande), lista/Top (cada linha vira item numerado), anúncio, contracapa. Cada página tem situação (Rascunho / Em revisão / Pronta) → barra de progresso da edição; cada seção mostra "feitas/total tarefas" do Quadro (link filtra o quadro pelo setor) e botão "+ Página" já na seção. Prévia deslizável com atalhos por seção, contador "Página X de N" e exportar PDF A5 (a abertura de seção também sai impressa).
- **Editor de página tipo Word + imagens livres (2026-10-02):** a página abre num sheet com abas **Editar / Prévia da página** (prévia ao vivo com a página real). O texto é **rico e editável**: desfazer/refazer, negrito, itálico, sublinhado, tachado, cor, estilo (parágrafo/título/subtítulo/citação), fonte (sem serifa/serifada/monoespaçada), tamanho (pequeno/normal/grande/enorme), listas (marcadores/numerada), alinhamento (esq./centro/dir./justificado), link, limpar formatação, contador de palavras e opção de 1 ou 2 colunas. Colar de Word/web é limpo por **sanitizador de lista branca** (sem scripts/estilos soltos). **Imagens** (até 6 por página) com posição **Fundo, Topo (largura total), Acima, Esquerda ou Direita (texto contorna), Abaixo**, tamanho P/M/G, forma (retângulo/arredondada/círculo), legenda e ordem. Aviso vermelho "Texto maior que a página" quando o conteúdo não cabe na folha (a folha tem tamanho fixo A5; o excesso é cortado — não há quebra automática de página).
- **Layout tipo canvas para imagens (2026-10-02):** o sheet da página agora tem as abas **Texto** e **Layout e imagens**. No Layout a página aparece de verdade e cada imagem é uma caixa sobre ela: **arrastar para mover**, **8 bolinhas para redimensionar** (cantos mantêm a proporção; laterais cortam/esticam um lado) e **bolinha de cima para girar** (encaixa em 0/90/180°). Funciona com mouse e toque (no celular o 1º toque seleciona, depois arrasta; setas do teclado movem 1%, Shift 5%, Delete remove). Abaixo: miniaturas, "+" para adicionar, e painel da imagem selecionada — posição (Livre ou presets Fundo/Topo/Acima/Esquerda/Direita/Abaixo; qualquer imagem em preset vira "livre" ao ser arrastada), tamanho/slider de **largura %** (redimensiona em torno do centro), forma, legenda, **atrás do texto**, para frente/trás, duplicar, remover. Imagem nova entra livre no centro (capa/destaque/anúncio/contracapa: a 1ª vira fundo). Imagens livres guardam `x,y,w,h` em **% da folha** + `rot` + `atras`; ficam sobre o texto (que não contorna imagens livres).
- **Editor de páginas — Fase 1 entregue (2026-10-02):** o editor deixou de ser sheet e virou **tela cheia** (`#/editor/<id>`, `js/editor.js`). **Edição direta na página**: título, texto corrido e caixas de texto são editáveis ali mesmo (não há mais abas Texto/Layout). **Barra inferior contextual** (mobile first): sem seleção → `Texto`, `Imagem`, `Objetos`, zoom (− 100% +, Ctrl+scroll); texto em foco → barra de formatação (B/I/U/S, cor, estilo, fonte, tamanho, listas, alinhar, link, limpar); objeto selecionado → Editar, Ajustes, Frente, Trás, Duplicar, Remover, Pronto. **Modelo híbrido**: o texto corrido continua fluindo (estilo Word) e agora há **caixas de texto livres** (mover/redimensionar/girar, fundo opcional, atrás/frente) além das imagens (toque duplo ou "Editar" edita a caixa). **Salvamento automático** (indicador "Salvando… / Salvo ✓"), **desfazer/refazer global** (Ctrl+Z / Ctrl+Shift+Z / botões; histórico de 120 passos), página nova vazia é descartada ao sair, e **exclusões (página, cartão, evento, imagem/caixa) agora são imediatas com "Desfazer" no aviso**. Menu ⋯ da página: modelo, seção, situação, colunas, duplicar, ver a revista, excluir. Painel "Objetos" lista camadas (e dá acesso à imagem de fundo). Teclado: setas movem (Shift = 5%), Delete remove, Ctrl+D duplica, Esc solta a seleção. **Armazenamento migrou para IndexedDB** (aguenta as imagens; migra do localStorage sozinho); imagens agora até 1600px, PNG/GIF/WebP mantêm transparência (WebP).
- **Visual:** papel quente + títulos em Fraunces/Inter, tema claro/escuro automático, alvos de toque ≥44px, bottom sheets para edição, exclusão com toque duplo, `safe-area` e `prefers-reduced-motion`.
- **Dados:** ainda em `localStorage` (+ exportar/importar backup JSON). `js/store.js` isola isso para trocar por API/D1.
- **Próximos passos:** Functions + D1 (cartões/eventos/páginas), R2 para imagens, login (se for o grupo todo), `git init` + deploy no Cloudflare Pages, arrastar-e-soltar no quadro, nome/identidade da empresa fictícia.
- Estrutura de arquivos e armazenamento: [[espro-dados]].
- **Levantamento de usabilidade do editor (2026-10-02):** diagnóstico + ~60 melhorias em 10 temas + roadmap em 5 fases → [[espro-usabilidade-editor]].

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
