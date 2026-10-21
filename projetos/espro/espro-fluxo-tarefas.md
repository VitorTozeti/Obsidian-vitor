---
name: espro-fluxo-tarefas
description: fluxo de tarefas do quadro ESPRO — repasse, ciente, conclusão, notas e feed para substituir os grupos de WhatsApp por setor; o que foi feito e o que melhorar
tags: [projeto, proj/espro, kanban, fluxo, equipe]
updated: 2026-10-21
---

# ESPRO — Fluxo de tarefas (substituir os grupos de WhatsApp)

Hub: [[espro]] · Dados: [[espro-dados]] §15 · Backlog: [[espro-ideias-futuras]].

## Problema
Cada setor tem um grupo de WhatsApp: o repasse da tarefa, o "já vi", as dúvidas e o "terminei"
ficam soltos na conversa, sem histórico ligado ao trabalho, sem prazo e sem saber quem já viu.

## O que o quadro passou a guardar (2026-10-21)
Tudo fica **dentro do cartão** (`js/fluxo.js`, `js/views.js`):
- **Repassar** — escolhe a pessoa (lista da equipe) + setor + novo prazo + recado. Fica gravado *quem repassou, para quem, quando e o recado*. Deixar a pessoa vazia = devolve livre ao setor (alguém usa **Assumir**).
- **Ciente, vou fazer** — quem recebeu confirma que viu; a tarefa vai de "A fazer" para "Fazendo" e o cartão mostra "ciente ✓". Antes disso mostra o selo âmbar "aguardando ciente".
- **Concluir** — pede "o que foi entregue" + link (Drive/doc); grava *quem concluiu e quando*; o cartão mostra "Entregue por X". **Reabrir** volta para Fazendo com motivo.
- **Notas/dúvidas no cartão** — campo "Atividade e notas": a conversa que iria para o grupo.
- **Linha do tempo** — toda mudança (arrastar, seta, formulário, repasse, ciente, nota, conclusão) é registrada com autor e hora.
- **Feed "Atividade"** (botão no Quadro) — o que aconteceu em todos os cartões do seu setor; filtro "Minhas tarefas".
- **Avisos no Início**: tarefas repassadas esperando ciente; tarefas suas vencendo hoje/amanhã; "X foi concluída por Y" para quem repassou (72 h). Contador "N repassada(s) para você" no topo do Quadro.

## Regra de acesso (2026-10-21)
- **Todo mundo, inclusive gestor e co-gestor**, só vê/cria/repassa tarefas **do próprio setor** (ou setores). Já era imposto pelo servidor (`functions/_lib/api.js`, `AMPLOS`); o repasse agora também só oferece setores e pessoas do próprio setor.
- **Só admin, diretor(a) e instrutor(a)** veem todos os setores.
- **Cobrança formal por e-mail** (botão "Cobrar por e-mail" no cartão, só para esses 3 cargos): monta mensagem formal (tarefa, setor, situação, prazo, subtarefas pendentes, observação, assinatura com cargo), mostra prévia, abre no programa de e-mail do cobrador (`mailto:`) ou copia o texto, e registra "cobrou por e-mail" na linha do tempo. **Não envia sozinho**: envio automático pelo servidor exigiria serviço de e-mail (Resend/MailChannels) com chave de API.

## Quadro da Gestão (2026-10-21)
- Aba/alternador **"Quadro da Gestão"** no Quadro (admin, diretor(a), instrutor(a)); o gestor/co-gestor vê "Tarefas da diretoria". Cartão com `gestao:true` e `setor` = setor do gestor escolhido (o select acompanha o responsável).
- **Só admin/diretor/instrutor criam** essas tarefas e só escolhem gestores/co-gestores como responsáveis. O gestor do setor vê, dá ciente, anota, move e conclui, mas não cria, não repassa e não apaga. **Membros nem recebem** esses cartões.
- Imposto no servidor (`veCartao`/`podeGravar` em `functions/_lib/api.js`) e na limpeza local (`limparCartoesAlheios`, `js/sync.js`). Tarefas da gestão ficam fora do dashboard por setor, do rodízio e dos números da revista. Cobrança por e-mail e repasse/ciente/concluir funcionam igual. **D1 real não testado.**

## Fluxo recomendado para a equipe
1. Gestor/qualquer um cria o cartão e **repassa** com recado → nada de mensagem no grupo.
2. Quem recebe abre o Início → **Ciente** → trabalha marcando as subtarefas.
3. Dúvida → **nota no cartão** (fica registrada junto da tarefa).
4. Terminou → **Concluir** com entrega/link → quem repassou é avisado; Revisão fica para o gestor.
5. Fim da semana: **Arquivar prontos**. Reunião de quinta: usar o Feed de atividade.
6. Grupo de WhatsApp fica só para urgência/avisos gerais.

## Limites conhecidos / próximos passos
- Avisos só aparecem **com o app aberto** (ou notificação do navegador); sem push com o app fechado → precisa service worker + Worker com cron, ou e-mail.
- Notas e histórico moram no cartão (item único sincronizado, "último a editar vence"): duas pessoas anotando ao mesmo tempo no mesmo cartão podem perder uma nota. Solução futura: coleção própria `atividades` (append-only).
- "Revisão" ainda não tem aprovador/pedir ajustes no cartão (só nas páginas).
- Ideias: menção `@pessoa` nas notas, tarefas recorrentes (reunião de quinta), lembrete de cartão parado há N dias, relatório semanal por setor, botão "copiar aviso para WhatsApp" na transição.
- **Não testado com D1 real e equipe logada**: testado no preview, modo local (sem lista de equipe, nome pelo perfil). Sem commit/push.
