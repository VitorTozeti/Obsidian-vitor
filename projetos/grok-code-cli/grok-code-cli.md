---
name: grok-code-cli
description: CLI agente de código estilo Claude Code em Node.js, usando a API da xAI (Grok) com function calling — 4 ferramentas de arquivo/shell restritas ao cwd
tags: [projeto, proj/grok-code-cli, cli, agente, node, xai]
updated: 2026-09-29
---

# grok-code-cli

## Contexto
Simulação de um "Claude Code" no terminal usando a API da xAI (Grok). Loop de agente: lê a
tarefa, decide se usa uma ferramenta, executa e responde. O código vive **dentro do vault**
(`projetos/grok-code-cli/`), irmão conceitual do [[KEMY_AI]] (também agente com tool-calling).
Dados/localização: [[grok-code-cli-dados]].

## Estado atual (2026-09-29)
- Versão `1.0.0`, ES modules, Node >= 18, única dependência `dotenv`.
- Sem histórico/plano registrado; nota criada ao mapear a pasta.

## Conteúdo
- `src/index.js` — REPL (`readline`), lê `GROK_API_KEY`, imprime cada tool-call/resultado; `sair` encerra.
- `src/agent.js` — `callGrok` (POST chat/completions) e `runAgentTurn` (até 12 passos; responde o `tool_call_id` de cada chamada).
- `src/tools.js` — `read_file`, `write_file`, `list_dir`, `run_command` (timeout 60 s); `safeResolve` bloqueia caminhos fora do `cwd`.
- ⚠️ `run_command` executa shell real sem confirmação. Padrão seguro de tool-calls: [[kemy-tool-calling-seguro]].

## Relacionado
- [[grok-code-cli-dados]] · [[KEMY_AI]] · [[mapa-projetos]] · [[mapa-dados]]
