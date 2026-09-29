---
name: grok-code-cli-dados
description: mapa de localização de dados do grok-code-cli — pasta, endpoint xAI, variáveis GROK_*, ferramentas e arquivos do código
tags: [projeto, proj/grok-code-cli, dados, api]
updated: 2026-09-29
---

# grok-code-cli — Onde os dados vivem

## 1. Repositório e código
- **Pasta:** `C:\Users\v.tozeti\Desktop\Vitor\teste\Obsidian-vitor\projetos\grok-code-cli` (dentro do vault, versionado com ele). Sem repo próprio.
- **Arquivos:** `package.json`, `README.md`, `.env.example`, `.gitignore` (`node_modules/`, `.env`), `src/{index,agent,tools}.js`.

## 2. API externa
- **Endpoint:** `POST https://api.x.ai/v1/chat/completions` (Bearer, function calling, `temperature 0.2`, `tool_choice auto`).
- **Console/chave:** https://console.x.ai

## 3. Credenciais e variáveis (nomes, nunca valores)
- `GROK_API_KEY` — obrigatória, em `.env` local (ignorado pelo Git; modelo em `.env.example`).
- `GROK_MODEL` — opcional, padrão `grok-code-fast-1`.

## 4. Ferramentas do agente
`read_file`, `write_file`, `list_dir`, `run_command` — caminhos restritos a `process.cwd()` (o shell em si não é sandboxado).

## 5. Estado / arquivos intermediários
Nenhum: o histórico de conversa fica só em memória durante a sessão.

## Relacionado
- [[grok-code-cli]] — hub · [[KEMY_AI-dados]] (variáveis `GROK_*` também aparecem lá) · [[mapa-dados]] · ⭐[[mapa-projetos]]
