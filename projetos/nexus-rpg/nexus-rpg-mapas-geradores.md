---
name: nexus-rpg-mapas-geradores
description: geradores procedurais de mapa (mundo e masmorra/caverna/interior/vila), estudo das ferramentas de referência feito com o REA, zoom/pan, hex, exportar PNG e melhorias gerais de UX/UI do Nexus RPG
tags: [projeto, proj/nexus-rpg, mapas, geradores, ux, rea]
updated: 2026-10-14
---

# Nexus RPG — Geradores de mapa e rodada de UX/UI (2026-10-13)

> ⚠️ **Aposentado em 2026-10-14:** os geradores e o editor de mapas descritos aqui foram removidos do código e substituídos pela Mesa simples (imagem + tokens). Ver [[nexus-rpg-mesa-tokens]]. A nota fica como histórico/estudo (REA do Azgaar e Watabou).

Parte do [[nexus-rpg]]. Contexto: pedido de "melhorar todos os sistemas de UX/UI e puxar com o
REA as melhores ferramentas de criação de mapas de RPG (grande e pequena escala) e adaptar".
Tela de mapas em [[nexus-rpg-telas]]; dados em [[nexus-rpg-dados]]; roadmap em [[nexus-rpg-planejamento]].

## Estudo com o REA (o que foi observado vs. inferido)

- **Azgaar's Fantasy Map Generator v1.154.1** (grande escala) — `analyze_web_bundle` via CDP em
  Chrome local (`--remote-debugging-port`). **Observado:** 66 scripts, bundler Vite, vendors
  `d3`, `delaunator` (Voronoi), `polylabel`, `simplify.js`, `alea` (PRNG com seed), `flatqueue`
  (fila de prioridade); módulos `draw-landmass`, `relief-generator`, `cultures-generator`,
  `names-generator`, `transports-generator`, `labels-generator`, `emblems-generator`; chaves de
  URL `seed/preset/layers/scale`. **Inferido** (o JSON só trouxe metadados, sem código-fonte):
  heightmap por templates, biomas por temperatura×umidade, rios por acúmulo de fluxo, estados
  por expansão de custo (Dijkstra), rotas por menor custo, nomes por cadeias.
- **One Page Dungeon (Watabou)** (pequena escala) — a página do itch.io é só um iframe; o REA não
  expôs código útil. O estilo foi adaptado pelo comportamento visível (salas+corredores, portas,
  hachura nas paredes, numeração) e por conhecimento prévio do Dungeon Scrawl.
- **Não foi copiado código de terceiros** — só as ideias/algoritmos foram reimplementados.
- Limite do REA aqui: `analyze_web_bundle` devolve metadados; para ver algoritmos reais seria
  preciso `export_web_scripts`/`recover_javascript_sources` (não necessário nesta rodada).

## O que entrou no projeto

Arquivo novo `src/master/campaign/map-gen.js` (carregado antes de `campaign-map.js`):

| Gerador | Tipo de mapa | Técnica |
|---|---|---|
| Mundo / região | `mundo`, `regiao` | ruído fBm + máscara (continente/arquipélago/pangeia), nível do mar por quantil (% água), relevo por ranking, clima → biomas, rios por fluxo, reinos por Dijkstra multi-origem, capitais/povoados/portos, estradas por menor custo, nomes procedurais |
| Masmorra | `masmorra` | salas + corredores (MST de Prim), portas, hachuras, numeração, baús/armadilhas ocultas, notas para o Mestre |
| Caverna | `masmorra` | autômato celular + maior região conexa + contorno orgânico (máscara borrada/binarizada) |
| Interior | `interior` | planta de casa por BSP, portas internas/entrada, tábuas, móveis |
| Vila | `local` | ruas curvas, casas alinhadas, rio, praça, locais de interesse |

- **Semente reprodutível** (`rngSeed`): mesma semente = mesmo mapa. Painel "🎲 Gerador procedural"
  (`geradorPanel`) com semente, aleatório e opções por tipo; "Gerar automaticamente" ao criar mapa.
- O resultado vai para `m.image` (JPEG ~120–260 KB, leve p/ `localStorage`); **o pincel pinta por
  cima**. Peças/locais/reinos gerados levam `gen:true`; **regenerar remove só o gerado** (o que o
  Mestre fez à mão fica). `m.genMeta={g,seed}` marca mapa gerado.
- Tempo medido no Chrome: mundo ~0,4–1 s; masmorra/interior/vila < 0,2 s; caverna ~0,2 s.

## Editor de mapas (campaign-map.js)

- **Zoom/pan** (`.map-vp`): roda do mouse, botões + − ⟲ ⛶ (tela cheia), espaço/botão do meio p/ arrastar;
  pins e rótulos de reino mantêm tamanho na tela. Pincel constante na tela e **anel de pré-visualização**.
- **Desfazer/refazer do pincel** (12 níveis, Ctrl+Z / Ctrl+Shift+Z, botões ↶ ↷).
- **Grade hexagonal** além da quadrada (`m.grid.type`), com encaixe em hexágono (`snapPct`);
  grade agora em % (alinha com o gerador e com zoom).
- **Bússola** e **barra de escala** que se ajusta ao zoom (`m.compass`, `m.scale={on,total,unit}`).
- **Exportar PNG** (`exportarMapaPNG`) sem itens ocultos/segredos do Mestre.
- **Atalhos:** V selecionar · B pincel · E borracha · [ ] tamanho · +/−/0 zoom · Esc cancela.

## UX/UI geral

- Contraste maior (`--muted`, `--dim`, rodapé); `:focus-visible` em tudo; `prefers-reduced-motion`.
- Acessibilidade: link "Pular para o conteúdo", `aria-label` automático em botões só-ícone e
  inputs (`a11yPass` em `helpers.js`, chamado por `render()`), toast com `role="status"`.
- **Sem tela branca:** `render()` captura exceção → `telaFalha()` com "Baixar backup/Recarregar".
- **💾 Backup** no cabeçalho (`backupConta`): baixa todos os dados da conta em JSON.
- Barras do mapa agrupadas (`.map-bar`), alvos de toque maiores em telas de toque, `.btn:disabled`.

## Correção de uma conclusão anterior

Na análise de 2026-10-13 ([[nexus-rpg-planejamento]]) foi dito que `store()` não tratava cota;
na verdade o salvamento real passa por `persist()` (`state.js`), que **já** tem `try/catch` com aviso
de cota. `store()` é só um helper pouco usado.

## Pendências / próximos passos

- Tema claro (muitas cores fixas escuras no CSS) e padronização dos ícones emoji.
- Mundo: rótulos de cadeias de montanhas/mares, lagos, culturas/religiões, brasões.
- Pan/zoom por gesto de pinça no celular; tokens com iniciativa lateral.
- Testes automatizados dos geradores (semente → saída estável) e dos motores de fórmula/dados.
- Revisar o carregamento do mapa pelo `file://` (testes desta rodada foram via `http://localhost`).
- Repositório `The-One-System` com mudanças **não commitadas** (decisão do usuário).

## Relacionado
[[nexus-rpg]] · [[nexus-rpg-telas]] · [[nexus-rpg-dados]] · [[nexus-rpg-arquitetura]] · [[nexus-rpg-planejamento]]
