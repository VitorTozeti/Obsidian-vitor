---
name: receber-vault-github
description: como puxar o vault do GitHub sem perder o trabalho local + tarefa agendada de sexta 12h com aviso por e-mail em caso de falha
tags: [processo, git, sync]
updated: 2026-08-24
---

# Receber o vault do GitHub (pull seguro) + tarefa de sexta

Repo remoto: o configurado no `origin` (branch `main`). Este é o par do
[[enviar-vault-github]]: aqui a máquina **puxa** as mudanças que subiram no GitHub,
**sem apagar** o que a pessoa já tem localmente.

> **Configurar o `origin` (uma vez por máquina/repo):**
> ```powershell
> powershell -ExecutionPolicy Bypass -File .scripts\setup-git.ps1 "https://github.com/USER/REPO.git"
> ```

> **Por que "sem perder dados":** antes do `git pull`, o script **commita** o que
> houver de alteração local. Assim o pull é sempre um **merge** entre o trabalho
> local (já salvo em commit) e o remoto — nada é descartado. Em conflito real, o
> script **para e pede resolução manual**, não escolhe lado.

## Puxar manualmente (one-click)
Duplo clique em **`receber-github.bat`** (raiz do vault) → chama
`.scripts/receber-github.ps1`. Ou por linha de comando:

```powershell
powershell -ExecutionPolicy Bypass -File .scripts\receber-github.ps1
```

## Tarefa agendada — toda SEXTA às 12:00 (com aviso por e-mail)
Cada colega roda **uma vez** o instalador na máquina dele:

```powershell
powershell -ExecutionPolicy Bypass -File .scripts\instalar-tarefa-sexta.ps1
```

Isso registra a tarefa `Vault-Pull-Sexta` no Agendador do Windows (sexta, 12:00,
`StartWhenAvailable` — se o PC estiver desligado, roda assim que ligar). A ação é
`.scripts/pull-agendado.ps1`, que:
1. roda o pull seguro (`receber-github.ps1`);
2. grava tudo em `.scripts/pull-agendado.log`;
3. **se o pull falhar** (conflito, sem rede, sem credencial do GitHub), **envia
   e-mail** para o destinatário configurado via Gmail SMTP.

Testar sem esperar sexta: `Start-ScheduledTask -TaskName 'Vault-Pull-Sexta'`.
Remover: `... instalar-tarefa-sexta.ps1 -Remover`.

## Configurar o e-mail (senha de app do Gmail) — NÃO vai pro GitHub
O e-mail exige uma conta Gmail remetente com **verificação em 2 etapas** e uma
**senha de app** (16 letras, gerada em <https://myaccount.google.com/apppasswords>).
Em cada máquina:
1. copie `.scripts/notify-config.exemplo.ps1` → `.scripts/notify-config.local.ps1`;
2. preencha `$GmailUser` (remetente), `$GmailAppPassword` (senha de app) e `$NotifyTo`.

O arquivo `notify-config.local.ps1` está no `.gitignore` — **a senha nunca é
versionada nem enviada ao GitHub**. Sem esse arquivo, a falha ainda é registrada
no log, mas o e-mail não é enviado.

## Alternativa ao Agendador: sync 1x/dia ao abrir o Claude
Em vez (ou além) da tarefa de sexta, há um **hook `SessionStart`** em
`.claude/settings.json` (versionado). Na **primeira** vez que o Claude Code abre o
vault a cada dia, ele roda `.scripts/sync-diario.ps1` em segundo plano:

1. commita o que houver local (protege o trabalho);
2. `git pull --no-rebase` (baixa tudo, merge; conflito aborta e avisa);
3. `git push` (sobe tudo, sem `--force`);
4. se algo falhar, **e-mail** via Gmail (mesma `notify-config.local.ps1`).

Guarda de **1x/dia** pelo marcador `.scripts/.last-sync-date` (gitignore): já
rodou hoje → sai na hora. Forçar na mão: `... sync-diario.ps1 -Force`.

> ⚠️ Só dispara **onde o Claude Code roda** dentro do vault. Colega que abre o
> vault só no Obsidian (sem Claude Code) **não** aciona este hook — para esse
> caso, use a tarefa de sexta (Agendador) ou o obsidian-git.

## Scripts relacionados na pasta `.scripts/`
- `sync-diario.ps1` — sync 1x/dia (commit+pull+push) do hook SessionStart; e-mail se falhar.
- `receber-github.ps1` — pull seguro (commita local antes; conflito para e pede resolução).
- `pull-agendado.ps1` — ação da tarefa: pull + log + e-mail de falha.
- `instalar-tarefa-sexta.ps1` — registra/remove a tarefa `Vault-Pull-Sexta` (sexta 12h).
- `notify-config.exemplo.ps1` — modelo da config de e-mail (copiar p/ `.local`).

> Lembrete: o plugin **obsidian-git** já faz pull/push a cada ~2 min e
> `autoPullOnBoot`. A tarefa de sexta é uma **rede de segurança** extra com aviso
> ativo por e-mail — não substitui o obsidian-git, reforça.
