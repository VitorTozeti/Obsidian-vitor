# Regras deste vault (Obsidian) — ATIVAS para o Claude

Este arquivo é lido automaticamente pelo Claude Code no início de cada sessão. Ele
**ativa** as regras deste vault. A fonte canônica e detalhada das regras é
**[GEMINI.md](GEMINI.md)** — trate-o como parte destas instruções e **siga-o
integralmente** (índice, notas atômicas, `<slug>-dados.md` obrigatória, protocolo de
atualização, pesquisa-antes-de-assumir, etc.). Este CLAUDE.md só destaca e mantém
"ativa" a regra que o usuário pediu explicitamente: **cor por projeto no graph**.

## 🎨 Regra sempre ativa: uma cor distinta por projeto (graph view)

**Todo projeto tem, obrigatoriamente, sua própria cor no graph** — aplicada em DOIS
grupos redundantes em `.obsidian/graph.json`, ambos com a **mesma** cor:

1. `{"query":"path:projetos/<slug>/","color":{"a":1,"rgb":<decimal>}}`
2. `{"query":"tag:#proj/<slug>","color":{"a":1,"rgb":<decimal>}}`

**Quando disparar (sem o usuário pedir):**
- **Projeto novo** → antes de encerrar a sessão, crie a pasta `projetos/<slug>/`, a tag
  `proj/<slug>` **e** os dois grupos de cor no `graph.json`. Nunca deixe um projeto sem cor.
- Ao revisar o vault, se achar um projeto **sem** os dois grupos de cor → adicione-os.
- Escolha uma cor **ainda não usada** por outro projeto (ver registro abaixo).

**Como escolher a cor:** pegue a próxima cor livre da paleta em [GEMINI.md](GEMINI.md)
(seção "Cores dos grupos do graph"). Converta hex→decimal com `int("RRGGBB", 16)` e
**confira** — decimal errado = cor errada. Mantenha o `path:` e o `tag:` idênticos.

**Registro rápido de cores em uso** (mantenha atualizado ao criar/renomear projeto;
a fonte por-projeto é a coluna de cor de [mapa-projetos](referencias/mapa-projetos.md)):

| Projeto (`proj/<slug>`) | Cor | Decimal (graph.json) |
|---|---|---|
| `greenfinance` | 🟩 verde #16A34A | 1483594 |
| `nexus-rpg` | 🟪 roxo #9333EA | 9647082 |
| `role-sp` | 🟧 laranja #EA580C | 15357964 |
| `pokedex` | 🟥 vermelho #DC2626 | 14427686 |
| `meu-spotify` | 🟦 teal #0D9488 | 889992 |
| `kemy-ai` | 🟦 azul #2196F3 | 2201331 |
| `megabrain` | 🟧 laranja claro #FB923C | 16495164 |
| `bueno-s-house` | 🟦 índigo #4F46E5 | 5195493 |

**Exceção de nota única (não é cor de projeto):** a nota [[KEMY_AI-dados]] (dentro do
projeto `kemy-ai`) tem contraste extra em **amarelo #EAB308 / 15381256** via
`path:projetos/KEMY_AI/KEMY_AI-dados.md` + `tag:#dados-amarelo`, para diferenciá-la
visualmente do azul do resto do `kemy-ai` — não conta como cor de projeto na tabela acima.

**Cores ainda livres** (da paleta): marrom #92400E / 9584654 ·
lima #65A30D / 6660877 · rosa #DB2777 / 14362487 · ciano #06B6D4 / 440020. (Evite o azul
#2563EB — fica próximo do `kemy-ai` #2196F3. `#EAB308` amarelo está reservado ao contraste
do `KEMY_AI-dados`, acima. `#FB923C` é um laranja mais claro que o `role-sp` #EA580C —
use outro tom se precisar de mais um laranja no futuro.)

> ⚠️ `.obsidian/graph.json` está no `.gitignore` deste vault (config local do Obsidian),
> então a cor **não** sincroniza pelo Git — ela vale na máquina onde foi aplicada. Por
> isso o registro de cores acima e a coluna de cor do `mapa-projetos.md` (que **são**
> versionados) são a memória durável de qual cor pertence a cada projeto: se o
> `graph.json` for recriado, reconstrua os grupos a partir deles.

## Demais regras

Todas em [GEMINI.md](GEMINI.md) — valem igualmente para o Claude. Em resumo do que é
"sempre ativo": comece por `_INDEX.md`; ao entrar num projeto, abra depois
`referencias/mapa-projetos.md`; notas atômicas (1 assunto/arquivo); toda pasta de
projeto tem `<slug>-dados.md`; pesquise nas pastas antes de assumir ou perguntar; e,
ao mudar/descobrir algo, registre no vault **antes de encerrar** (Protocolo de
atualização obrigatória).
