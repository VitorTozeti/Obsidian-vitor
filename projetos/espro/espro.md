---
name: espro
description: plataforma da empresa fictícia exigida pela ESPRO — montar a revista a partir dos dados enviados e organizar as tarefas de cada setor em um quadro estilo Trello
tags: [projeto, proj/espro, app, web, revista, kanban, calendario, cloudflare, ideia]
updated: 2026-10-09
---

# ESPRO — Revista da Empresa Fictícia

Projeto obrigatório da ESPRO: criar/apresentar uma **empresa fictícia**. A plataforma é o
lugar central para **publicar a empresa**, **montar de verdade a revista** dela e
**organizar o trabalho de cada setor** para produzi-la.

Dados e localização: [[espro-dados]].

## Estado atual (2026-10-05)

- **MVP mobile-first funcionando** em `C:\Users\v.tozeti\Desktop\Vitor\teste\Espro` (HTML/CSS/JS puro, sem build; sem Git ainda). Testado em 375×812 no preview (`espro-static`, porta 8793, em `.claude/launch.json`).
- **4 telas** (navegação inferior no celular, barra lateral ≥960px): Início (progresso da edição, próximos compromissos, setores), Quadro, Agenda (calendário mensal com pontos coloridos por setor; mostra eventos **e** prazos dos cartões) e Revista (ver seções abaixo).
- **Setores padrão (2026-10-02):** Moda, Geek, Pop, Eventos, Notícias Gerais, RH, Marketing (cada um com cor). Dados antigos migram sozinhos (`v:2` no estado; cartões de setor extinto vão para o 1º setor).
- **Quadro (atualizado 2026-10-05):** 4 colunas com abas-atalho, drag-and-drop avançado. **Novidades:**
  - **Checklists/subtarefas** dentro do cartão com mini barra de progresso visual.
  - **Etiquetas de prioridade** (Alta 🔴, Média 🟡, Baixa 🟢), **estimativa de esforço** (tempo) e **links/fontes externas**.
  - **Histórico de movimentação** automático registrado no cartão (coluna anterior → nova coluna, autor e data).
  - **Filtro rápido "Minhas Tarefas"** com 1 clique (filtra pelo usuário ativo).
  - **Ação de arquivar tarefas concluídas** (limpa a coluna Pronto sem perder dados).
  - **Rodízio automático** (distribuição equilibrada de tarefas sem responsável entre os membros).
- **Início (atualizado 2026-10-05):** **Dashboard de desempenho por setor** com barras de progresso dinâmicas e contagem de tarefas concluídas vs total por departamento.
- **Revista & Flipbook 3D (atualizado 2026-10-05):** Novo modo **Flipbook 3D 📖** na aba Prévia, com efeito de perspectiva, curvatura e sombra realista de livro folheável (além de página única e dupla).
- **Revista com seções (2026-10-02):** Notícias Gerais, Pop, Moda e Geek têm **seção própria** (nesta ordem); Eventos, RH e Marketing não têm seção (conteúdo deles entra em "Capa e abertura" ou como anúncio). A ordem impressa é automática: capa → sumário → geral → seções → contracapa; dentro de cada grupo vale a ordem manual (setas ↑↓). Cada seção ganha uma **página de abertura gerada sozinha** (cor do setor, título e índice) e as páginas da seção levam faixa/etiqueta na cor dela. O **sumário é automático**, agrupado por seção, com nº de página. 7 modelos: capa, sumário, matéria, destaque (foto grande), lista/Top (cada linha vira item numerado), anúncio, contracapa. Cada página tem situação (Rascunho / Em revisão / Pronta) → barra de progresso da edição; cada seção mostra "feitas/total tarefas" do Quadro (link filtra o quadro pelo setor) e botão "+ Página" já na seção. Prévia deslizável com atalhos por seção, contador "Página X de N" e exportar PDF A5 (a abertura de seção também sai impressa).
- **Editor de página tipo Word + imagens livres (2026-10-02):** a página abre num sheet com abas **Editar / Prévia da página** (prévia ao vivo com a página real). O texto é **rico e editável**: desfazer/refazer, negrito, itálico, sublinhado, tachado, cor, estilo (parágrafo/título/subtítulo/citação), fonte (sem serifa/serifada/monoespaçada), tamanho (pequeno/normal/grande/enorme), listas (marcadores/numerada), alinhamento (esq./centro/dir./justificado), link, limpar formatação, contador de palavras e opção de 1 ou 2 colunas. Colar de Word/web é limpo por **sanitizador de lista branca** (sem scripts/estilos soltos). **Imagens** (até 6 por página) com posição **Fundo, Topo (largura total), Acima, Esquerda ou Direita (texto contorna), Abaixo**, tamanho P/M/G, forma (retângulo/arredondada/círculo), legenda e ordem. Aviso vermelho "Texto maior que a página" quando o conteúdo não cabe na folha (a folha tem tamanho fixo A5; o excesso é cortado — não há quebra automática de página).
- **Layout tipo canvas para imagens (2026-10-02):** o sheet da página agora tem as abas **Texto** e **Layout e imagens**. No Layout a página aparece de verdade e cada imagem é uma caixa sobre ela: **arrastar para mover**, **8 bolinhas para redimensionar** (cantos mantêm a proporção; laterais cortam/esticam um lado) e **bolinha de cima para girar** (encaixa em 0/90/180°). Funciona com mouse e toque (no celular o 1º toque seleciona, depois arrasta; setas do teclado movem 1%, Shift 5%, Delete remove). Abaixo: miniaturas, "+" para adicionar, e painel da imagem selecionada — posição (Livre ou presets Fundo/Topo/Acima/Esquerda/Direita/Abaixo; qualquer imagem em preset vira "livre" ao ser arrastada), tamanho/slider de **largura %** (redimensiona em torno do centro), forma, legenda, **atrás do texto**, para frente/trás, duplicar, remover. Imagem nova entra livre no centro (capa/destaque/anúncio/contracapa: a 1ª vira fundo). Imagens livres guardam `x,y,w,h` em **% da folha** + `rot` + `atras`; ficam sobre o texto (que não contorna imagens livres).
- **Editor de páginas — Fase 1 entregue (2026-10-02):** o editor deixou de ser sheet e virou **tela cheia** (`#/editor/<id>`, `js/editor.js`). **Edição direta na página**: título, texto corrido e caixas de texto são editáveis ali mesmo (não há mais abas Texto/Layout). **Barra inferior contextual** (mobile first): sem seleção → `Texto`, `Imagem`, `Objetos`, zoom (− 100% +, Ctrl+scroll); texto em foco → barra de formatação (B/I/U/S, cor, estilo, fonte, tamanho, listas, alinhar, link, limpar); objeto selecionado → Editar, Ajustes, Frente, Trás, Duplicar, Remover, Pronto. **Modelo híbrido**: o texto corrido continua fluindo (estilo Word) e agora há **caixas de texto livres** (mover/redimensionar/girar, fundo opcional, atrás/frente) além das imagens (toque duplo ou "Editar" edita a caixa). **Salvamento automático** (indicador "Salvando… / Salvo ✓"), **desfazer/refazer global** (Ctrl+Z / Ctrl+Shift+Z / botões; histórico de 120 passos), página nova vazia é descartada ao sair, e **exclusões (página, cartão, evento, imagem/caixa) agora são imediatas com "Desfazer" no aviso**. Menu ⋯ da página: modelo, seção, situação, colunas, duplicar, ver a revista, excluir. Painel "Objetos" lista camadas (e dá acesso à imagem de fundo). Teclado: setas movem (Shift = 5%), Delete remove, Ctrl+D duplica, Esc solta a seleção. **Armazenamento migrou para IndexedDB** (aguenta as imagens; migra do localStorage sozinho); imagens agora até 1600px, PNG/GIF/WebP mantêm transparência (WebP).
- **Fases 2 a 5 do editor entregues (2026-10-02)** — ver [[espro-usabilidade-editor]]:
  - **Fase 2 · Precisão:** zoom por **pinça** (e Ctrl+scroll/botões), **guias + encaixe** (centro, margens de 6%, bordas/centros de outros objetos; vibra ao encaixar), margens e grade liga/desliga, **seleção múltipla** (Shift/Ctrl ou botão "Vários") com **alinhar** (6 modos) e **distribuir**, **recorte** da imagem dentro da moldura + zoom da imagem, **trocar imagem** mantendo posição, **campos numéricos** (X, Y, largura, altura, giro), **gestos de 2 dedos** no objeto selecionado (pinça redimensiona, giro rotaciona), **quadro do texto móvel** ("Mover texto"), texto alternativo da imagem.
  - **Fase 3 · Velocidade:** **galeria de 10 modelos** ao criar página (matéria, foto grande, 2 colunas, galeria 4 fotos, entrevista, Top 5, citação, agenda de eventos real, anúncio, em branco), **Planejar edição** (gera páginas por seção + tarefas no Quadro ligadas + fechamento na Agenda), **paleta de comandos** (Ctrl+K, "/" ou lupa), **miniaturas** reais nas listas e em "Páginas" no editor (Alt+←/→ troca de página), **biblioteca de mídia** (imagem guardada uma vez, reutilizável), **paleta/cores da marca** no seletor de cor, estilos de texto (Lead, Legenda, Destaque), **página dupla** na prévia, colar/arrastar imagens e câmera no celular.
  - **Fase 4 · Qualidade:** aviso "texto passa da página" com **Encaixar** (reduz a fonte até 60%) e **Dividir** (move o excedente para uma nova página logo depois), **verificador de pré-impressão** (texto cortado, página vazia, imagem de exemplo, baixa resolução em dpi, sem título, caixa na borda, falta capa/contracapa/sumário, seção vazia, situação), **exportar PDF** por revista/seção/intervalo com **sangria 3 mm + marcas de corte**, **HTML de leitura** em arquivo único e **apresentação** em tela cheia (setas, deslizar, página dupla).
  - **Fase 5 · Equipe:** página↔**tarefa do Quadro** (situação da página e coluna do cartão andam juntas nos dois sentidos), **comentários** por página (resolver/reabrir), **pedir revisão / aprovar / pedir ajustes** (gera comentário), **histórico de versões** (15 por página, restaurar), **alertas** no Início (tarefas atrasadas, fechamento próximo, páginas em revisão, comentários abertos) + aviso opcional do navegador, e **sincronização com Cloudflare** (login por código da equipe, D1, mídia, presença "fulano também está editando"). **O servidor (D1) NÃO foi testado de verdade** — só a lógica da API contra um repositório em memória.
- **Edições, identidade e link público (2026-10-05):** nova aba **Edições** = estante com todas as edições (nº 1, nº 2…; cada uma com suas páginas; criar em branco/copiando estrutura/duplicando; abrir, ler, editar dados, excluir). **Identidade da marca** (menu da empresa → "Identidade da marca"): logo (ou monograma), cor principal que recolore o app inteiro, fonte dos títulos (6 opções), slogan; aplicada ao cabeçalho, capa/contracapa, favicon. **Link público de leitura + QR code** por edição (precisa de login na equipe e da tabela `publico` no D1). Detalhes em [[espro-dados]] §9. Quadro/agenda continuam globais (não por edição).
- **Contas e cargos (2026-10-05):** login por **e-mail + senha** (sem painel/segredos), admin fixo `vitortozeti@gmail.com`, cargos Gestor(a) e Sem cargo, tela "Gerenciar cargos"; site no ar em `espro-frame.pages.dev`. Detalhes em [[espro-dados]] §10.
- **Diário de bordo + setor por pessoa (2026-10-06):** nova aba **Diário**: a cada quinta-feira uma pessoa (ordem alfabética das contas, em rodízio) escreve como foi a semana; mostra quem é a vez, próximas quintas e histórico. O admin define o **setor de cada pessoa** em "Gerenciar cargos" (além de gestor/a). Detalhes em [[espro-dados]] §11. Commit local `cda4a3a` (ainda sem push → sem deploy).
- **Cargos, quadro por setor e página Equipe (2026-10-07):** cargos diretor(a) e instrutor(a); só o admin cria setores e define cargo/setor; cada setor só vê o próprio quadro (admin/diretor/instrutor veem tudo); nova aba **Equipe** (pessoas por setor; gestor vê o seu); RH é avisado toda quinta de quem faz o diário. Detalhes em [[espro-dados]] §12.
- **Visual:** papel quente + títulos em Fraunces/Inter, tema claro/escuro automático, alvos de toque ≥44px, bottom sheets para edição, exclusão com toque duplo, `safe-area` e `prefers-reduced-motion`.
- **Dados:** ainda em `localStorage` (+ exportar/importar backup JSON). `js/store.js` isola isso para trocar por API/D1.
- **Próximos passos:** publicar na Cloudflare e fazer o 1º teste real do D1 (ver `README.md` na pasta do código), `git init`, nome/identidade da empresa fictícia, mover imagens para R2 se a mídia no D1 crescer demais.
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

- **Backlog detalhado de colaboração e leitor:** ver [[espro-ideias-futuras]] (checklists em cartões, filtro "minhas tarefas", etiquetas de urgência, flipbook 3D, gráfico de setores, etc.).
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

- [[espro-analise-roadmap]] — análise e planejamento em ondas (2026-10-07)
- [[espro-ideias-futuras]] — backlog detalhado de melhorias selecionadas
- [[espro-usabilidade-editor]] — roadmap e usabilidade do editor de páginas
- [[mural]] — já resolve quadro colaborativo com post-its; pode servir de base para o kanban.
- [[mapa-projetos]]

## Correção da barra de abas (2026-10-07)
Com a 7ª aba (Equipe), a `.tabs` ganhou `grid-auto-flow: column` e quebrou o menu lateral do PC (≥960px). Correção em `css/style.css`: o desktop volta a `grid-auto-flow: row`; no celular as abas usam `minmax(0,1fr)` com `min-width:0` e rótulo com reticências (7 abas × 54px em 375px, sem estouro). Regra: ao adicionar aba, testar celular **e** PC. Commit `5a416ae` na `main` de `Espro_frame`.

## Co-gestor e visão do administrador (2026-10-09)
Novo cargo **Co-gestor(a)** e, na aba Equipe, uma **visão exclusiva do admin** (pessoas cadastradas, setores × cargos, filtros, edição de cargo/setor na hora). Detalhes em [[espro-dados]] §13.
