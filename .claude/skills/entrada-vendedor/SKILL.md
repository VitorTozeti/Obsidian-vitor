---
name: entrada-vendedor
description: >-
  Entrada de vendedor/consultor/gerente comercial novo na Pharmaesthetics: criar Contato e User
  parceiro no Salesforce (a partir da OSLP do SAP, copiando de um colega da mesma equipe), lançar o
  Treinamento de entrada (início do mês até a entrada + entrada até entrada + 7 dias), atualizar o
  cartão no Planner "Movimentação Comercial" e transferir a carteira quando o gerente mandar a lista.
  Use quando o usuário avisar que chegaram licenças ou pessoas novas, pedir para "criar o usuário
  no Sales/Salesforce" de alguém, "cadastrar vendedor", "lançar o treinamento do novato" ou "fazer o
  fluxo de entrada".
---

# Entrada de vendedor (fluxo completo)

Contexto, regras e porquês: [[movimentacao-equipe-comercial]] (seção 2), [[cadastrar-vendedor-salesforce]]
e [[movimentacao-comercial-regras]]. Os scripts moram em `.scripts/movimentacao/` deste vault e usam o
`salesforce_utils.py` + `.env` do repo `Relatórios Comercial` (rodar da rede do escritório, por causa do SAP).
Ordem importa; **grave em produção só depois de mostrar o plano** (todos os scripts simulam por padrão).

## 0. Antes de tudo
- A pessoa precisa estar na `OSLP` do SAP **com e-mail** (se faltar, o Renan Arantes preenche a pedido do Arthur).
- Tenha o **código SAP** e a **data de entrada** (aviso do RH). Se a pessoa ainda não existe no Salesforce e
  não tem cartão, abra com `movimentacao_planner.py abrir --tipo entrada --nome "..." --data AAAA-MM-DD --yes`.
- Licença `Partner Community` livre? (o script confere). Sem vaga, `LICENSE_LIMIT_EXCEEDED`: ver [[desativar-usuario-salesforce]].

## 1. Criar o User no Salesforce
```
python .scripts/movimentacao/criar_usuario_entrada.py --cod <SAP> --molde <SAP de um colega ATIVO da mesma equipe>
python .scripts/movimentacao/criar_usuario_entrada.py --cod <SAP> --molde <SAP> --executar
```
- O **molde** dá Perfil, Papel, Gerente Regional, Diretor e conta-Equipe. Escolha colega **da mesma equipe**
  (Inside Sales usa o perfil `Vendedores Partner - Inside Sales`; MG e COT usam `Vendedores Partner`). Na dúvida,
  pergunte qual colega copiar; o "Substitui quem" do aviso do RH costuma apontar a equipe.
- Nome e e-mail vêm da OSLP; o script cria o Contato, o User, dispara o reset de senha oficial e **nunca imprime a resposta**.
- Para vários, rode um por vez. Se parar com "já existe", não duplica.

## 2. Lançar o Treinamento de entrada — SEMPRE (regra do Marcelo, 13/10/2026)
Dois blocos, tipo de evento **Treinamento**, no nome do novato:
1. **do início do mês até o dia anterior à entrada** (omitido se a entrada é no dia 1);
2. **da data de entrada até a data de entrada + 7 dias**.

Ex.: entrada 05/10 → 01/10 a 04/10 e 05/10 a 12/10. Sem isso o novato recebe a capacidade de visitas do mês
inteiro e o multiplicador cai (casos Pamella e Bruna Prado em set/26).
```
python .scripts/movimentacao/treinamento_entrada.py --cod <SAP[,SAP...]> --entrada AAAA-MM-DD
python .scripts/movimentacao/treinamento_entrada.py --cod <SAP[,SAP...]> --entrada AAAA-MM-DD --executar
```
- Roda **logo depois** de criar o User (o User precisa estar ativo). Idempotente: pula bloco que já tem Treinamento.
- Mesmo formato dos lançamentos à mão: assunto "Treinamento", 08:00 do 1º dia às 18:00 do último; blocos de até 14 dias.
- Se a entrada for no fim do mês, o bloco 2 passa para o mês seguinte (o treinamento é real); avise o usuário.

## 3. Planner
`python .scripts/movimentacao/movimentacao_planner.py sincronizar --apenas <SAP[,SAP...]>` (prévia) e, conferida, `--yes`.
Sempre com `--apenas`: sem ele o `sincronizar` recria cartões já concluídos. Marca SAP/Salesforce/meta, tira o Arthur de
responsável quando o Tableau fecha e move o cartão. Itens `planilha` e `tableau` são à mão (`--marcar COD:planilha`).

## 4. Carteira (só quando o gerente mandar a lista)
Skill `transferir-clientes-salesforce` (repo `Relatórios Comercial`): planilha com `Cod Cliente` + `Nome do Vendedor`,
`--dry-run`, **backup do dono atual**, depois `--lote 10 --pausa 30`; conferir `OCRD.SlpCode` no HANA. Lista com linhas
repetidas: tirar duplicatas pelo código. Sem pedido do gerente, não transfira: o cartão fica esperando.

## 5. Fechar
Registrar no vault (`## Estado atual` do hub [[movimentacao-comercial]], diário do dia, nota do processo) e subir direto na `main`.
Metas, planilha individual e Tableau seguem o runbook ([[movimentacao-equipe-comercial]]): não são desta skill.
