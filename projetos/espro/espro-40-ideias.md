---
name: espro-40-ideias
description: análise do ESPRO em 2026-10-21 — pontos de melhoria e 40 ideias de adição úteis para o cenário (empresa fictícia, setores, diretoria/instrução, revista), com prioridade, esforço e plano em ondas
tags: [projeto, proj/espro, planejamento, roadmap, ideias]
updated: 2026-10-21
---

# ESPRO — Análise e 40 ideias (2026-10-21)

Hub: [[espro]] · Dados: [[espro-dados]] · Fluxo: [[espro-fluxo-tarefas]] · Roadmap anterior: [[espro-analise-roadmap]] · Backlog antigo: [[espro-ideias-futuras]].

## Onde o projeto está
- **Pronto:** revista completa (editor, edições, prévia/flipbook, PDF, link público), quadro com fluxo (repasse, ciente, várias pessoas, concluir, notas, feed), Quadro da Gestão, cobrança por e-mail (`mailto:`), cargos e setores, Equipe, Diário, Agenda. Site em `espro-frame.pages.dev`.
- **Pontos fracos:**
  1. **Avisos só com o app aberto.** Sem push nem e-mail automático, o WhatsApp continua sendo o "sino" da equipe. Esse é o maior risco para a adoção.
  2. **Segurança de conta:** cadastro aberto, e-mail sem verificação, sem limite de tentativas e sem "esqueci a senha".
  3. **Dados:** "último a editar vence" sobre o cartão inteiro, então notas simultâneas podem se perder. Mídia no D1, sem backup automático. D1 real pouco testado.
  4. **Código:** sem testes nem CI; `editor.js` e `views.js` grandes. Bug `window.Sync` ainda em `js/editor.js:634` (presença).
  5. **Produto:** quadro e agenda não são por edição; a vitrine da empresa (pilar 1) não existe; a diretoria não tem números de desempenho.

## As 40 ideias
Legenda: **valor** (A alto, M médio, B baixo) · **esforço** (P até 1 dia, M 2–4 dias, G 1 semana ou mais).

### A. Comunicação: tirar a equipe do WhatsApp
| # | Ideia | Por que ajuda no cenário | Valor | Esforço |
|---|---|---|---|---|
| 1 | **Notificação push com app fechado** (service worker + Web Push + Worker com cron) | Repasse, cobrança e prazo chegam no celular como no WhatsApp | A | G |
| 2 | **E-mail automático** (Resend/MailChannels) para repasse, cobrança formal e prazo | A cobrança da diretoria sai sozinha e fica registrada | A | M |
| 3 | **Mural de comunicados por setor** com "li e estou ciente" | Substitui o uso de "aviso geral" dos grupos, com prova de leitura | A | M |
| 4 | **Menções @pessoa** nas notas do cartão, com aviso | Quem é marcado é avisado, sem precisar mandar mensagem | A | P |
| 5 | **Resumo diário/semanal** ("suas 3 tarefas de hoje", "o setor fechou 12 esta semana") | Rotina de acompanhamento sem cobrança manual | A | M |
| 6 | **Prazo de ciente**: 24 h sem ciente avisa o gestor | Ninguém "não viu a mensagem" | A | P |
| 7 | **Cartão parado** há N dias em Fazendo/Revisão gera alerta | Mostra gargalos antes do atraso | M | P |
| 8 | **Pedido entre setores** ("Solicitar ao Marketing") que o gestor do outro setor aceita | Hoje a regra de setor bloqueia a colaboração; o pedido cria o canal formal | A | M |

### B. Tarefas e fluxo
| # | Ideia | Por que ajuda | Valor | Esforço |
|---|---|---|---|---|
| 9 | **Revisão com aprovador**: gestor aprova ou pede ajustes antes de Pronto | Fecha o ciclo de qualidade da matéria | A | M |
| 10 | **Modelos de tarefa** com checklist pronto (Matéria, Ensaio de fotos, Anúncio) | Padroniza e acelera; ensina o processo aos aprendizes | A | P |
| 11 | **Tarefas recorrentes** (reunião de pauta, diário de quinta) | Não precisa recriar toda semana | M | P |
| 12 | **Dependências** ("bloqueada por: fotos") | Mostra quem trava quem | M | M |
| 13 | **"Minha semana"**: as minhas tarefas por dia, inclusive as de várias pessoas | Visão pessoal simples para o aprendiz | A | P |
| 14 | **Visão em lista/tabela** com busca, ordenação e filtros salvos | A diretoria acha tarefas rápido entre setores | M | M |
| 15 | **Anexos no cartão** (fotos e arquivos no R2) | O material sai do Drive solto e do grupo | A | M |
| 16 | **Notas em coleção própria** (só acréscimo) | Acaba com a perda de nota quando duas pessoas escrevem ao mesmo tempo | M | M |

### C. Diretoria e instrução (o lado "empresa-escola")
| # | Ideia | Por que ajuda | Valor | Esforço |
|---|---|---|---|---|
| 17 | **Painel da diretoria**: entrega no prazo, atrasos, tempo até o ciente e até a conclusão, por setor e pessoa | Dá números para cobrar e para elogiar | A | M |
| 18 | **Avaliação de competências** pelo instrutor (pontualidade, comunicação, qualidade), com histórico | É o que a ESPRO avalia nos aprendizes | A | M |
| 19 | **Frequência** em reuniões e no diário | Controle de presença sem planilha | M | P |
| 20 | **Ata de reunião** ligada ao evento da Agenda, em que cada decisão vira tarefa | A reunião vira tarefa com responsável | A | M |
| 21 | **Metas por setor e por edição** ("Geek: 6 páginas até dia 10") | Alinha o setor ao fechamento | M | P |
| 22 | **Destaque da semana** (reconhecimento leve, sem ranking punitivo) | Motivação para a turma jovem | M | P |
| 23 | **Log de auditoria** (quem mudou cargo/setor, apagou ou publicou) | Transparência e segurança da administração | M | P |
| 24 | **Relatório de fechamento em PDF**: o que cada setor entregou, prazos, participação | Material pronto para entregar à ESPRO | A | M |

### D. Revista e conteúdo
| # | Ideia | Por que ajuda | Valor | Esforço |
|---|---|---|---|---|
| 25 | **Quadro e agenda por edição** (filtro da edição ativa) | As edições não se misturam | A | M |
| 26 | **Banco de pautas** com votação; a pauta aprovada vira tarefa e página | Organiza a criatividade dos setores | A | M |
| 27 | **Vitrine pública da empresa fictícia** (missão, setores, equipe, edições) | Pilar 1 do projeto, que ainda falta | A | M |
| 28 | **Comentário fixado num ponto da página** | Revisão visual mais clara | M | M |
| 29 | **Guia de estilo e checagem**: crédito obrigatório de foto, tamanho do título, ortografia | Qualidade editorial e direito de imagem | M | M |
| 30 | **Assistente de IA**: sugerir título, legenda, resumo e revisar o texto | Ajuda quem está aprendendo a escrever | M | M |
| 31 | **Estatísticas do link público** (visualizações por edição e página) | Mostra o alcance na apresentação | B | P |
| 32 | **Arquivo/hemeroteca**: busca em todas as edições publicadas | Memória da empresa | B | M |

### E. Pessoas e entrada
| # | Ideia | Por que ajuda | Valor | Esforço |
|---|---|---|---|---|
| 33 | **Convite por link/e-mail** já com setor e cargo; acaba o cadastro aberto | Segurança e menos trabalho do admin | A | M |
| 34 | **Perfil e organograma** (foto, função, setores, quem lidera quem) | Todos sabem a quem recorrer | M | P |
| 35 | **Tour inicial por cargo** (membro, gestor, diretoria) | A turma aprende o app sozinha | M | P |
| 36 | **Wiki do setor**: processos, manual de estilo, contatos | O conhecimento não se perde na troca de turma | M | M |

### F. Base técnica
| # | Ideia | Por que ajuda | Valor | Esforço |
|---|---|---|---|---|
| 37 | **PWA offline** (service worker, fila de envio, "instalar no celular") | Funciona com sinal ruim; é pré-requisito do push (#1) | A | M |
| 38 | **Conta segura**: limite de tentativas, verificação de e-mail, "esqueci a senha" | Hoje qualquer um cria conta | A | M |
| 39 | **Mídia no R2 + backup diário do D1** | Evita estouro do D1 e perda de dados | A | M |
| 40 | **Testes da API + teste ponta a ponta no D1 + CI no GitHub**; corrigir `editor.js:634` | Cada push para a `main` vai ao ar, então precisa de rede de proteção | A | M |

## Plano em ondas
**Onda 1: estabilizar e dar segurança (1–2 semanas).**
#40 (teste real no D1 com 2 contas, testes da API, CI, bug da presença), #38, #33, #39 (backup), #23.
*Pronto quando:* diretora, gestor e membro testados no site real; ninguém entra sem convite.

**Onda 2: o sino (2 semanas). Este é o passo que tira o WhatsApp.**
#37 PWA, depois #1 push, #2 e-mail automático, #6 prazo de ciente, #4 menções, #5 resumo, #3 mural de comunicados.
*Pronto quando:* um repasse chega no celular com o app fechado; os grupos ficam só para urgência.

**Onda 3: fluxo maduro (1–2 semanas).**
#9 aprovação, #10 modelos, #13 Minha semana, #8 pedido entre setores, #11 recorrentes, #7 cartão parado, #15 anexos, #16 notas em coleção.

**Onda 4: diretoria e instrução (2 semanas).**
#17 painel, #18 avaliação de competências, #20 atas, #19 frequência, #21 metas, #22 destaque, #24 relatório de fechamento.

**Onda 5: revista e vitrine (2 semanas, antes da apresentação à ESPRO).**
#25 quadro por edição, #26 banco de pautas, #27 vitrine pública, #29 guia de estilo, #28 comentário na página, #30 IA, #31 estatísticas.

**Depois:** #12 dependências, #14 visão em tabela, #32 arquivo, #34 organograma, #35 tour, #36 wiki.

## Os 10 primeiros, se o tempo for curto
#40 → #38 → #33 → #37 → #1 → #2 → #6 → #9 → #10 → #17.

## Dependências técnicas
- Push (#1) precisa de PWA (#37) e de um Worker com cron. E-mail (#2) precisa de chave de API (variável no Pages, nunca no código).
- Anexos (#15) e backup (#39) usam R2. Notas em coleção (#16) mudam o `sync` (novo `kind`).
- Painel (#17) e relatório (#24) usam o `historico` dos cartões, que já existe: tempo até o ciente e até a conclusão saem dele.
