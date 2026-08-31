---
name: manutencao-vault
description: método de manutenção do vault — pesquisar antes de assumir/perguntar e o protocolo editorial de registro
tags: [processo, vault, metodo]
updated: 2026-08-24
---

# Manutenção do Vault (método editorial)

Espelha, em nota de processo, o método que vive no `CLAUDE.md` (regras + Protocolo
de atualização obrigatória). Serve de referência rápida para manter o vault coeso.
A fonte normativa continua sendo o `CLAUDE.md`; se divergir, o `CLAUDE.md` vence.

## Regra de ouro
*Se você aprendeu ou mudou algo, o vault reflete isso antes do fim da sessão.*

## Pesquise ANTES de assumir ou perguntar (viés pró-pesquisa)
Sempre que houver dúvida sobre um **dado** — código, chave, tabela, número medido,
base fiscal, regra de negócio, caminho de arquivo, endpoint, credencial, slug/cor de
projeto — **procure a resposta nas pastas primeiro**, antes de inventar um valor OU de
perguntar ao usuário.

Ordem de busca:
1. Referências marcadas `sempre-considerar` (as suas referências transversais).
2. O **hub** e as notas do projeto em questão.
3. O resto do vault (`Grep`/`Glob` por palavra-chave; `Read` dirigido).

Só recorra ao usuário quando a busca **não** resolver — e, aí, diga o que já
procurou. **Nunca** grave um dado "provável" sem checar: um número/código errado
no vault se propaga. Busca dirigida para fechar uma lacuna **≠** ler notas "por
garantia" (a regra de economia continua valendo por padrão).

## Protocolo de registro (quando alterar/descobrir algo)
0. **Cheque o dado** (regra acima) antes de gravar.
1. **Ache a nota certa.** Assunto já tem nota → atualize-a e faça bump de `updated:`.
   Sub-tema novo e grande → crie nota atômica (1 assunto por arquivo).
2. **Pasta certa:** projeto → **`projetos/<slug>/`** (pasta própria do projeto, nunca
   solto na raiz de `projetos/`); senão `referencias/`, `processos/`, `clientes/`.
3. **Etiqueta/cor (por PASTA e por TAG):** projeto existente → nota vai em
   `projetos/<slug>/` + tag `proj/<slug>`. Projeto NOVO → crie a pasta
   `projetos/<slug>/`, ponha a tag `proj/<slug>` e adicione em `.obsidian/graph.json`
   os DOIS grupos com a mesma cor distinta: `path:projetos/<slug>/` **e**
   `tag:#proj/<slug>`. Referência → `referencia` (+ `sempre-considerar` se fundamental).
4. **Conecte** com `[[...]]` ao hub do projeto e às referências usadas.
5. **Atualize o `_INDEX.md`** (linha da nota, aninhada sob o hub) e o **hub**.
6. **Nunca** deixe o conhecimento só no código ou na conversa.

## Frontmatter obrigatório
`name`, `description`, `tags`, `updated` (AAAA-MM-DD). A `description` alimenta o
`_INDEX.md` — capriche nela.

## Sincronização com o GitHub
O envio é **pull-first seguro**: os scripts puxam o remoto antes de enviar e não
sobrescrevem o trabalho de quem subiu na `main`. Ver [[enviar-vault-github]].
