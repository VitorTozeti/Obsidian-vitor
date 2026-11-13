---
name: espro-cargos-niveis
description: ESPRO — cargos e setores editáveis, níveis de acesso (gerência, TI, líder, membro), portal, acervo de edições e página de fluxo por setor (2026-11-13)
tags: [projeto, proj/espro, cargos, permissoes, portal]
updated: 2026-11-13
---

# ESPRO — Cargos, níveis, portal e setores (2026-11-13)

Parte do [[espro]]. Dados técnicos em [[espro-dados]] §17. Commit `2be3015`: publicado (push e deploy em 2026-11-13). Rodada 2: commit `0b94ee8`, ainda sem push (veja o fim desta nota).

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

## Rodada 2 (2026-11-13): 3 tags, hierarquia, PDF e diário
- **3 tags por pessoa** (`tagsPessoa` em `js/cargos.js`):
  - ★ Gerência, se a pessoa tiver.
  - Cargo, que agora é só o nome da função.
  - Setores, mostrando o papel em cada um: Gestora ou Co-gestora.
- **Gerência** virou uma marcação separada do cargo:
  - Coluna `usuarios.gerencia` (0/1). Muda com `PUT /api/equipe {gerencia}`.
  - Só a gerência dá ou tira a marcação. O ADM tem sempre.
  - Os cargos antigos diretor e instrutor, com nível `gerencia`, continuam valendo por compatibilidade.
- **Gestora e co-gestoras são papéis no setor**: ficam gravados no próprio setor (`gestora` = e-mail, `cogestoras` = lista). A mesma pessoa pode ser gestora num setor e colaboradora em outro.
- **Nível efetivo calculado pelo servidor** (`nivelConta`), nesta ordem:
  1. Tag Gerência ou ADM → gerência.
  2. Cargo com nível TI → TI.
  3. Gestora ou co-gestora em algum setor (ou cargo antigo gestor/co-gestor) → líder.
  4. Qualquer outro caso → colaborador.
- **Ferramentas de administração** (página Equipe):
  - **Cargos** (gerência). Na criação de cargo, o nível agora só oferece Colaborador(a) ou TI.
  - **Gerência** (gerência): chaves liga/desliga por pessoa.
  - **Setores** (gerência e TI): escolher a gestora e as co-gestoras de cada setor.
  - **Organograma**.
- **Organograma em hierarquia**: Gerência → TI → em cada setor, Gestora → Co-gestora(s) → Colaboradores, ligados por traços (CSS `.arvore`/`.arv-*`).
- **Portal**: a área de ferramentas tem, por enquanto, **Quadro** e **Edições da revista**.
- **Edições = coletânea de PDFs**:
  - Botão "Lançar PDF": número, nome, data e arquivo.
  - Por edição: "Trocar PDF / editar".
  - Todos os logados leem e baixam.
  - Edição **publicada** (e suas páginas): só gestão (líder, TI, gerência) mexe. O servidor confere.
  - Armazenamento: **Cloudflare R2**, binding `ARQUIVOS`, bucket `espro-arquivos` (em `wrangler.toml`).
  - Rotas: `PUT /api/pdf/<edId>` (só gestão, até 95 MB, confere a assinatura `%PDF-`), `GET /api/pdf/pdf/<arquivo>.pdf` (logados) e `DELETE` (só gestão).
  - A edição guarda `pdf {chave, nome, tamanho, em, por}`.
- **Diário**: a fila continua em ordem alfabética, mas trocar a pessoa de uma quinta vira uma **âncora**. A partir dali, a fila segue de quem foi escolhido. Exemplo: troquei para a Dani → a semana seguinte é a próxima pessoa depois da Dani. Código: `ancoraAte` / `responsavelDa` em `js/diario.js`.
- **Testes**:
  - API real no navegador, com repositório e R2 em memória: papéis no setor dão nível líder; o TI recebe 403 ao mexer na tag Gerência; arquivo que não é PDF é recusado; colaborador não mexe em edição publicada nem nas páginas dela.
  - Telas no preview (375px) e regra do diário: todas ok.
- **Pendente — antes do push:** criar o bucket R2 `espro-arquivos` na conta Cloudflare. Sem ele, o deploy do Pages falha, porque o binding está no `wrangler.toml`.

## Rodada 3 (2026-11-13): portal em cartões, organograma em árvore, sem gerador de revista
- **Portal** no estilo do "Portal da Logística": saudação, avisos e cartões (ícone, título, descrição, "Abrir →") em três grupos:
  - **Ferramentas**: Quadro, Edições da revista.
  - **Equipe**: Organograma, Diário de bordo, Agenda, Meu perfil.
  - **Administração** (gerência/TI): Usuários e permissões, Setores, Cargos, Gerência.
- **Organograma em árvore** (`js/organograma.js`, CSS `.arv2` e `.o2-*`), no estilo diagrama (raiz em círculo, pílulas com arco colorido e etiqueta do nível, colaboradores em círculos):
  - **Completo**: Gerência → TI e setores → Gestora → Co-gestora(s) → equipe (mini avatares; tocar abre o setor).
  - **Por setor**: Gestora → Co-gestora(s) → colaboradores.
  - Chips para trocar de setor, zoom (−/+, "Ajustar à tela") e imprimir.
- **Revista**: saíram a aba Revista e o editor de páginas (`#/revista` e `#/editor/*` redirecionam para Edições). Os arquivos `editor.js` e `qualidade.js` continuam no repositório, mas fora de uso.
- **Edições** agora é só a coletânea de PDFs:
  - Gestores: lançar, trocar, mudar a situação e excluir (excluir também apaga o PDF do R2).
  - Os demais: só leem e baixam.
  - Edições sem PDF só aparecem para gestores.
- **Commit** `c133e7c`: ainda **sem push**.
- **Atenção:** o deploy da rodada 2 (`0b94ee8`) **falhou**. O site ainda está na rodada 1, porque o bucket R2 `espro-arquivos` não existe na conta Cloudflare.

## PDF sem R2 (2026-11-13)
- O R2 exige aceitar uma assinatura com cartão (mesmo no plano grátis). O usuário preferiu uma solução sem cartão.
- **Solução:** o PDF fica **em pedaços de 1,5 MB no D1**, na tabela `pdf_partes(chave, n, dados BLOB)`. Métodos em `functions/_lib/d1.js`: `putPdf` (em lote), `getPdf` e `delPdf`. Limite: **25 MB por PDF** (o plano grátis do D1 tem 5 GB).
- Se um dia houver o binding R2 `ARQUIVOS`, a API passa a usá-lo e o limite sobe para 95 MB. O `ping` informa `recursos.pdfMaxMB`.
- **Deploy:**
  - O deploy de `c133e7c` falhou ("R2 bucket 'espro-arquivos' not found").
  - `2aef9d8` (R2 desligado no `wrangler.toml`) **publicou**: portal em cartões, organograma em árvore, tags e diário estão no ar.
  - `6395c5d` (PDF no D1) está commitado; o push foi bloqueado pela permissão automática. Falta o usuário autorizar ou rodar o push.
- **Ainda não testado:** o binding de BLOB no D1 real. O teste foi feito em memória: um PDF de 4,2 MB voltou idêntico, um de 26 MB foi recusado e a exclusão funcionou.

## Rodada 4 (2026-11-13): vários cargos e tela única de pessoa
- **Uma pessoa pode ter vários cargos** (ex.: ADM + TI) e vários setores (ex.: Geek + Marketing). O acesso é o do cargo mais alto. Dados em [[espro-dados]] §19.
- **UX nova:** na página Equipe, cada pessoa tem o botão **"Editar cargos e setores"**, que abre uma tela única com:
  - chave **★ Gerência** (só a gerência vê);
  - **chips liga/desliga** para os cargos (só a gerência muda) e para os setores;
  - **papel em cada setor** marcado (Colaborador / Co-gestora / Gestora), gravado no próprio setor;
  - resumo "Fica assim: …" e **um Salvar só** (antes eram selects/menus que gravavam a cada mudança).
- As tags da pessoa mostram um chip por cargo, na cor do cargo.
- **Pendente:** o Vitor marcar no site (Equipe → Vitor → Editar): cargo **TI** (além de ADM) e setores **Geek + Marketing** (criar o setor Marketing em "Setores" se ainda não existir). Não deu para gravar direto no D1: a máquina não tem Node/wrangler.

## 2026-11-13 — Gestor(a) TI e organograma mais legível
- Novo cargo padrão **`gestorti` — "Gestor(a) TI"** (nível `ti`, cor #155E75) em `js/store.js` e `functions/_lib/api.js`. Contas/bases antigas recebem o cargo automaticamente em `Cargos.lista()` (`js/cargos.js`), logo depois de "TI".
- Organograma (`js/organograma.js` → `ramoTI`): ramo TI agora é **TI → Gestor TI (pílula) → demais pessoas de TI**.
- Visual (`css/style.css`, fim do arquivo): linhas de ligação na cor de cada ramo (`--lc`), fundo pontilhado com borda, destaque ao passar o mouse/foco por teclado.
- Commit `a893970` na `main` de `VitorTozeti/Espro_frame` (deploy automático no Pages). Testado no navegador local com equipe simulada.

## 2026-11-13 — TI dentro do Marketing no organograma
- Regra correta (confirmada pelo Vitor): **o TI faz parte do Marketing, mas é cargo separado.** No organograma o TI é um **sub-ramo próprio dentro do setor Marketing** (TI → Gestor TI → equipe TI), ao lado da Gestora/Co-gestoras/equipe do Marketing — e não mais misturado à equipe do Marketing nem como ramo solto ao lado dos setores.
- Código (`js/organograma.js`): `ehTI(u)` tira quem tem cargo `ti`/`gestorti` da equipe dos setores; `ehMarketing(s)` (nome contém "marketing") recebe o `ramoTI` como filho, na visão completa e na visão do setor. Sem setor Marketing, o TI volta a ser ramo solto.
- Commits na `main` de `VitorTozeti/Espro_frame`: `6822666` (1ª tentativa, TI solto) e a correção seguinte (TI dentro do Marketing).
