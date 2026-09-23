---
name: KEMY_AI-dados
description: mapa de onde os dados do KEMY_AI vivem — pasta/código, motor Grok via OpenRouter (endpoint, modelo, parâmetros), as 4 ferramentas, variáveis de ambiente KEMY_*/GROK_* e o loop de turno
tags: [projeto, proj/kemy-ai, dados, arquitetura, openrouter, python]
updated: 2026-09-23
---

# KEMY_AI — Onde os dados vivem

Nota de dados/arquitetura do [[KEMY_AI]]. O que existe, onde mora e como se conecta.

## Código / repositório

- **Pasta real:** `C:\Users\v.tozeti\Desktop\Vitor\teste\Obsidian-vitor\projetos\KEMY_AI`
  (o código vive **dentro do vault** — diferente dos outros projetos).
- **Sem remoto Git próprio.** No `.gitignore` do vault: `kemy.py` e `KEMY_AI.zip` são
  **ignorados** (contêm a chave hardcoded); as notas, README e `.env.example` **são versionados**.
- **Arquivos:**
  - `kemy.py` — script único (REPL + ferramentas + chamada de API). ~260 linhas.
  - `README.md` — uso, significado da sigla e avisos de segurança.
  - `requirements.txt` — dependência única: `requests`.
  - `.env.example` — modelo das variáveis (`KEMY_API_KEY`, `KEMY_MODEL`).
  - `.gitignore` (interno) — `.env`, `__pycache__/`, `*.pyc`, `.venv/`.
  - `KEMY_AI.zip` — pacote distribuível (sem `.env`/`__pycache__`).

## Motor de inferência (API)

- **Provedor:** OpenRouter. **Endpoint:** `https://openrouter.ai/api/v1/chat/completions`.
- **Modelo padrão:** `x-ai/grok-4.3` (Grok/xAI). Trocável por env; outros em `openrouter.ai/x-ai`.
- **Parâmetros:** `temperature = 0.3`, `max_tokens = 1024` (default), `tool_choice = "auto"`.
- **Auth:** header `Authorization: Bearer <API_KEY>`.
- ⚠️ **Chave hardcoded** em `_HARDCODED_API_KEY` (dentro de `kemy.py`). Variável de ambiente
  tem prioridade. Revogar/gerar em `https://openrouter.ai/settings/keys`.

## Variáveis de ambiente (com fallback)

| Nova (prioridade) | Fallback antigo | Default | Para quê |
|---|---|---|---|
| `KEMY_API_KEY` | `GROK_API_KEY` | `_HARDCODED_API_KEY` | chave do OpenRouter |
| `KEMY_MODEL` | `GROK_MODEL` | `x-ai/grok-4.3` | modelo usado |
| `KEMY_MAX_TOKENS` | `GROK_MAX_TOKENS` | `1024` | teto de tokens da resposta |

Ordem de resolução no código: `KEMY_*` → `GROK_*` → default. As antigas `GROK_*` seguem
funcionando para não quebrar setups existentes.

## Ferramentas do agente (4)

Definidas em `TOOL_DEFINITIONS` (formato function-calling da OpenAI) e implementadas em `TOOL_IMPLS`:

| Ferramenta | Faz | Observação |
|---|---|---|
| `read_file` | lê um arquivo de texto | caminho relativo **ou absoluto** |
| `write_file` | cria/sobrescreve arquivo | cria pastas-pai; caminho absoluto permitido |
| `list_dir` | lista uma pasta | padrão `.` |
| `run_command` | roda comando de shell | `shell=True`, timeout 60s, **sem confirmação** |

⚠️ **Sem trava de pasta:** `_resolve_path` faz `expanduser().resolve()` sem restringir à raiz —
por decisão do usuário — então o agente alcança qualquer arquivo que o processo tenha permissão.

## Estado da conversa e loop de turno

- `messages` guarda a conversa inteira (system + user + assistant + tool) e é reenviada a cada pergunta.
- Persona fixada na 1ª mensagem `system` (`SYSTEM_PROMPT`): identidade **K.E.M.Y** obrigatória.
- `run_turn` roda até **12 iterações**/turno: chama a API, se vier `tool_calls` executa e devolve
  o resultado como mensagem `role: "tool"`, repete até a resposta final (ou o teto de passos).
- Encoding: `stdout/stderr` forçados a UTF-8 (Windows/cp1252 quebraria acentos/emoji).

## Relacionado
- [[KEMY_AI]] — hub do projeto (estado atual, rebrand, significado da sigla)
- ⭐[[mapa-projetos]]
