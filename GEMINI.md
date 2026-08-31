# Instruções de uso deste vault (economia de tokens)

Este é um **vault-base** (modelo) de conhecimento em Markdown, versionado no Git e
editável no Obsidian. Copie esta pasta para começar um vault novo; ela já vem com a
estrutura, as regras e toda a automação de sincronização com o GitHub — **sem nenhum
dado de projeto**. O objetivo é guardar informação de forma barata em tokens.

## Regras para o GEMINI

1. **Comece SEMPRE por `_INDEX.md`.** Ele é o índice mestre: uma linha por nota.
   Use as descrições do índice para decidir o que é relevante.
1.1. **Carregamento de contexto por projeto (regra de ouro do "puxar tudo de X"):** quando a
   conversa girar em torno de um projeto, o 2º arquivo a abrir (depois do `_INDEX.md`) é
   `referencias/mapa-projetos.md` — a tabela que diz, por projeto, o **hub** a abrir, o
   **repositório real** no disco e as **referências `sempre-considerar`** daquele projeto.
   Abra o hub; só então desça às notas detalhadas que o hub indexar. Isso substitui adivinhar
   caminhos ou reler várias notas "por garantia".
2. **Só abra uma nota específica quando o índice indicar que ela importa** para a pergunta atual.
   NUNCA leia o vault inteiro nem várias notas "por garantia". (Exceção: a **busca dirigida**
   para preencher uma dúvida concreta — ver regra 9 — é permitida e incentivada.)
3. **Notas são atômicas** — 1 assunto por arquivo. Se um assunto crescer demais, quebre em duas notas.
4. **Ao criar ou alterar uma nota, atualize a linha dela em `_INDEX.md`** (título + gancho de 1
   frase). ⚠️ O `_INDEX.md` é gancho de **1 frase por nota** — NÃO empilhe blocos datados de
   histórico nele. O "estado corrente" de um projeto (o que está em andamento, o que falta
   validar, últimas mudanças) mora na seção **`## Estado atual (AAAA-MM-DD)`** no **hub** do
   projeto (logo após a introdução), datada e enxuta. Ao mexer num projeto, **atualize o
   `## Estado atual` do hub** e faça bump da data; o detalhe histórico vai para a nota atômica
   do sub-tema, não para o índice. Projeto novo → o hub já nasce com um `## Estado atual`, e
   adicione a linha do projeto em `referencias/mapa-projetos.md`.
5. **Frontmatter obrigatório** em cada nota: `name`, `description`, `tags`. A `description` é o que
   torna o índice preciso — capriche nela.
6. **Notas com a tag `sempre-considerar`** são dados de referência fundamentais: ao trabalhar
   em QUALQUER projeto do domínio, consulte-as **antes de assumir** códigos, chaves,
   base fiscal ou regras de negócio. Marque com essa tag as referências transversais do seu
   contexto (ex.: um catálogo de códigos de sistema, uma tabela de integrações/endpoints).
7. **Todo projeto = UMA pasta própria + UMA etiqueta `proj/<slug>` (as duas coisas,
   sempre).** A separação é **por pasta**: cada nota de projeto mora em
   `projetos/<slug>/` (ex.: `projetos/meu-projeto/minha-nota.md`) **e** carrega a
   tag `proj/<slug>`. O **graph view** colore por DOIS critérios redundantes em
   `.obsidian/graph.json`: o grupo da **pasta** (`path:projetos/<slug>/`) **e** o da
   **tag** (`tag:#proj/<slug>`), ambos com a **mesma cor**. Nota de projeto existente →
   coloque-a na pasta dele e reutilize o slug. **Projeto NOVO (OBRIGATÓRIO, não opcional):**
   crie a pasta `projetos/<novo-slug>/`, ponha a nota lá, adicione a tag `proj/<novo-slug>`
   **e** adicione NO `graph.json` os DOIS grupos de cor (`path:projetos/<novo-slug>/` **e**
   `tag:#proj/<novo-slug>`) com uma cor distinta (tabela abaixo). Nunca crie um projeto
   sem a tag e sem a pasta.
7.1. **Princípio: todo dado novo é avaliado para grupo antes de virar nota.** Não herde a
   etiqueta do projeto "hospedeiro" (ex.: mesmo repositório, mesma pasta) por padrão — a
   pergunta é se o **assunto** é o mesmo, não onde o código mora. Se o dado tem público,
   cadência, regras de negócio ou saída (deck/planilha/API) **diferentes** do projeto onde
   foi encontrado, ele é um **projeto próprio**: novo `proj/<slug>` + novo grupo de cor no
   `graph.json`, mesmo que compartilhe repositório com outro projeto. Se é só um detalhe do
   mesmo assunto, entra como nota atômica sob o `proj/<slug>` já existente. Na dúvida,
   prefira separar — juntar depois é mais barato do que desembaraçar um grupo de cor que já
   cresceu misturado.
8. **⚠️ ATUALIZAÇÃO OBRIGATÓRIA (não opcional):** toda vez que o Claude **alterar** algo
   de um projeto (código, config, regra) OU **puxar/descobrir dados novos** (explorar um
   repo, medir números, mapear uma integração/endpoint/credencial, entender uma regra de
   negócio), ele **DEVE registrar isso no vault ANTES de encerrar**, na pasta certa, com a
   etiqueta/cor certa. Ver **Protocolo de atualização obrigatória** abaixo. Regra de ouro:
   *se o Claude aprendeu ou mudou algo, o vault reflete isso antes do fim da sessão.*
9. **⚠️ PESQUISE ANTES DE ASSUMIR OU PERGUNTAR (viés pró-pesquisa).** Sempre que houver
   dúvida sobre um dado — código, chave, tabela, número medido, base fiscal, regra de
   negócio, caminho de arquivo, endpoint, credencial, slug/cor de projeto — o Claude
   **primeiro procura a resposta nas pastas do vault** (`Grep`/`Glob` por palavra-chave;
   `Read` dirigido na nota que o `_INDEX.md` apontar), **antes** de inventar um valor OU de
   perguntar ao usuário. Ordem de busca: (a) referências `sempre-considerar`; (b) o hub e as
   notas do projeto em questão; (c) o resto do vault. Só recorra ao usuário quando a busca
   **não** resolver — e, nesse caso, diga o que já procurou. Nunca preencha uma nota com um
   dado "provável" sem checar: um número/código errado gravado no vault se propaga. Isto
   **não** contradiz a regra 2 — busca dirigida para fechar uma lacuna ≠ ler notas "por
   garantia".
10. **⚠️ TODA PASTA DE PROJETO TEM UMA nota `<slug>-dados.md` ("onde os dados vivem"),
    OBRIGATÓRIA E MANTIDA AUTOMATICAMENTE.** É onde ficam, num só lugar: repositório real
    no disco, pastas de rede/UNC (`\\10.x`, `O:\...`), onde moram as credenciais/`.env`
    (nomes de variável, nunca o segredo), tabelas/bancos usados (schema+tabela+o que
    contém), datasets/medidas de BI, arquivos Excel/CSV/JSON intermediários do pipeline
    (nome + o que contém + quem gera/consome) e endpoints de API externos. É mapa de
    **localização**, não de regra de negócio (isso continua no hub e nas notas atômicas).
    - **Gatilho automático (sem o usuário pedir):** sempre que uma sessão descobrir ou
      mudar algo que se encaixe numa dessas categorias — novo arquivo intermediário
      criado/lido, nova tabela consultada, credencial nova, pasta de rede nova, endpoint
      novo, banco de dados novo — **atualize a `<slug>-dados.md` do projeto na mesma
      sessão**, junto com o resto do Protocolo de atualização obrigatória (regra 8). Isto
      vale mesmo que a mudança pareça pequena.
    - Nome do arquivo: `projetos/<slug>/<slug>-dados.md`. Linkada do `## Estado atual` (ou
      logo no topo) do **hub** do projeto e da coluna "Onde os dados" em
      `referencias/mapa-projetos.md`.
    - **Projeto NOVO (obrigatório, não opcional):** a nota de dados nasce **junto** com a
      pasta do projeto — não é um "depois eu crio". Mesmo que comece com poucas linhas.

## Como o Claude deve montar o `_INDEX.md`

O `_INDEX.md` é o único arquivo que o Claude lê por padrão; ele precisa ser um índice
enxuto e fiel. Regras de montagem:

- **Cabeçalho fixo:** mantenha o bloco de citação do topo (explica o que é o índice e manda
  começar por `mapa-projetos` ao entrar num projeto). Não apague esse cabeçalho.
- **Seções nesta ordem:** `## Clientes`, `## Processos`, `## Projetos`, `## Referências`,
  `## Templates`. Crie a seção só quando houver ao menos uma nota nela (num vault novo,
  Processos, Referências e Templates já vêm com as notas de infra; Clientes/Projetos podem
  começar vazias com um comentário `<!-- ainda sem notas -->`).
- **Uma linha por nota:** `- [Título](caminho/relativo.md) — gancho de 1 frase`. O gancho
  sai da `description` do frontmatter; escreva-o para ajudar a decidir relevância, não como
  resumo do conteúdo inteiro.
- **Projetos são aninhados sob o hub:** a primeira linha do projeto é o **hub**; as notas
  detalhadas entram **indentadas** (2 espaços) sob ele, na ordem em que o hub as indexa.
  A nota `<slug>-dados.md` é sempre a primeira nota detalhada sob o hub.
- **Referências `sempre-considerar`** ganham um ⭐ no começo da linha, para saltarem à vista.
- **Nada de histórico datado no índice:** o "estado atual" mora no hub (regra 4). O índice
  é só gancho de 1 frase.
- **Sincronia obrigatória:** criou/renomeou/apagou uma nota → atualize a linha aqui **na
  mesma sessão**. O índice nunca pode divergir das notas que existem no disco.

## Protocolo de atualização obrigatória

Dispara SEMPRE que houver alteração num projeto ou descoberta de dado novo. Passos:

0. **Cheque o dado antes de gravar (regra 9).** Se algo estiver incerto, pesquise nas pastas
   (`Grep`/`Glob`/`Read` dirigido) e só então registre — nada de valor "provável" sem conferir.
1. **Ache a nota certa.** Assunto já tem nota → **atualize-a** e faça bump de `updated:`.
   Sub-tema novo e grande → **crie uma nota atômica** (1 assunto por arquivo).
2. **Pasta certa:** projeto → **`projetos/<slug>/`** (a pasta do projeto, nunca solto na
   raiz de `projetos/`); `referencias/` (dado transversal de consulta), `processos/`
   (rotina), `clientes/` (por cliente).
3. **Etiqueta/cor certa (grupo do graph, por PASTA e por TAG):**
   - Nota de projeto existente → coloque-a em `projetos/<slug>/` e reutilize a tag `proj/<slug>`.
   - **Projeto NOVO** → crie a pasta `projetos/<novo-slug>/`, ponha a nota lá, adicione a tag
     `proj/<novo-slug>` **E adicione os DOIS grupos de cor** em `.obsidian/graph.json` com a
     mesma cor distinta: `{"query":"path:projetos/<novo-slug>/","color":{"a":1,"rgb":<dec>}}`
     **e** `{"query":"tag:#proj/<novo-slug>","color":{"a":1,"rgb":<dec>}}`.
   - Referência → `referencia` (+ `sempre-considerar` se for dado fundamental).
4. **Conecte** com `[[...]]` para o hub do projeto e as referências usadas.
5. **Atualize o `_INDEX.md`** (linha da nota, aninhada sob o hub) e o **hub do projeto**
   (seção "Notas detalhadas").
6. **Nunca** deixe o conhecimento só no código ou na conversa.

### Cores dos grupos do graph
Cada projeto usa uma cor distinta nos DOIS grupos (`path:` e `tag:`). Este vault-base já
traz só as cores de infra (referência/processos/clientes). Ao criar o **primeiro** projeto,
escolha uma cor da paleta sugerida; a cada projeto novo, pegue a próxima cor livre.

| grupo | cor (hex / decimal) |
|---|---|
| `referencia` | #94A3B8 / 9741240 |
| `path:processos/` | #736164 / 7561572 |
| `path:clientes/` | #C1A340 / 12690240 |

Paleta sugerida para projetos novos (escolha uma cor distinta por projeto):
azul #2563EB / 2450411 · verde #16A34A / 1483594 · laranja #F97316 / 16347926 ·
vermelho #DC2626 / 14427686 · roxo #9333EA / 9647082 · ciano #06B6D4 / 440020 ·
rosa #DB2777 / 14361975 · teal #0D9488 / 890512 · índigo #4F46E5 / 5195493 ·
marrom #92400E / 9584654 · amarelo #EAB308 / 15381256 · lima #65A30D / 6660365.
Converter hex→decimal: `int("RRGGBB", 16)`.

## Convenção de frontmatter

```markdown
---
name: slug-curto-em-kebab-case
description: uma frase que resume o conteúdo (usada no índice)
tags: [categoria, subcategoria]
updated: AAAA-MM-DD
---
```

## Estrutura de pastas

- `clientes/` — informações por cliente
- `processos/` — passo a passo de rotinas internas
- `referencias/` — dados de consulta (fornecedores, links, tabelas)
- `projetos/<slug>/` — uma pasta por projeto (com a nota `<slug>-dados.md` obrigatória)
- `templates/` — modelos de nota
- `.scripts/` — automação de sincronização com o Git (não é conteúdo)
