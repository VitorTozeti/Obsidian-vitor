---
name: nexus-rpg-planejamento
description: planejamento e roadmap do Nexus RPG — checklist entregue vs. pendente, backlog priorizado e próximos passos por área
tags: [projeto, proj/nexus-rpg, planejamento, roadmap, rpg]
updated: 2026-09-08
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
