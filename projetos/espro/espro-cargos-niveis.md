---
name: espro-cargos-niveis
description: ESPRO — cargos e setores editáveis, níveis de acesso (gerência, TI, líder, membro), portal, acervo de edições e página de fluxo por setor (2026-11-13)
tags: [projeto, proj/espro, cargos, permissoes, portal]
updated: 2026-11-13
---

# ESPRO — Cargos, níveis, portal e setores (2026-11-13)

Parte do [[espro]]. Dados técnicos em [[espro-dados]] §17. Commit `2be3015` em `Espro_frame`. Ainda **sem push**, então ainda não está no ar.

## Níveis de acesso (fixos no código)
| Nível | Pode |
|---|---|
| **Gerência** | Tudo: cargos, setores, pessoas e exclusão de contas. Inclui os antigos admin, diretor(a) e instrutor(a). O ADM (`vitortozeti@gmail.com`) é fixo. |
| **TI** | Tudo, **menos** criar, editar ou excluir cargos, trocar o cargo de alguém e mexer em contas da gerência. Cria, edita e exclui setores, define o setor das pessoas e exclui contas que não são da gerência. Vê todos os setores. |
| **Líder de setor** | Antigos gestor e co-gestor. Vê e lidera os próprios setores e publica o link público. |
| **Membro** | Vê o quadro do próprio setor. |

**Cargo** é um nome livre ligado a um nível. Os cargos ficam na lista "Cargos" (só a gerência mexe): criar, renomear, trocar o nível, a cor e a ordem, e excluir. Ao excluir um cargo, as pessoas que o têm passam para outro. O servidor recusa excluir um cargo que ainda está em uso. Os cargos ADM e Membro não podem ser excluídos.

Cargos que já vêm no sistema:
- ADM, Diretor(a) e Instrutor(a) → Gerência
- **TI** → TI (para o time de TI que fica no Marketing)
- Gestor(a) e Co-gestor(a) → Líder
- Membro → Membro

## Setores
- Tela nova "Setores" (gerência e TI):
  - Renomear direto na linha.
  - Trocar a cor.
  - Mudar a ordem com ↑↓.
  - "+ Criar" com um campo só.
- Ao excluir um setor, escolhe-se o setor de destino. Para ele vão as tarefas, as páginas da revista (seção) e as pessoas.

## Contas
Na página Equipe, a visão de administração agora vale para gerência e TI. Cada linha tem um botão 🗑 "Excluir conta", que pede para digitar o nome da pessoa. Ninguém exclui a própria conta nem a do ADM.

## Portal (aba "Portal", antiga Início)
- Saudação com cargo e setores.
- Atalhos: nova demanda, evento, página, buscar e perfil.
- Avisos.
- Minhas tarefas e próximos 7 dias.
- Cartões por setor, que levam à página do setor.
- Revista: última edição publicada, com botão Ler.
- Organograma resumido.
- O organograma completo fica em `#/organograma`, agrupado em Gerência → TI → setores (líderes e equipe).

## Página do setor (`#/setor/<id>`)
- Líderes e equipe.
- Números: tarefas abertas, atrasadas, concluídas no mês e tempo médio dos últimos 90 dias.
- Fluxo de trabalho com contagem por etapa: A fazer → Fazendo → Revisão → Pronto.
- **Pedidos de outros setores.**
- Tarefas em aberto.
- Páginas da revista da seção.

**Pedido entre setores:** com o botão "Pedir algo a este setor", qualquer pessoa cria uma demanda nova para outro setor. O cartão leva `deSetor`, que é o setor de quem pediu. Depois disso, só o setor de destino trata a demanda.

## Edições estilo acervo (PAC)
- Destaque da edição mais recente publicada, com Ler, Link/QR e Baixar.
- Grade de capas: tocar numa capa abre a leitura.
- Busca por edição ou matéria, filtro por ano e chips Publicadas / Em produção.
- O botão "Gerenciar" (gerência, TI e líder) mostra os cartões antigos de gestão e a criação de edição.

## Paleta Ctrl+K
Agora encontra também:
- pessoas;
- setores (fluxo e "pedir algo ao setor");
- organograma;
- gerenciar setores e cargos.

## Teste
- **Regras do servidor:** a API real (`functions/_lib/api.js`) rodou no navegador sobre um repositório em memória, com 25 verificações, todas ok. Exemplos:
  - TI mudando um cargo recebe 403.
  - TI mexendo em contas da gerência recebe 403.
  - Excluir um cargo em uso é recusado.
  - Trocar o nível de um cargo vale na hora.
  - Um pedido entre setores só passa se `deSetor` for o setor da própria pessoa.
- **Telas:** testadas no preview em 375px e no desktop.
- **Ainda não testado:** o D1 real. Falta fazer o push e o deploy.
