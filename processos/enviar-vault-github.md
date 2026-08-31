---
name: enviar-vault-github
description: como enviar o vault para o GitHub de uma vez (script one-click resiliente)
tags: [processo, git, sync]
updated: 2026-08-24
---

# Enviar o vault para o GitHub (one-click)

Repo remoto: o que estiver configurado no `origin` (branch `main`). Configure uma vez
com `setup-git.ps1` (ver [[receber-vault-github]] e o `README.md`).

> **Política PULL-FIRST SEGURA.** Como pode haver mais de uma pessoa subindo na
> `main`, os scripts **puxam o remoto ANTES de enviar** e **nunca sobrescrevem** o
> trabalho de quem subiu. Em conflito real, o script **para e pede resolução manual**
> — não escolhe lado. A política "local vence sempre" (`push --force`) foi removida do
> caminho padrão (fica só no `forcar-github`, último recurso).

## Forma mais fácil
Duplo clique em **`enviar-github.bat`** (na raiz do vault). Ele chama
`.scripts/enviar-github.ps1`.

## O que o script faz (pull-first seguro)
1. `git add -A` — adiciona **tudo**, inclusive arquivos novos/não rastreados.
2. `git commit` com data/hora (ou mensagem: `enviar-github.ps1 -Mensagem "texto"`).
3. `git pull --no-rebase origin main` — **puxa e faz merge do remoto ANTES do
   push**. Se der **conflito**, o script **aborta** e pede para você resolver a
   mão (`git status` → editar → `git add` → `git commit`) e rodar de novo.
4. `git push origin main` — envio normal, **sem `--force`**. Se o remoto avançou
   no meio do caminho, é só rodar de novo (puxa o novo estado e reenvia).

## Envio FORÇADO (último recurso, destrutivo)
Só quando o histórico ficou realmente incompatível, use **`forcar-github.bat`**
→ `.scripts/forcar-github.ps1`. Usa **`push --force-with-lease`** (não apaga se o
remoto avançou desde o último fetch); se ainda falhar, há um fallback que reescreve o
remoto do zero. **⚠️ Destrutivo e último recurso**: antes, sempre tente
`git pull --no-rebase` e o `enviar-github.ps1`. Aceita `-RepoUrl` para configurar o
`origin` na hora.

```powershell
powershell -ExecutionPolicy Bypass -File .scripts\forcar-github.ps1 -RepoUrl "https://github.com/USER/REPO.git"
```

> Par deste processo: [[receber-vault-github]] — puxar do GitHub sem perder o
> trabalho local, e a tarefa agendada de sexta 12h com aviso por e-mail.

## Scripts relacionados na pasta `.scripts/`
- `enviar-github.ps1` — envio manual pull-first; conflito para e pede resolução.
- `receber-github.ps1` — pull seguro (ver [[receber-vault-github]]).
- `forcar-github.ps1` — FORÇADO (`--force-with-lease`), último recurso destrutivo.
- `auto-sync.ps1` — polling (a cada 8s): **puxa antes** de commit+push; conflito aborta o ciclo.
- `setup-git.ps1` — conecta o vault a um repo GitHub novo (roda uma vez).

> Também roda o plugin **obsidian-git** (auto-backup a cada mudança, pull/push a
> cada ~2 min, `pullBeforePush: true` e `autoPullOnBoot: true` — puxa ao abrir o
> Obsidian, antes de empurrar). Os três "motores" convergem no pull-first para não
> brigar pela `main`.

## Uso por linha de comando
```powershell
powershell -ExecutionPolicy Bypass -File .scripts\enviar-github.ps1 -Mensagem "minha nota"
```
