# KEMY_AI

Chat de terminal em Python que conversa com voce livremente (mantendo o contexto
de toda a conversa, como no Claude Code). A assistente se chama **K.E.M.Y** —
*Kernel Engine for Modular Yield* — e responde **sempre** com essa identidade.

Por baixo, a K.E.M.Y usa o modelo **Grok (xAI) via OpenRouter** como motor de
inferencia, mas ela **nunca se apresenta como "Grok"**: para o usuario, quem
conversa e sempre a K.E.M.Y. Quando precisar, a K.E.M.Y pode usar ferramentas para
ler/escrever arquivos, listar pastas e rodar comandos de shell dentro do projeto
atual — mas voce tambem pode simplesmente bater papo, tirar duvidas de codigo, etc.

## O que significa K.E.M.Y

**K.E.M.Y = Kernel Engine for Modular Yield** — um nome com cara de desenvolvimento:

- **K**ernel — o nucleo do agente, o "cerebro" que mantem a conversa e decide o que fazer.
- **E**ngine — o motor que orquestra as chamadas de modelo e as ferramentas.
- **M**odular — arquitetura de ferramentas plugaveis (`read_file`, `write_file`,
  `list_dir`, `run_command`), faceis de estender.
- **Y**ield — *entregar / produzir* codigo e resultados (e um aceno ao `yield` da
  programacao, o que "rende" de cada turno).

Leitura curta: *"o motor-nucleo modular que entrega codigo"*.

## ⚠️ Chave da API hardcoded no codigo

A pedido de quem criou este projeto, a chave da API do OpenRouter esta **escrita
direto em `kemy.py`** (constante `_HARDCODED_API_KEY`), pra rodar sem precisar
configurar nada. Isso e conveniente mas **inseguro para qualquer coisa alem de uso
pessoal e local**:

- **Nunca** suba este arquivo (com a chave dentro) pra um repositorio Git, nem
  publico nem privado da empresa — mesmo privado, quem tiver acesso ao repo
  ganha a chave.
- **Nunca** compartilhe este `.py` por e-mail, chat ou pasta compartilhada com a
  chave dentro.
- Se isso rodar em qualquer lugar alem da sua maquina local, troque para variavel
  de ambiente: defina `KEMY_API_KEY` no sistema (ela tem prioridade sobre o valor
  hardcoded) e apague/zere `_HARDCODED_API_KEY` no codigo.
- Se a chave vazar, revogue e gere outra em https://openrouter.ai/settings/keys.

## Como usar no VS Code

1. Abra a pasta `KEMY_AI` no VS Code.
2. Abra um terminal integrado e instale a unica dependencia:

   ```bash
   pip install -r requirements.txt
   ```

3. Rode o chat a partir da pasta do projeto que quiser editar (ou desta mesma pasta) —
   ja funciona direto, a chave ja esta no codigo:

   ```bash
   python kemy.py
   ```

4. Converse normalmente:

   ```
   voce> oi, quem e voce?
   K.E.M.Y> Sou a K.E.M.Y, sua assistente de engenharia de software no terminal...
   voce> lista os arquivos dessa pasta
   voce> cria um arquivo hello.txt com um poema curto
   ```

Digite `sair` (ou Ctrl+C) para encerrar.

## Como funciona

- `kemy.py` mantem a lista completa de mensagens da conversa (`messages`) e
  envia tudo a cada pergunta, exatamente como um chat normal — por isso ela lembra
  do que voce falou antes.
- A identidade K.E.M.Y e fixada no `SYSTEM_PROMPT`: ela deve se apresentar e se
  referir a si mesma **sempre** como K.E.M.Y, nunca como "Grok"/"xAI".
- Quando a K.E.M.Y decide que precisa de uma ferramenta, o script mostra no terminal
  qual ferramenta foi chamada e o resultado, antes de continuar a resposta.
- Ferramentas: `read_file`, `write_file`, `list_dir`, `find_files`, `search_text`,
  `run_command`.

## Busca livre pelas pastas (grande liberdade de acesso)

A K.E.M.Y tem **liberdade ampla para procurar à vontade** em qualquer pasta que o seu
usuário do Windows tenha permissão — não só a pasta atual:

- **`find_files`** — acha arquivos por **nome** (glob, ex. `*.py`, `config*`) de forma
  **recursiva** a partir de qualquer caminho (relativo ou absoluto).
- **`search_text`** — busca um **texto dentro dos arquivos** (estilo `grep`), recursivo,
  com `file_glob` opcional para limitar quais arquivos varrer. Retorna `arquivo:linha: trecho`.

Ambas pulam pastas de ruído (`.git`, `node_modules`, `__pycache__`, `.venv`, `dist`,
`build`, pastas ocultas, etc.) e têm limites configuráveis por variável de ambiente:

- `KEMY_SEARCH_MAX_RESULTS` — teto de resultados (padrão `200`).
- `KEMY_SEARCH_MAX_DEPTH` — profundidade máxima de subpastas (padrão `8`).

Exemplos de conversa:

```
voce> procura todo arquivo .env no meu Desktop
voce> onde no projeto aparece a palavra "API_KEY"?
voce> acha os README.md em C:\Users\v.tozeti\Desktop
```

## ⚠️ Sem trava de pasta (a pedido do usuario)

`read_file`/`write_file`/`list_dir`/`find_files`/`search_text` aceitam **qualquer
caminho** (relativo ou absoluto), inclusive fora da pasta onde o script foi iniciado —
a checagem que bloqueava isso foi removida de proposito, e as ferramentas de busca
recursiva (`find_files`/`search_text`) ampliam ainda mais esse alcance: a K.E.M.Y pode
**vasculhar, ler ou sobrescrever qualquer arquivo do seu usuario no Windows** que o
processo tenha permissao de acessar (documentos, outros projetos, etc.), nao so a pasta
atual — inclusive achar arquivos sensiveis (`.env`, chaves) varrendo o disco.
Some a isso o `run_command`, que ja roda comandos de shell reais sem pedir
confirmacao — juntos, um pedido mal interpretado (ou um prompt malicioso escondido
num arquivo que a K.E.M.Y leia) pode ler dados sensiveis ou apagar/sobrescrever coisa
importante fora deste projeto. Use com cuidado: revise o que ela propoe antes de
aceitar em qualquer cenario sensivel, e evite deixar esse script "solto" fazendo
tarefas automaticas sem voce acompanhar.

## Configuracao

- `_HARDCODED_API_KEY` (em `kemy.py`) ou variavel de ambiente `KEMY_API_KEY`
  (tem prioridade) — chave do OpenRouter (https://openrouter.ai/settings/keys).
  Tambem aceita `OPENROUTER_API_KEY` (padrao da doc do OpenRouter) e a antiga
  `GROK_API_KEY` como fallback.
- `KEMY_MODEL` — opcional, **padrao `inclusionai/ling-3.0-flash-fin:free` (GRATUITO**
  no OpenRouter, escolhido para **evitar gastos**). Da para trocar por qualquer modelo
  do OpenRouter (ex. `x-ai/grok-4.3`, pago). Lista: https://openrouter.ai/models.
  (Fallback: `GROK_MODEL`.)
- `KEMY_MAX_TOKENS` — opcional, padrao `1024`. O plano gratis do OpenRouter tem
  saldo limitado; se pedir `max_tokens` alto demais para o saldo, a API responde
  erro 402 (credito insuficiente). (Fallback: `GROK_MAX_TOKENS`.)
