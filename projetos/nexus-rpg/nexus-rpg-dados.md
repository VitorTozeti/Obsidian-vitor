---
name: nexus-rpg-dados
description: mapa de localização de dados, repositório, chaves do LocalStorage e arquitetura de arquivos do Nexus RPG
tags: [proj/nexus-rpg, dados, infra, arquitetura]
updated: 2026-09-07
---

# Nexus RPG — Onde os Dados Vivem

Nota de localização técnica e persistência do projeto [[nexus-rpg]].

## Repositórios e Links

- **Repositório Local no Disco:** `C:\Users\Vitor\Desktop\projetos\The-One-System`
- **Repositório GitHub:** `VitorTozeti/The-One-System` (`https://github.com/VitorTozeti/The-One-System`)
- **Deploy / Execução:** 100% offline, executável diretamente via navegador abrindo `index.html` (protocolo `file://`). Não requer servidor HTTP local nem etapas de build.

## Estrutura de Arquivos e Código-fonte

O projeto não utiliza bundlers (Vite/Webpack) nem módulos ES para manter a portabilidade direta via `file://`. A aplicação é composta por scripts clássicos ordenados em `index.html`:

```
index.html                  # Casca HTML e inclusão sequencial de scripts
assets/css/styles.css       # Folha de estilo global e variáveis CSS em :root
src/
  auth/
    accounts.js             # Modelagem de contas, sessões e isolamento de personagens
    auth-ui.js              # Telas de login, registro e seleção de personagens
  core/
    helpers.js              # Utilitários de DOM (h/node), persistência e strings
    formula-engine.js       # Tokenizer e avaliador de fórmulas matemáticas
    dice-engine.js          # Parser e executor de rolagens de dados
    state.js                # Estado global reativo (S) e despachante de renderização
    history.js              # Pilhas de Desfazer/Refazer (Undo/Redo)
  data/
    example-system.js       # Definição do sistema de exemplo e migração de ficha
  ui/
    shortcuts.js            # Mapeamento de atalhos de teclado do editor
    ui-basic.js             # Componentes reutilizáveis de interface
    glossary.js             # Dicas de contexto e termos do sistema
    formula-field.js        # Campo com realce de sintaxe de fórmulas
  master/
    master-nav.js           # Barra de navegação e abas do Mestre
    master-pieces.js        # Formulários das 16 peças do sistema
  player/
    player.js               # Assistente de criação e renderizador da ficha
  app.js                    # Bootstrap final e chamada de inicialização render()
```

### Ordem Estrita de Carregamento (`<script>`)
Por utilizarem escopo global, a ordem das tags `<script>` no `index.html` é crítica:
1. `core/helpers` → `core/formula-engine` → `core/dice-engine`
2. `data/example-system`
3. `core/state` → `core/history`
4. `ui/*`
5. `master/*`
6. `player/player`
7. `app.js` (executa por último disparando a renderização inicial)

## Armazenamento e Persistência de Dados (LocalStorage)

Todos os dados da aplicação residem no `localStorage` do navegador do usuário:

| Chave | Formato | Conteúdo |
|---|---|---|
| `nexus_accounts` | JSON Array | Lista de contas: `[ { id, name, pass, createdAt } ]` |
| `nexus_session` | JSON Object | Sessão ativa: `{ accountId, personagemId }` |
| `nexus_acct_<id>` | JSON Object | Dados da conta: `{ personagens: [ { id, kind, name, system | draft+saved } ] }` |

> ⚠️ **Nota sobre segurança de credenciais:** o app foi concebido como protótipo offline e armazena senhas em texto puro no `localStorage`. Não utilize senhas reais.

## Arquivos Intermediários e Formatos de Exportação

- **Arquivos `.nexus` (JSON):** formato completo de exportação e importação de sistemas de RPG (regras, fórmulas, tabelas, blocos de ficha e configurações de campanha).
- **Versionamento de Schema:** mantido no código como `SCHEMA = 10`, suportando migração automática para estruturas salvas a partir do schema 6.
