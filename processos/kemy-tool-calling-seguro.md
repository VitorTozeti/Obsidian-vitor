---
name: kemy-tool-calling-seguro
description: passo a passo correto que a K.E.M.Y deve seguir ao executar tool-calls (validar args, nunca deixar tool_call sem resposta, isolar erro de execução do erro de provider) — nasceu do incidente 2026-09-23 (write_file com args vazios + 400 da Novita)
tags: [processo, proj/kemy-ai, tool-calling, robustez, openrouter]
updated: 2026-09-23
---

# Tool-calling seguro na K.E.M.Y — processo correto

Nasceu do incidente de 2026-09-23: o modelo gratuito `inclusionai/ling-3.0-flash-fin:free`
mandou uma chamada de `write_file` com argumentos vazios (`{}`), o Python quebrou com
`TypeError: missing 2 required positional arguments`, e a próxima requisição à API voltou
com `400 invalid request error` do provider **Novita**. Ver análise completa em
[[KEMY_AI-dados]] (seção "Motor de inferência") e no histórico da sessão que criou esta
nota. Este processo descreve como isso **deveria** ter sido tratado.

## Diagnóstico da causa raiz

Dois sintomas, uma origem:
1. Modelo `:free` gerou `tool_calls` com argumentos malformados/vazios — comportamento
   conhecido de modelos gratuitos/menores em function-calling (menos confiáveis que
   modelos pagos maiores).
2. O código despachou a ferramenta **sem validar** os argumentos primeiro → `TypeError`
   não tratado → o turno ficou com um `tool_call` **sem resposta** (`role: tool`)
   correspondente no histórico `messages`.
3. Esse histórico inconsistente foi reenviado na chamada seguinte → a API (via Novita)
   rejeitou com `400`, porque o schema exige uma mensagem `tool` por `tool_call_id`
   pendente.

## Passos corretos (o que a K.E.M.Y deve fazer)

### 1. Validar os argumentos ANTES de despachar a ferramenta
Para cada `tool_call` recebido da API:
- Faça `json.loads` do `arguments` com try/except — se falhar o parse, trate como erro
  de execução (passo 3), nunca deixe a exceção subir.
- Confira que todas as chaves obrigatórias da ferramenta (ex.: `write_file` precisa de
  `path` e `content`) estão presentes e com o tipo esperado.
- Se faltar algo, **não** chame a função Python direto — vá para o passo 3 (erro
  controlado), pedindo ao modelo para corrigir.

### 2. Nunca deixar uma exceção de execução propagar sem resposta
Envolva a chamada real da ferramenta (`tool_write_file(**args)` etc.) em
`try/except Exception`. Qualquer erro — de validação, de I/O, de permissão — vira
**conteúdo** da mensagem de resposta, nunca um crash do processo.

### 3. Sempre responder o `tool_call_id`, mesmo em erro
A API exige uma mensagem `{"role": "tool", "tool_call_id": ..., "content": ...}` para
**cada** `tool_call` que veio na resposta do assistente — sucesso ou falha. Em erro,
o `content` deve ser uma descrição curta e clara do problema (ex.:
`"Erro: argumento 'path' ausente na chamada de write_file"`), para que o próprio
modelo veja o erro e tente de novo com os argumentos certos no próximo turno. Isso
mantém o histórico `messages` sempre consistente antes de qualquer nova chamada à API.

### 4. Separar erro de execução (nosso) de erro de provider (deles)
- **Erro de execução** (passo 2/3): tratado localmente, vira mensagem `tool`, o loop
  de turno continua normalmente.
- **Erro de provider** (400/402/429 do OpenRouter/Novita): esse já tem tratamento —
  `_looks_exhausted()` + `call_kemy_with_fallback()` trocam de modelo na fila (ver
  [[KEMY_AI-dados]]). Mas hoje `_looks_exhausted()` só cobre esgotamento
  (402/429/"insufficient credit"/"rate limit"). Um **400 genérico** ("invalid request
  error") não é esgotamento — é sinal de que o **histórico enviado** está malformado.
  Não adianta trocar de modelo; o fix é impedir que o histórico fique malformado
  (passos 1–3). Se mesmo assim acontecer, log detalhado do payload enviado ajuda a
  depurar (nunca reenviar cego o mesmo payload que já deu 400).

### 5. Degradar graciosamente para modelos gratuitos pouco confiáveis
Se um modelo `:free` errar a formatação de tool-call **repetidamente** na mesma sessão,
considere:
- Avisar o usuário no terminal (mensagem curta, sem interromper o fluxo).
- Pular esse modelo na fila de rotação para chamadas que envolvam ferramentas de
  escrita (`write_file`, `edit_docx`, `edit_excel`, `run_command`), preferindo um
  modelo pago mais confiável só nesses casos — mantendo o `:free` para conversas sem
  ferramentas.

## Checklist rápido (aplicar em `kemy.py` / `run_turn`)
- [ ] Parse seguro de `arguments` (try/except).
- [ ] Validação de chaves obrigatórias por ferramenta antes de despachar.
- [ ] `try/except` ao redor da chamada real da função Python.
- [ ] Toda `tool_call_id` recebe uma mensagem `tool` de resposta, mesmo em erro.
- [ ] `_looks_exhausted()` continua só para esgotamento; 400 genérico vira log +
      mensagem de erro no histórico, não troca de modelo.
- [ ] (Opcional) contagem de tool-calls malformadas por modelo na sessão, para decidir
      quando evitar aquele modelo em chamadas de ferramenta.

## Relacionado
- [[KEMY_AI-dados]] — arquitetura, rodízio de modelo, motor de inferência
- [[KEMY_AI]] — hub do projeto
- [[manutencao-vault]] — protocolo geral de registro no vault
