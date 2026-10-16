---
name: nexus-rpg-planejamento
description: planejamento e roadmap do Nexus RPG — checklist entregue vs. pendente, backlog priorizado e próximos passos por área
tags: [projeto, proj/nexus-rpg, planejamento, roadmap, rpg]
updated: 2026-10-16
---

# Nexus RPG — Planejamento

Nota de planejamento do projeto **Nexus RPG** (repositório real no disco:
`C:\Users\v.tozeti\Desktop\Vitor\teste\The-One-System`). Consolida o que já foi
entregue, o que está pendente e a ordem sugerida de ataque. Hub do projeto:
[[nexus-rpg]].

> Fonte: `README.md`, `ideias.md` e `nexus-rpg-prototipo.md` do repositório
> (checklist de melhorias + log de alterações) e o estado atual do código em `src/`.

## Contexto

- App **100% offline** (vanilla JS, sem build, `file://`, dados no `localStorage`).
- Já modularizado de arquivo único para estrutura em `src/` — ver [[nexus-rpg-dados]].
- Detalhamento de telas em [[nexus-rpg-telas]]; motores internos em [[nexus-rpg-arquitetura]].

## Já entregue (checklist ✅)

**Navegação e estrutura do Modo Mestre (itens 1–10)**
- Agrupamento das 16 abas em 4 grupos com sub-abas.
- Separação essencial vs. avançado (Modo Simples/Avançado, salvo em `nexus_modo`).
- Badge de contagem por aba; ponto de alerta por aba/grupo (~25 checagens).
- Botão "Próximo passo →", barra de progresso dos 12 passos essenciais.
- Aba 🧭 Início com checklist clicável; busca global Ctrl+K (~60 destinos, sem acento).
- Breadcrumb fixo clicável.

**Onboarding (14–15)**
- Tooltips "?" em ~24 campos técnicos; glossário (35 verbetes, 6 categorias, modal + Ctrl+K).

**Fórmulas (19–25)**
- Componente único `campoFormula(...)`: realce de sintaxe, autocomplete, construtor por
  chips, lista de variáveis com valor por degrau, fórmulas prontas por contexto,
  prévia em 3 pontos (mín/médio/máx) e diagnóstico específico de erro com sugestão.

**Além do checklist original**
- Sistema de **contas locais** (login + isolamento por conta, hub de personagens).
- **Suíte de campanha do Mestre**: dashboard, dados, jogadores, bestiário, mapa e itens
  (`src/master/campaign/`).

## Pendente (backlog priorizado)

### Prioridade 1 — Editor de ficha (fecha lacunas de usabilidade)
- [ ] **37. Botões ↶ ↷ visíveis** na barra (hoje só atalho de teclado) — baixo esforço, alto retorno.
- [ ] **38. Lixeira / restaurar bloco removido** — segurança contra remoção acidental.
- [ ] **32. Estilos nomeados / tema da ficha** — cor de acento única propaga a todos os blocos.
- [ ] **39. Snap entre blocos** com indicação de espaçamento igual (além da grade).
- [ ] **40. Miniatura do bloco na paleta** (não só o nome).
- [ ] **33. Mais modelos prontos** — compacta 1 página, retrato, caderno, cartão de NPC.
- [ ] **36. Ficha responsiva para celular** — empilhamento automático do canvas.

### Prioridade 2 — Visual / acessibilidade
- [ ] **56. Tema claro** além do escuro.
- [ ] **57. Aumentar contraste** dos textos `--muted` / `--dim`.
- [ ] **59. Padronizar o conjunto de ícones** (hoje mistura estilos de emoji).

### Prioridade 3 — Recursos maiores (mudam a arquitetura)
- [ ] **Marketplace / compartilhamento de sistemas** — publicar/baixar sistemas; hoje só
  templates locais + export/import `.nexus`. Evolução: repositório com busca, avaliação e versão.
- [ ] **Modo online em tempo real** — convite por link, sincronização de fichas/mapa via
  WebSocket. Exige backend (contas reais, auth, banco) e abandona o "abrir com dois cliques".
- [ ] **Módulo tático de combate** — iniciativa/ordem de turno com tokens do mapa + rolagem.
- [ ] Exportar/importar **campanha inteira** (`.campanha`).
- [ ] Sons/imagens de ambientação por cena.

## Próximos passos sugeridos

1. Fechar a **Prioridade 1** (editor de ficha) em lotes pequenos, cada entrega virando uma
   linha no "Log de alterações" do `nexus-rpg-prototipo.md`.
2. Depois **Prioridade 2** (tema claro + contraste + ícones) — melhora percebida rápida.
3. Só então avaliar **Prioridade 3**, decidindo se vale sair do modelo 100% offline.

## Análise técnica (2026-10-13)

> Rodada de implementação no mesmo dia: geradores de mapa, zoom/pan, hex, backup, tela de falha, acessibilidade — [[nexus-rpg-mapas-geradores]].

Auditoria do código em `The-One-System` (~7k linhas, 24 `<script>` globais, 308 funções globais).
Commits recentes (mapas/dados didáticos) estão além do que esta nota descrevia.

1. **Persistência sem proteção de cota** — `store()` (`src/core/helpers.js:25`) faz `setItem`
   sem `try/catch`; mapas e fotos em base64 estouram ~5MB e o app falha em silêncio/exceção.
   Tratar `QuotaExceededError`, avisar o usuário e comprimir imagens (`readPhoto`, `campaign-map.js`).
2. **Sem backup automático** — tudo vive só no `localStorage`; limpar o navegador apaga a campanha.
   Exportar/importar campanha inteira (`.campanha`) e lembrete de backup vira prioridade 1.
3. *(corrigido em 2026-10-13: `persist()` já trata cota — ver [[nexus-rpg-mapas-geradores]])* **`h({html:})` e `innerHTML`** — hoje os usos escapam com `esc()`, mas `html:` é um ponto
   frágil; preferir `textContent`/nós e restringir `html:` a literais fixos.
4. **Senha em texto plano** (já conhecido) — se virar algo além de protótipo, ao menos hash
   (PBKDF2 via WebCrypto) ou remover o conceito de senha no modo local.
5. **Zero testes automatizados** — motores de fórmula e dados (`formula-engine.js`,
   `dice-engine.js`) são puros e ideais p/ testes unitários; migrações de `sanitizeSystem`/
   `migrateSystem` também. Hoje só há `--dump-dom`.
6. **Acessibilidade** — só 1 ocorrência de `aria-*` em todo o código; falta foco/teclado nas
   telas e contraste (`--muted`/`--dim`, já no backlog 57).
7. **Arquitetura** — `player.js` (1253 linhas), `master-pieces.js` (947) e `campaign-map.js`
   (607) concentram demais; escopo global e ordem de `<script>` são frágeis. Opção sem quebrar
   `file://`: IIFEs/namespaces (`Nexus.formula`, …) ou bundle único gerado por script.
8. **Deploy** — workflow ainda é o template Jekyll do GitHub Pages (site é estático puro);
   trocar por publicação direta de arquivos estáticos e rodar testes no CI.
9. **Sem tratamento global de erro** — nenhum `window.onerror`/`unhandledrejection`; um erro
   de render deixa a tela em branco. Adicionar fallback + botão "exportar dados" na falha.
10. **Backlog antigo** (editor de ficha ↶ ↷, lixeira, tema claro, ícones) segue válido — ver
    Prioridades 1–2 acima.

## Riscos / restrições

- Manter tudo funcionando via `file://` (scripts clássicos globais, ordem de `<script>` importa).
- Senha em texto plano no `localStorage` — apenas protótipo, não usar senha real.
- Cota do `localStorage`: recursos maiores (marketplace/online) exigem backend.
- Testes atuais são via Chrome headless `--dump-dom` (validam DOM/CSS, não o visual real).

## Relacionado
- [[nexus-rpg]] — hub do projeto
- [[nexus-rpg-telas]] — detalhamento tela a tela
- [[nexus-rpg-dados]] — onde os dados vivem
- [[nexus-rpg-arquitetura]] — funcionamento interno e guia de evolução

## Feedback de teste às cegas (2026-10-16)
Backlog priorizado de funcionalidades e UX/UI vindo de um teste de ponta a ponta criando um sistema de Re:Zero: ver [[nexus-rpg-teste-rezero-ux]] (gatilhos de evento, contador/relógio, nível opcional, resultado de rolagem em destaque, ficha sem scroll interno, navegação que troca em vez de empilhar).
