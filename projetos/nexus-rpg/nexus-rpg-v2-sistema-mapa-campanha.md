---
name: nexus-rpg-v2-sistema-mapa-campanha
description: rodada de 3 agentes (2026-10-13) — fluxo de criação do sistema, mapa 100% editável (objetos vetoriais) e recursos de campanha real (combate, diário, tela dos jogadores, .campanha); arquivos, APIs e limitações
tags: [projeto, proj/nexus-rpg, ux, mapas, campanha, sistema]
updated: 2026-10-13
---

# Nexus RPG — Rodada v2: sistema, mapa editável e campanha real

Feita por 3 agentes em paralelo com **propriedade exclusiva de arquivos** (+ um CSS próprio por frente).
Antecedentes: [[nexus-rpg-mapas-geradores]] (geradores) e [[nexus-rpg-plano-melhorias]] (plano).
Estado: **alterações no disco, ainda NÃO commitadas** no repo `The-One-System` (último push: `8c10d43`).

## 1. Sistema em si (CSS: `assets/css/sistema.css`)
- **Assistente de criação** (`src/ui/wizard.js`, `src/data/sistema-modelos.js`): 3 passos (Modelo → Personalizar → Revisar);
  modelos Fantasia clássica / Investigação-terror / Simples-narrativo / Em branco; fórmulas com `{i}` (nome do
  atributo) para sobreviver a renomeações. "Criar Mestre" abre o assistente e cai na aba Início; "Criar Jogador" vai à ficha.
- **Diálogos próprios** (`src/ui/dialogs.js`, API estável): `uiConfirm`, `uiPrompt`, `uiAlert`, `uiChoice`, `uiToastUndo`
  (focus-trap, Esc/Enter, `perigo:true` = foco em Cancelar). Outros módulos usam só se `typeof uiConfirm==='function'`.
- **Importar `.nexus` seguro** (`importarSistemaTexto`): limite 8 MB, ignora `__proto__/constructor/prototype`, exige `__v`,
  migra com `migrateSystem`, mensagens claras, resumo + confirmação + desfazer.
- **Backup/Restaurar** (`app.js`: `validarBackup`, `restaurarBackupUI`): Mesclar × Substituir, descarta itens corrompidos.
- **Indicador de salvo** (`saveState` em `state.js`): "✔ salvo" / "⚠ NÃO salvo" (+ alerta único se `persist()` falhar).
- Aba Início com card "Próximo passo"; abas com `role=tablist/tab` e setas; avisos no ponto de uso; estados vazios;
  fluxo do jogador com motivo de bloqueio no botão "Avançar: <passo>".

## 2. Mapa 100% editável (CSS: `assets/css/mapa.css`)
- **Arquitetura:** `m.objs[]` = objetos vetoriais num `<svg>` 1000×625 sobre o terreno. Tipos `rect/ellipse/path/text/door`;
  `role` (floor, wall, water, grass, ice, house, tree, plaza, road, river, border, fence, region, line, aoe, plain);
  campos `gid, hidden, locked, gen, label, note`. Extras por mapa: `m.fx` (hachura/sombra/"goo" da caverna), `m.bg`.
  Entidades antigas (`props, pins, tokens, world.kingdoms`) seguem em % com os mesmos campos (`m.tokens` inalterado).
- **Geradores agora produzem objetos** (`gen:true`); **editar um item solta o `gen`**; regerar troca só o que ainda é gerado.
  Mundo: rios/fronteiras/estradas viram polilinhas; relevo continua raster (botão **"Tornar o fundo pintável"**).
- **Edição direta:** selecionar (clique/marquee/Shift), mover, redimensionar e girar com **alças**, vértices de polilinha,
  duplicar/copiar/colar, excluir, ordem, travar, ocultar, agrupar, alinhar/distribuir. **Desfazer/refazer global por mapa.**
- **Desenho:** sala, elipse, linha/polilinha, polígono, texto, régua (usa `m.scale`), área de magia (círculo/cone/linha), balde, pincel.
- **UI sem scroll:** workspace (barra superior + trilho vertical + painel de propriedades + popovers); tela inicial com 6 cartões
  (Mundo, Região, Cidade, Interior, Masmorra, Caverna) × Gerar / Em branco / Imagem; pinça no celular.
- Arquivos: `src/master/campaign/map-editor.js` (novo, ~900 linhas), `campaign-map.js` (reescrito), `map-gen.js`, `campaign-model.js`
  (`newMap`/`sanitizeCampaign`: `objs, bg, fx`). Seleção unificada `S.ui.msel=[{t,id}]` (campos antigos sincronizados).
- Limites: relevo do mundo e grama da vila ainda raster; overlay colorido dos reinos "baked"; z-order por tipo
  (objs < reinos < props < pins < tokens); `mpToast` próprio porque `showToast` chama `render()` 2×.

## 3. Campanha real — "Mesa ao vivo" (CSS: `assets/css/campanha.css`, prefixos `mv-`/`tela-`)
- **Combate** (`initiative.js`): iniciativa pelo motor de dados (`rollBase` ou 1d20), turno/rodada, adiar, HP por token
  (`7` dano, `+5` cura, `=12` define), condições, grupo de inimigos numerados, log; atalhos **N/P**.
- **Diário** (`sessions.js`): iniciar/encerrar sessão, cronômetro, linha do tempo, "Da última vez" (migra `sessions` antigas).
- **Notas/handouts** (`handouts.js`) com vínculos a NPC/inimigo/mapa/jogador; **busca da campanha Ctrl+J**.
- **Tela dos jogadores** (`presentation.js`): janela `#tela-jogadores` via BroadcastChannel (fallback `storage`); **nunca** envia
  itens/tokens ocultos, notas de pins, anotações do mapa, PV exato de inimigo ou rolagens secretas.
- **`.campanha` v1** (`campaign-io.js`): `formato:'nexus-campanha'`, valida, **Mesclar** (idempotente) × **Substituir** (faz backup antes),
  limite 48 MB, lembrete de backup (120 alterações/30 min ou ao encerrar sessão).
- **Utilidades** (`table-tools.js`): rolagem secreta, tabelas aleatórias (8+3 de nomes via `nomeProc`), calculadora de encontro
  (heurística), XP, recursos, relógios de ameaça.
- Campos novos de campanha: `notebook, handouts, combat, clocks, resources, tables, xp, present, meta, prep` (+ `sessions` migradas).

## Verificação feita pelo orquestrador
34 scripts passam no parse (`new Function`), sem erros de console; fluxo integrado: conta → modelo "fantasia" (5 atributos) → masmorra
gerada com 59 objetos → token → funções de combate/.campanha presentes → UI renderizada (barra Mesa ao vivo + workspace do mapa).

## Regra aprendida
Ao gravar JS por script, `\n` dentro de string pode virar quebra de linha real e dar `SyntaxError` (ocorreu em 4 arquivos).
Sempre validar o parse de todos os scripts depois (sem Node: carregar no navegador e usar `new Function`).

## Pendências
- Testes em dispositivo de toque real; fallback `localStorage` da tela dos jogadores não testado isoladamente.
- Destaque do token da vez no mapa: usar `t.turn` em `tokenEl` (hoje há um hack por posição no `dashboard.js`).
- Acessibilidade do canvas da ficha; busca Ctrl+K do sistema ainda sem os destinos da campanha (`campBuscaDestinos`).
- Revisão de desempenho do `persist()` com mapas de centenas de objetos; README do repo desatualizado.

## Relacionado
[[nexus-rpg]] · [[nexus-rpg-mapas-geradores]] · [[nexus-rpg-plano-melhorias]] · [[nexus-rpg-telas]] · [[nexus-rpg-dados]]
