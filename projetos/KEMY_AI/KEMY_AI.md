---
name: KEMY_AI
description: chat-bot de terminal em Python (ex grok-chat-cli) cuja persona é a K.E.M.Y — Kernel Engine for Modular Yield — assistente de engenharia de software estilo Claude Code, com ferramentas de arquivo/shell; motor Grok/OpenRouter por baixo
tags: [projeto, proj/kemy-ai, cli, python, chatbot, agente, openrouter, grok]
updated: 2026-09-23 (rebrand grok-chat-cli → KEMY_AI + persona fixa K.E.M.Y; depois: busca recursiva find_files/search_text com grande liberdade de acesso a pastas)
---

# KEMY_AI — assistente de terminal K.E.M.Y

Chat-bot de terminal em **Python** que conversa livremente (mantendo o contexto de
toda a conversa, como no Claude Code) e pode usar ferramentas para ler/escrever
arquivos, listar pastas e rodar comandos de shell no projeto atual. A persona
exposta ao usuário é a **K.E.M.Y**, que se apresenta e responde **sempre** com esse
nome. O modelo por baixo é o **Grok (xAI) via OpenRouter**, mas isso fica escondido:
para quem usa, quem responde é a K.E.M.Y.

> Antes se chamava **grok-chat-cli**. Foi renomeado para **KEMY_AI** em 2026-09-23.

## O nome — K.E.M.Y = *Kernel Engine for Modular Yield*

Sigla escolhida com cara de desenvolvimento:

- **K**ernel — o núcleo do agente (mantém a conversa e decide o que fazer).
- **E**ngine — o motor que orquestra chamadas de modelo + ferramentas.
- **M**odular — ferramentas plugáveis (`read_file`, `write_file`, `list_dir`,
  `run_command`), fáceis de estender.
- **Y**ield — *entregar/produzir* código e resultados (aceno ao `yield` da programação).

Leitura curta: *"o motor-núcleo modular que entrega código"*.

## Estado atual (2026-09-23)

- **Fase:** **funcionando, rebrand concluído.** Repositório/código real vive **dentro
  do próprio vault**, em `projetos/KEMY_AI/` (caso incomum — os outros projetos guardam
  o código fora). Ver mapa completo em [[KEMY_AI-dados]].
- **Rebrand grok-chat-cli → KEMY_AI (feito):**
  - Pasta `projetos/grok-chat-cli/` → `projetos/KEMY_AI/`; script `grok_chat.py` → `kemy.py`.
  - Banner do REPL e prompt de resposta agora são `K.E.M.Y>` (antes `grok>`).
  - `SYSTEM_PROMPT` reescrito com **identidade inegociável**: a IA deve se apresentar e
    se referir a si mesma **sempre como K.E.M.Y**, **nunca** como "Grok"/"xAI".
  - Variáveis de ambiente novas **`KEMY_API_KEY` / `KEMY_MODEL` / `KEMY_MAX_TOKENS`**,
    com **fallback** para as antigas `GROK_*` (compatibilidade).
  - Função interna `call_grok` → `call_kemy`; README e `.env.example` refeitos; `KEMY_AI.zip`
    reempacotado (sem `.env`/`__pycache__`).
- **Modelo/infra:** OpenRouter, endpoint `chat/completions`, modelo padrão `x-ai/grok-4.3`,
  `temperature 0.3`, `max_tokens` 1024 (default). Loop de ferramentas com teto de 12 passos
  por turno. Detalhes em [[KEMY_AI-dados]].
- **Ferramentas (6):** `read_file`, `write_file`, `list_dir`, `find_files`, `search_text`,
  `run_command` — todas **sem trava de pasta** (aceitam caminho absoluto, fora do projeto)
  e `run_command` roda shell real sem confirmar. Ver o aviso de segurança abaixo.
- **Busca livre pelas pastas (2026-09-23, feito):** ganhou `find_files` (acha arquivo por
  nome/glob) e `search_text` (grep dentro dos arquivos), ambos **recursivos** a partir de
  qualquer caminho — a K.E.M.Y agora "procura à vontade" pelo disco, não só lista uma pasta.
  Pulam pastas de ruído (`.git`, `node_modules`, etc.); limites por env `KEMY_SEARCH_MAX_RESULTS`
  (200) e `KEMY_SEARCH_MAX_DEPTH` (8). O `SYSTEM_PROMPT` passou a instruir **procurar antes de
  assumir/perguntar**. Detalhes em [[KEMY_AI-dados]].

## ⚠️ Segurança (dois pontos herdados, ainda válidos)

1. **Chave de API hardcoded** em `kemy.py` (`_HARDCODED_API_KEY`, OpenRouter). Conveniente
   para uso local, **inseguro** para qualquer outra coisa. Por isso `kemy.py` e `KEMY_AI.zip`
   ficam no `.gitignore` do vault — **nunca versionar/compartilhar o script com a chave**.
   As **notas** (`KEMY_AI.md`, `KEMY_AI-dados.md`), o README e o `.env.example` **são**
   versionados normalmente. Se a chave vazar: revogar em `openrouter.ai/settings/keys`.
2. **Sem sandbox de pasta + `run_command` sem confirmação:** a K.E.M.Y pode ler/sobrescrever
   qualquer arquivo do usuário no Windows e rodar comandos reais. Um prompt malicioso escondido
   num arquivo que ela leia pode causar estrago fora do projeto. Acompanhar o que ela propõe.

## Como rodar

```bash
pip install -r requirements.txt
python kemy.py
```

Conversa livre; `sair`/`exit`/Ctrl+C encerra. Config completa no [[KEMY_AI-dados]] e no README da pasta.

## Relacionado
- [[KEMY_AI-dados]] — onde os dados vivem: repo, API/OpenRouter, ferramentas, variáveis de ambiente
- ⭐[[mapa-projetos]] — carregamento de contexto por projeto
