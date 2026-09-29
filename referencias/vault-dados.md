---
name: vault-dados
description: onde vivem os dados do próprio vault — remoto GitHub, scripts de sync, config do Obsidian (graph), preview servers e o que fica fora do Git
tags: [referencia, dados, infra, vault]
updated: 2026-09-29
---

# Vault — Onde os dados vivem

- **Pasta:** `C:\Users\v.tozeti\Desktop\Vitor\teste\Obsidian-vitor` · **remoto:** `https://github.com/VitorTozeti/Obsidian-vitor` (`origin/main`).
- **Scripts (`.scripts/`):** `enviar-github.ps1`, `receber-github.ps1`, `forcar-github.ps1`, `setup-git.ps1`, `auto-sync.ps1`, `sync-diario.ps1` (log `sync-diario.log`, ignorado), `pull-agendado.ps1`, `instalar-tarefa-sexta.ps1`, `notify-config.exemplo.ps1`. Processos: [[enviar-vault-github]], [[receber-vault-github]], [[manutencao-vault]].
- **Config local (fora do Git):** `.obsidian/graph.json` (cores por projeto — reconstruir a partir do registro no `CLAUDE.md` e em [[mapa-projetos]]), `.obsidian/workspace*.json`, `.scripts/notify-config.local.ps1` (senha de app Gmail — nunca versionar), `.scripts/.last-sync-date`.
- **Fora do Git por conter segredo:** `projetos/KEMY_AI/kemy_config.py`, `projetos/KEMY_AI.zip`, `projetos/KEMY_AI/.env` (ver [[KEMY_AI-dados]]).
- **Preview servers (`.claude/launch.json`):** `poke-static` (8791), `kemy-web` (8800), `mural-static` (8792).
- **Índices:** `_INDEX.md`, [[mapa-projetos]], [[mapa-dados]].

## Relacionado
- [[mapa-dados]] · ⭐[[mapa-projetos]] · [[kemy-tool-calling-seguro]]
