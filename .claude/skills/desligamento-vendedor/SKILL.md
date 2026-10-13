---
name: desligamento-vendedor
description: >-
  Desligamento de vendedor/consultor/gerente comercial da Pharmaesthetics: lançar a ausência no
  Salesforce até o fim do mês, desativar o User, apurar a comissão rescisória, abrir o cartão de
  saída no Planner "Movimentação Comercial" com o passo do Tableau para o Arthur e deixar a
  carteira esperando o substituto. Use quando o usuário avisar que alguém saiu, foi desligado ou
  pediu demissão, ou pedir para "desligar fulano", "desativar no Salesforce" ou "lançar a
  ausência do desligado".
---

# Desligamento de vendedor (ponteiro)

A skill de verdade mora no repositório do relatório comercial, junto com o código que ela
roda. **Leia e siga** este arquivo:

`C:\Users\m.milani\OneDrive - Pharmaesthetics do Brasil\Documents\Marcelo\Relatórios Comercial\.agents\skills\desligamento-vendedor\SKILL.md`

Está na `main` e na `dev` desde 24/09 (PR #19 e promoção no PR #21). A pasta `Relatórios
Comercial` (branch `dev`, com o `.env`) já tem o código e uma cópia local da skill em
`.claude/skills/`. Rode os scripts **de lá**.

Resumo, para não errar a ordem:
1. Confirmar a pessoa (código SAP) e a data de saída.
2. `desligar_vendedor.py --cod N --saida AAAA-MM-DD`: mostrar o plano e **gravar em produção
   só com o OK do usuário** (`--executar --confirmar N`).
   - Depois: `base_carteira_desligado.py --cod N` (base da carteira + aba Leads, só leitura).
   - E-mail aos gerentes: `email_carteira_desligado.py --cod N` = **prévia**. Mostre na conversa,
     pergunte **"Posso enviar?"** e só rode `--enviar` depois do sim. Nunca envie sozinho.
3. Comissão rescisória: skill `comissao-desligado`.
4. Planner, da raiz deste vault: `python .scripts/movimentacao/movimentacao_planner.py
   sincronizar --apenas N --yes`. O passo do Tableau vai para o Arthur.
5. Carteira fica pendente até o gerente pedir (skill `transferir-clientes-salesforce`).
   - **Nunca "Desativar usuário parceiro" no Contato**, só desativar o User. O primeiro é
     irreversível e faz qualquer correção criar um User com ID novo (R23).
6. Relatório comercial: nada a fazer.

Regras e contexto no vault: [[movimentacao-comercial-regras]] (R12 a R16),
[[movimentacao-equipe-comercial]] (runbook, seção Saída), [[movimentacao-comercial-quadro-planner]].
