# Vault-Base (modelo de conhecimento)

Base de conhecimento em Markdown, versionada no Git e editável no Obsidian.
Projetada para **economizar tokens**: o Claude lê só o índice (`_INDEX.md`) e abre
notas específicas apenas quando são relevantes.

Esta pasta é um **modelo limpo** — traz a estrutura, as regras (`CLAUDE.md`) e toda a
automação de sincronização com o GitHub, **sem nenhum dado de projeto**. Copie-a para
começar um vault novo.

## Estrutura
```
base_obsidians/
  _INDEX.md          <- índice mestre (1 linha por nota) — o que o Claude lê por padrão
  CLAUDE.md          <- regras de uso/economia para o Claude (inclui como montar o _INDEX)
  clientes/          <- notas por cliente
  processos/         <- rotinas internas (sync com GitHub, manutenção do vault)
  referencias/       <- dados de consulta (começa com o mapa-projetos)
  projetos/          <- uma pasta por projeto (proj/<slug> + <slug>-dados.md)
  templates/         <- modelos de nota
  .scripts/          <- automação de sincronização com o Git
```

## Começar um vault novo a partir deste modelo
1. Copie a pasta `base_obsidians` para o local desejado e renomeie.
2. Abra a pasta como **vault** no Obsidian.
3. Conecte ao GitHub (passo abaixo) e comece a criar notas seguindo o `CLAUDE.md`.

## Como conectar ao GitHub (1x por computador)
1. Crie um repositório **privado e vazio** no GitHub (sem README).
2. Copie a URL (ex.: `https://github.com/usuario/meu-vault.git`).
3. Na pasta do vault, rode:
   ```powershell
   powershell -ExecutionPolicy Bypass -File .scripts\setup-git.ps1 "URL_DO_REPO"
   ```

## Sincronização automática (sobe a cada alteração)
Deixe rodando em segundo plano:
```powershell
powershell -ExecutionPolicy Bypass -File .scripts\auto-sync.ps1
```
Ele observa a pasta e faz `commit` + `push` (pull-first) automático ~8s após cada mudança.
Também há o plugin **obsidian-git** (auto-backup + pull/push a cada ~2 min) e um hook
`SessionStart` que sincroniza 1x/dia ao abrir o Claude Code. Ver `processos/`.

## Usar em outro computador
```powershell
git clone URL_DO_REPO
```
Abra a pasta como vault no Obsidian e rode o `auto-sync.ps1`.

## Regras de ouro (para economizar tokens)
- 1 assunto = 1 nota (notas atômicas).
- Sempre atualize a linha da nota em `_INDEX.md`.
- Capriche na `description` do frontmatter — é ela que guia o Claude.
- Projeto novo = pasta própria `projetos/<slug>/` + tag `proj/<slug>` + grupo de cor no
  `graph.json` + nota `<slug>-dados.md`. Detalhes no `CLAUDE.md`.
