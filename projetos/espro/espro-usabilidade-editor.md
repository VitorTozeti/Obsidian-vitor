---
name: espro-usabilidade-editor
description: levantamento completo de melhorias de usabilidade do editor de páginas da revista ESPRO (a parte mais importante), priorizado em fases
tags: [projeto, proj/espro, planejamento, ux, editor, roadmap]
updated: 2026-10-02
---

# ESPRO — Usabilidade do editor de páginas (levantamento)

Hub: [[espro]] · dados: [[espro-dados]]. O editor é a parte central do projeto: é onde a revista de fato é montada.

## Diagnóstico — o que hoje atrapalha

1. **Texto e layout em abas separadas** dentro de um bottom sheet: não dá para ver a página enquanto se escreve, nem escrever direto nela.
2. **Sheet pequeno no celular** (teclado, toolbar do editor e canvas disputam a mesma tela; scroll do sheet conflita com arrastar).
3. **Só "Salvar"**: fechar sem salvar perde o trabalho; não há desfazer/refazer no layout; sem histórico.
4. **Página de tamanho fixo sem quebra**: texto que passa do limite é cortado (só há um aviso).
5. **Sem guias/encaixe/zoom/recorte**: posicionar com precisão é difícil; imagem sempre "cobre" a caixa sem poder reenquadrar.
6. **Criar página do zero** toda vez: sem modelos de layout, sem estilos de texto reutilizáveis, sem identidade (cores/fontes) da marca.
7. **Gestão de páginas pobre**: lista simples com setas; sem miniaturas, sem duplicar, sem ver a revista em páginas duplas.
8. **Armazenamento**: imagens em data-URL no `localStorage` (~5 MB) — o primeiro gargalo real de uso.
9. **Sem ligação com o Quadro** e sem comentários/revisão: o editor não "conversa" com o fluxo de trabalho dos setores.

## Métodos de melhoria (todos), por tema

### A. Estrutura da edição (maior impacto)
- **Editor em tela cheia** (rota própria `#/editor/<página>`), não sheet: página grande no centro, ferramentas ao redor.
- **Edição direta na página (WYSIWYG)**: tocar no texto da página e digitar ali; barra flutuante contextual junto da seleção.
- **Tudo como objetos**: bloco de texto, imagem, forma, linha, caixa de citação — mesmo modelo (x, y, w, h, rot, camada). Manter o **texto corrido (Word)** num "quadro de texto" redimensionável + permitir **caixas de texto extras**.
- **Painel único contextual**: o que aparece muda conforme a seleção (texto, imagem, página); menos abas.
- **Painel de camadas** (ordem, ocultar, travar, renomear).
- **Filmstrip de páginas** (miniaturas) lateral/inferior: arrastar para reordenar, mover entre seções, duplicar, excluir com desfazer.
- **Modo página dupla (spread)** para ver/compor miolo como revista aberta.

### B. Segurança e fluidez
- **Autosave contínuo** (debounce) + indicador "Salvo ✓ / Salvando…" — sem botão obrigatório.
- **Desfazer/refazer global** (Ctrl+Z / Ctrl+Shift+Z / botões) cobrindo texto, imagens e propriedades.
- **Histórico de versões** da página (restaurar versão anterior) e **rascunho recuperável** se fechar sem querer.
- **Exclusão com "Desfazer" (toast)** em vez de confirmações.
- **Armazenamento robusto**: IndexedDB já (imagens como Blob) → depois R2/D1; compressão/redimensionamento inteligente; aviso de cota.

### C. Precisão de posicionamento
- **Guias inteligentes + encaixe (snap)**: margens, centro da página, bordas/centros de outros objetos, espaçamento igual; linhas de alinhamento ao arrastar.
- **Margens de segurança e sangria** visíveis (liga/desliga), **grade** opcional, **réguas**.
- **Zoom e pan do canvas** (pinça + arraste com 2 dedos no celular; Ctrl+scroll no desktop; botões +/−/ajustar).
- **Medidas ao vivo** (largura/altura/ângulo) e campos numéricos (x, y, w, h, rotação).
- **Seleção múltipla** (arrastar caixa/Shift), **agrupar**, **alinhar** (esq/centro/dir/topo/meio/base) e **distribuir**.
- **Trava de objeto** e **bloqueio de proporção** alternável.
- **Setas do teclado** (já existe) + atalhos de camada (`]` `[`), duplicar (Ctrl+D), copiar/colar (entre páginas).

### D. Imagens
- **Recorte/reenquadramento dentro da moldura** (arrastar a imagem dentro da caixa + zoom da imagem), "preencher/ajustar".
- **Trocar imagem** mantendo posição e tamanho; **substituir em massa**.
- **Entrada mais rápida**: arrastar-e-soltar arquivos, **colar do clipboard** (Ctrl+V), **câmera/galeria no celular**, múltiplas de uma vez em grade.
- **Biblioteca de mídia da revista** (reusar a mesma foto em várias páginas, sem duplicar dados).
- Ajustes leves: brilho/contraste/saturação, preto e branco, espelhar, borda/sombra, máscaras (círculo, arredondado já existe).
- **Alt text/legenda e crédito** (acessibilidade e fotógrafo), aviso de **baixa resolução** para impressão.

### E. Texto
- **Estilos de texto reutilizáveis** (Título, Subtítulo, Lead, Corpo, Legenda, Citação) com um toque; mudar o estilo atualiza tudo.
- **Identidade visual da revista** (Brand Kit): paleta, fontes, cores por seção — seletor de cor mostra a paleta, não só o color picker.
- **Texto que quebra em página** (continua na pág. X), **encaixe automático** (reduzir fonte até caber) e **colunas fluindo**.
- **Metas por página/seção**: contador de palavras/caracteres com alvo, tempo de leitura.
- **Localizar e substituir**, **corretor ortográfico pt-BR** nativo ligado, **colar sem formatação** (Ctrl+Shift+V).
- **Atalhos de texto** (Ctrl+B/I/U, listas Markdown-like `- ` `1. `, `#`).

### F. Velocidade de criação
- **Escolher modelo ao criar página**: galeria de layouts prontos por seção (foto grande + texto, 2 colunas, galeria 4 fotos, entrevista, Top 5, citação, agenda de eventos).
- **Páginas-modelo por seção** (Pop, Moda, Geek, Notícias Gerais já com cor/kicker/estilos) e **"duplicar página"** como atalho.
- **Assistente "Nova edição"**: define nº de páginas, seções, esqueleto; já gera tarefas no Quadro.
- **Paleta de comandos** (`/` ou Ctrl+K): "nova página Moda", "inserir imagem", "ir para pág. 7".

### G. Mobile (prioridade, pois o projeto é mobile first)
- **Barra de ferramentas contextual inferior** (polegar) que troca conforme a seleção; áreas de toque ≥44px (alças maiores nas bolinhas).
- **Gestos**: pinça para redimensionar o objeto selecionado, dois dedos para girar, toque duplo para editar texto, arrastar da borda para alternar painéis.
- **Teclado virtual**: usar `visualViewport` para a barra de texto ficar sobre o teclado e a página rolar até o cursor.
- **Modo paisagem** com painéis laterais; **modo uma mão**.
- **Haptics** discretos (já usado no arrasto do Quadro) ao encaixar em guias.

### H. Qualidade e entrega
- **Verificador de pré-impressão (preflight)** antes de exportar: texto cortado, imagens de baixa resolução, página vazia, falta de título/alt, fonte fora da marca → lista clicável que leva à página.
- **Prévia realista** (folhear com animação/spread) e **modo apresentação**.
- **PDF melhor**: sangria + marcas de corte opcionais, exportar **por seção** ou intervalo, imagens em qualidade total (do R2).
- **Link de leitura** público (somente leitura) para apresentar à ESPRO.

### I. Integração com o fluxo da equipe (liga ao [[espro]] Quadro)
- **Vincular página ↔ cartão do Quadro** (abrir cartão da página e vice-versa); **status da página ↔ coluna do cartão** (Pronta → Pronto).
- **Comentários por página/objeto** com menção ao setor e resolver; **pedido de revisão** (Em revisão → aprovador do setor).
- **Presença e bloqueio de edição** (quem está editando a página) + **histórico de quem mudou** (requer D1/login).
- **Notificações** de prazo (liga à Agenda): "fechamento em 2 dias, 3 páginas em rascunho".

### J. Onboarding, acessibilidade e performance
- **Estado vazio guiado** e **dicas de 1ª vez** (coach marks) para canvas/atalhos; **folha de atalhos** (`?`).
- **Acessibilidade**: foco visível, rótulos ARIA nas alças, mover por teclado/leitor de tela, contraste, `prefers-reduced-motion`, alvos grandes.
- **Performance**: renderizar só o que mudou (não reconstruir a página inteira a cada gesto), miniaturas em cache, virtualizar filmstrip, *debounce* do autosave, imagens com `decoding=async`.

## Status (2026-10-02)
- **Fase 1 — entregue:** editor em tela cheia, edição direta na página, barra contextual, caixas de texto livres (modelo híbrido), autosave, desfazer/refazer global, exclusão com "Desfazer", IndexedDB, painel de objetos/camadas básico, zoom por botões e Ctrl+scroll, menu da página.
- **Ainda pendente da Fase 1:** histórico de versões por página e recuperação de rascunho entre sessões.
- **Próximo (Fase 2):** pinça/arrastar com 2 dedos para zoom, guias + encaixe (snap), recorte/reenquadramento da imagem, seleção múltipla/alinhar, campos numéricos, gestos de girar/redimensionar com 2 dedos, mover/redimensionar o quadro do texto corrido.

## Roadmap sugerido

| Fase | Foco | Itens |
|---|---|---|
| **1 — Fundação** | não perder trabalho, ver o que escreve | editor em tela cheia + edição direta na página, autosave, desfazer/refazer, IndexedDB, exclusão com desfazer |
| **2 — Precisão** | mexer sem sofrer | zoom/pan, guias+snap, recorte da imagem, seleção múltipla/alinhar, camadas, valores numéricos, barra contextual mobile + gestos |
| **3 — Velocidade** | montar rápido | modelos de página por seção, estilos de texto + Brand Kit, filmstrip com arrastar/duplicar, spread, atalhos/paleta de comandos, colar/arrastar/câmera |
| **4 — Qualidade** | sair pronto para imprimir | quebra automática de página/encaixe de texto, preflight, PDF com sangria/por seção, link de leitura |
| **5 — Equipe** | trabalho em grupo | D1 + login, vínculo página↔cartão, comentários/revisão, presença, histórico, notificações |

## Decisão em aberto (afeta a Fase 1)
**Modelo de texto:** manter *texto corrido* (como Word, flui e quebra) num quadro redimensionável **+** caixas livres extras (recomendado: híbrido), ou migrar tudo para caixas livres (estilo Canva; mais liberdade, mas sem fluxo automático entre páginas).
