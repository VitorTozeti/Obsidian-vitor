---
name: nexus-rpg-teste-rezero-ux
description: teste às cegas do Nexus RPG criando um sistema de Re:Zero como Mestre — o que fluiu, o que faltou, o que atrapalhou, e o status de cada item após as correções (2026-10-16)
tags: [projeto, proj/nexus-rpg, ux, ui, teste, feedback, roadmap]
updated: 2026-10-16
---

# Nexus RPG — Teste às cegas: criando "Re:Zero" como Mestre (2026-10-16)

Teste de usabilidade do [[nexus-rpg]] (pasta `The-One-System`) feito **sem ler documentação nem código**: o objetivo era montar um sistema próprio de Re:Zero (retorno pela morte, magia por Od, Sanidade, Marca da Bruxa) e jogar um personagem (Natsuki Subaru) e um combate. Complementa [[nexus-rpg-ux-liberdade]] (jornada do usuário) e [[nexus-rpg-plano-melhorias]]. Dados do app: [[nexus-rpg-dados]].

**Como foi rodado:** `python -m http.server` na raiz do projeto + navegador embutido (a conta de teste é só LocalStorage). Fluxo: conta → Mestre/assistente → Atributos → Recursos → Perícias → Classes → Origens → Itens → "Testar como jogador" → Bestiário → Combate → Técnicas.

## Veredito curto
O **caminho feliz é muito bom**: do zero a "sistema jogável 12/12" em ~10 min sem ler nada. Assistente de 3 passos, checklist guiado, bibliotecas prontas, fórmulas ligadas aos *meus* atributos e prévia ao vivo no modo jogador. O que falta é **expressar regras de evento** (morrer, contar, gatilhos) — justamente o coração de Re:Zero — e polir vários atritos de interface.

Sistema montado: 5 atributos (Vigor, Agilidade, Mente, Od, Carisma), 4 recursos (Vida, Mana=`Od*4+5`, Sanidade, Marca da Bruxa), 9 perícias, 3 classes (Cavaleiro, Espiritualista, Retornante), 2 origens (Humano, Semi-humano), 5 itens, 1 inimigo (Grande Coelho ×3 no combate).

## ✅ O que funcionou muito bem (manter)
- **Assistente inicial** com 4 modelos + "Em branco", etapa final mostrando contagem do que ainda falta.
- **Início com "Próximo passo" + checklist de 12 itens + sugestões**; cada linha leva direto à aba certa.
- **Atributos:** digitar + Enter, sigla automática (VIG/AGI…), 3 caminhos (um a um, conjunto pronto, sugestões).
- **Recursos:** "peças prontas" já com fórmula ligada ao atributo, prévia "Nível 1/6/10", "Valor em cada nível".
- **Perícias:** biblioteca por categoria (41), agrupadas por atributo, com descrição.
- **Classe:** abas Visão geral/Recursos/Habilidades por nível/Técnicas/Tabela; override de fórmula por classe; prévia "Cavaleiro no Nível 10".
- **Técnicas:** campo *Custo — recurso* lista os **meus** recursos; "Quanto (aceita dados; negativo = dano)".
- **Combate:** "+ Grupo" numera inimigos sozinho; HP aceita `7`, `+5`, `=12`; log com horário; atalhos N/P.
- **Modo Jogador:** wizard Identidade→Atributos→Perícias→Ficha com contador de pontos e botões Sortear/Equilibrar/Zerar; prévia lateral recalcula tudo na hora (Sanidade subiu ao colocar Mente 3).
- Tour de 4 passos, Ctrl+K, desfazer/versões — "errar é barato" cumpre o que promete.

## 🔴 O que realmente FALTOU (funcionalidade) — por prioridade

1. **Gatilhos / regras de evento ("Ao chegar a 0…")** — *o maior buraco para Re:Zero.* Zerei a Vida e **nada aconteceu**: sem estado Morto/Inconsciente, sem alerta, sem ação. Eu queria: *ao Vida=0 → restaurar Vida e Sanidade, Marca da Bruxa +1, teleportar ao "ponto de salvamento"*. Hoje só dá via "efeito por código", que o Mestre iniciante não vai achar. → sugerir **"Quando [recurso] chegar a [valor] → [efeitos]"** com modelos prontos (morte, colapso mental, subir de estágio).
2. **Recurso contador (começa em 0 e sobe)** — Marca da Bruxa/Retornos/Corrupção. "Barra" começa **cheia** (10/10) e "Valor" é fixo. Falta o campo **"Começa em"** e um tipo **Contador/Relógio** (0→N, com evento ao encher). A recarga só oferece Nunca/Curto/Longo — falta "ao acontecer X" e "ao morrer".
3. **Recurso novo herda fórmula sem pedir** — criei "Marca da Bruxa" e veio `Vigor * 5 + 10` (supõe o 1º atributo). Deveria nascer vazio/com `0` e o app perguntar.
4. **Rolar perícia com 1 clique** — na ficha a tabela de perícias não é clicável e o rolador só aceita *atributo + tipo* ("Testes de perícia" sem escolher qual). O bônus treinado (+5) não entra automático. Falta botão 🎲 na linha da perícia e na linha do ataque/técnica.
5. **Sem noção de "Nível" opcional** — Re:Zero não tem níveis, mas Classe/Recursos/Técnicas giram em "Nível 1–10" (tabelas, "Valor em cada nível", "Nível inicial"). Falta opção *"Meu sistema não usa níveis"* (ou renomear o eixo: Estágio, Rank, Arco) que some com esses blocos.
6. **Perícia sem atributo silenciosa** — *Atletismo* entrou com atributo "—" porque o meu sistema não tem "Força" (a biblioteca liga por nome). Sem aviso no editor; só vi na ficha. → ao adicionar da biblioteca, se não achar atributo equivalente, **perguntar/ligar ao mais próximo** (ou marcar ⚠). Idem *Arcanismo→Mente* quando a magia é de **Od**.
7. **Combate só entende HP** — o rastreador/bestiário têm `HP`, `HP máx`, `Defesa` fixos e **não derivam dos meus recursos** (Vida/Mana/Sanidade/Marca). Falta o inimigo usar o mesmo molde do sistema (recursos próprios, Sanidade de inimigo etc.) e o combate mostrar/alterar outros recursos.
8. **Jogador de teste não entra no combate** — "+ Jogadores" não trouxe o Subaru que criei em "Testar". O Mestre só adiciona via exportar/importar ficha. Falta *"adicionar meu personagem de teste à mesa"* (um clique) para o Mestre testar o próprio sistema ponta a ponta.
9. **Biblioteca é toda "D&D"** — classes (Guerreiro, Mago…), origens (Elfo, Anão…), itens (Espada longa, Cota de malha…), temas. Para um mundo diferente nada serve. Falta **pacotes por gênero** (isekai/anime, terror, sci-fi, faroeste) ou ao menos "gerar a partir de um texto/ideia".
10. **Mais gerais:** nome de campanha digitado na 1ª tela não é reaproveitado no passo 2; classes novas nascem todas com o mesmo ícone ⚔️; sem **efeitos de estado em fila** (Veneno, Maldição/Marca) com duração/turno; sem **rolagem de teste de resistência com dificuldade (CD)** e resultado "sucesso/falha" automático; sem **tabela de consequências** (falha crítica → tabela).

## 🟠 O que atrapalhou (UX/UI) — por prioridade

1. **Resultado de rolagem escondido** — o "8" aparece no fim de uma caixa com rolagem interna, **abaixo da dobra** do bloco. O jogador clica "Rolar" e não vê nada. → mostrar o resultado grande (toast/overlay) e rolar o log para o topo.
2. **Blocos da ficha cortam conteúdo com scroll interno** — "Recursos" mostra só Vida/Mana e esconde Sanidade/Marca atrás de scroll **enquanto sobra espaço vazio** logo abaixo; "Atributos" também rola na horizontal (5 atributos, 1 cortado). Altura deveria ser automática (ou o bloco crescer).
3. **Fonte minúscula na ficha** (~8–9 px nos blocos) — ilegível em 1024×768; contrasta com o resto do app, que é grande. Respeitar tamanho mínimo de 12–13 px.
4. **Painéis empilham em vez de trocar** — clicar em *Bestiário* abre o painel **embaixo** do painel Sistema inteiro (página com ~3500 px). Para chegar ao Combate é preciso rolar por tudo. O botão **"Combate" da barra fixa não navega nem dá feedback** (o cartão abre lá no fim da página). → usar abas que **trocam** o conteúdo (ou rolar/destacar o alvo ao clicar).
5. **Quatro níveis de navegação ao mesmo tempo** — Editor/Testar → Painel/Sistema/Jogadores/Bestiário/Itens → Fundação/Personagem/Mundo/Saída → Início/Campanha/Regras. Pesado para quem acabou de chegar; o **breadcrumb** repete a informação. → colapsar o 3º e 4º níveis em um só no Modo Simples.
6. **Contadores de passo inconsistentes** — "Próximo passo · 8 DE 12", "7 de 12 passos", "passo 1 de 13" na mesma tela. E o checklist + "Sugestões do app" repetem as mesmas pendências.
7. **Layout pula ao clicar** — selecionar tema (✓ alarga o chip e reflui a fileira), adicionar perícia (o banner de sugestões encolhe e puxa tudo para cima), adicionar inimigo (rolagem salta). Cliques seguidos erram o alvo. → reservar altura, não reordenar, `scroll-anchor`.
8. **Texto digitado sumiu 2 vezes** (descrição de habilidade e nome de inimigo) logo após abrir/rolar o card — **não consegui reproduzir de forma confiável** (ao repetir persistiu). Suspeita: renderização assíncrona descartando o input; vale um teste automatizado.
9. **Passo "Perícias" do jogador sem contexto** — lista só os nomes; some o atributo e a descrição que o editor mostrava. Jogador escolhe às cegas.
10. **Rótulos grudados nos campos** no Bestiário (`HP[10] HP máx[10] Defesa[ ]`), sem unidade nem dica; botão de excluir em vermelho forte, grande e igual em toda linha de atributo (peso visual alto para ação rara).
11. **"Modo Simples" esconde abas avançadas e diz "12/12 jogável"** sem tê-las verificado (o próprio app avisa em letra pequena). "Montar a ficha" já vem ✔ sem o Mestre ter feito nada — dá sensação de passo falso.
12. **Descobribilidade do "Modo Simples"** — botão verde com ✓ parece um status, não um interruptor.

## Ideias para a v. seguinte (resumo acionável)
- [ ] Gatilho "Quando recurso chegar a N → efeitos" + modelo **"Retorno pela Morte / Ponto de salvamento"** (é o que torna um RPG "isekai/loop" possível).
- [ ] Tipo de recurso **Contador/Relógio** e campo **"Começa em"**.
- [ ] Chave **"Meu sistema não usa Níveis"** (e eixo renomeável).
- [ ] Resultado de rolagem em **destaque** + botão 🎲 em perícias, ataques e técnicas.
- [ ] Ficha: altura automática dos blocos, fonte mínima, sem scroll interno.
- [ ] Navegação por **abas que trocam** + "Combate" realmente navega; reduzir 4 níveis de nav.
- [ ] Bestiário/Combate usando o **molde de recursos do sistema**.
- [ ] Botão "Adicionar meu personagem de teste à mesa".
- [ ] Biblioteca por **gênero/tema** e aviso quando a biblioteca não encontra o atributo equivalente.
- [ ] Unificar contadores de passo (12 ou 13) e fundir "Sugestões" com o checklist.
- [ ] Estabilizar layout (sem pulos) e cobrir com teste o "texto some ao abrir card".

## O que NÃO foi testado (limite honesto)
Aba **Saída/Ficha (editor de blocos)**, **Mapa/Tokens**, **Diário**, **Notas**, **"Iniciar sessão"**, **Itens com efeito/uso em jogo**, **Backup/Restaurar/.nexus**, **efeito por código**. As capturas de tela do navegador embutido ficaram instáveis na 2ª metade, então parte do Bestiário/Combate/Técnicas foi verificada por leitura do DOM (texto), não visualmente.

## Notas de método
- Conta/dados de teste ficam só no LocalStorage do navegador embutido (usuário de teste; sem dados reais).
- Em ~10 pontos o clique por coordenada falhou por causa do layout que pula (item 7 acima) — foi preciso usar referências estáveis; um usuário real não tem essa saída.

Ver também: [[nexus-rpg-planejamento]] (backlog), [[nexus-rpg-telas]] (mapa das telas), [[nexus-rpg-classes-origens]], [[nexus-rpg-editores-itens]].

---

# ✅ Correções aplicadas (2026-10-16, mesma sessão)
Código em `The-One-System` (não commitado até a data desta nota). Legenda: ✔ resolvido e verificado no navegador · ◐ parcial · ✖ não feito. Detalhes técnicos em [[nexus-rpg-dados]] (seção 2026-10-16).

## Lacunas de regra
| # | Item | Status | O que foi feito / o que falta |
|---|---|---|---|
| 1 | Sem gatilho de evento | ✔ | Aba **⚡ Gatilhos** no recurso: "quando chegar a 0 / ao máximo → restaurar · somar · avisar" + modelo **Retorno pela Morte**. Verificado: Vida a 0 → Vida volta ao máximo, Marca +1, aviso na tela. Só dispara na **ficha do jogador**; no combate do Mestre só há log/aviso ao chegar a 0. |
| 2 | Sem contador | ✔ | Campo **Começa em** + botão **🔢 Contador**; na ficha: Zerar / ↺ Início. Verificado (Marca 0/10). |
| 3 | Recarga limitada | ◐ | "Ao morrer" resolvido via gatilho; ainda não existe "recarrega quando X acontecer" genérico. |
| 4 | Nível obrigatório | ◐ | **"Meu sistema não usa níveis"** (Regras): some seletor de nível, tabela por nível, prévia por nível e "Nível N" no subtítulo. Continuam existindo o campo "Libera no nível" das técnicas, a aba Progressão e a variável `Nível` nas fórmulas (valem 1). |
| 5 | Bestiário/combate só HP | ◐ | Inimigo ganhou "ƒ PV pelo sistema" e **outros recursos** (máximo pela fórmula com os atributos dele ou manual); o combate mostra chips e edita −/+/valor de cada recurso. Vida continua tendo tratamento próprio e "Defesa" segue como texto livre. |
| 6 | Rolar perícia com 1 clique | ✔ | Clicar na perícia rola (Shift = vantagem, Alt = desvantagem) usando o valor da ficha. O bloco "Dados" ainda só escolhe atributo + tipo. |
| 7 | Personagem de teste fora do combate | ✔ | Botão **🧪 Adicionar meu personagem de teste** em Jogadores. Verificado entrando no combate com os recursos. |
| 8 | Bibliotecas só D&D | ◐ | +5 classes (Cavaleiro Real, Espiritualista, Curandeiro, Mercenário, Forasteiro/Retornante) e +4 origens (Semi-humano, Espírito menor, Convocado, Besta-humana). Itens e temas seguem só D&D. |
| 9 | Estados com duração, teste com CD, tabelas de consequência | ✖ | Não implementado. |

## Falhas de comportamento
| # | Item | Status | Nota |
|---|---|---|---|
| 1 | Recurso novo herdava `Vigor*5+10` | ✔ | Nasce com `10` e avisa por toast. |
| 2 | Perícia sem atributo em silêncio | ◐ | Toast ao adicionar da biblioteca + sugestão "Perícia X está sem atributo". A **ligação automática não melhorou** (Arcanismo continua indo para Mente). |
| 3 | "Montar a ficha" já ✔ | ✔ | Passo renomeado: "Ficha com ao menos um bloco — já vem uma padrão". |
| 4 | Modo Simples dizia 12/12 sem checar | ✔ | Agora também verifica as abas ocultas e avisa quantas sugestões há nelas. |
| 5 | "+técnica de classe" sem técnicas | ✔ | Nova sugestão. |
| 6 | Nome da 1ª tela perdido | ✔ | Vai para o campo de campanha do assistente; a revisão mostra também o nome do sistema. |
| 7 | Classes com o mesmo ícone | ✔ | Ícone e cor rotativos por classe/origem nova. |
| 8 | Botão Combate sem feedback | ✔ | Rola até o painel e dá um flash. |
| 9 | Texto some | ✔ | Causa raiz achada e corrigida (foco após `onchange`→`render`). Verificado com evento sintético: clique cai no campo certo. |

## UX/UI
| # | Item | Status | Nota |
|---|---|---|---|
| 1 | Resultado de rolagem escondido | ✔ | Toast grande de 4,5 s com o total (perícia, ataque, técnica, bloco Dados). |
| 2 | Scroll interno nos blocos | ◐ | Blocos crescem até caber o conteúdo e empurram os de baixo; 0 sobreposições medidas. Exceção: **Anotações** (textarea tem rolagem própria). |
| 3 | Fonte minúscula | ◐ | Telas <1100 px usam por padrão o modo **empilhado** (fonte natural). No modo layout o papel ainda é escalado (~0,74×). |
| 4 | Painéis empilham | ◐ | Mantido o multi-painel (decisão original); agora o clique leva até o painel. |
| 5 | Quatro níveis de navegação | ◐ | No Modo Simples o breadcrumb some; sobram os outros três níveis. |
| 6 | Contadores de passo | ✔ | "Faltam X de 12" · "X de 12 passos" · rodapé "aba N de 13". Sugestões não repetem o checklist. |
| 7 | Layout pula | ◐ | ✓ dos chips agora ocupa espaço fixo (assistente/temas): largura medida igual antes/depois. **Não resolvido:** o banner de sugestões ainda encolhe e puxa a página ao adicionar perícia. |
| 8 | Perícias do jogador às cegas | ✔ | Cartão com atributo e descrição. |
| 9 | Rótulos do Bestiário | ✔ | Rótulo acima do campo (visto em captura). O estilo discreto do botão excluir **não foi verificado visualmente** (seletores podem não casar). |
| 10 | "Modo Simples" parecia status | ✔ | "Modo: Simples ⇄ / Avançado ⇄" com tooltip. |

## Riscos
| # | Item | Status | Nota |
|---|---|---|---|
| 1 | Dados só no LocalStorage | ✖ | Sem mudança: backup continua manual. Lembrete automático de backup para a **conta** não foi feito. |
| 2 | Senha em texto plano | ✔ | Hash salgado (SHA-256 ×12 000, ~50 ms); vetor `abc` conferido; contas antigas migram no login (testado). Continua protótipo local. |
| 3 | Compartilhamento manual | ◐ | Inalterado, exceto o atalho do personagem de teste. |
| 4 | Referências quebradas | ✔ | Sugestões para efeitos/gatilhos/fórmulas que apontam para recurso inexistente. |
| 5 | Efeito por código | ✔ | CSP bloqueia qualquer saída de dados (`connect-src 'none'`); importação já vinha bloqueada. O código liberado ainda roda com acesso ao app (sem sandbox). |
| 6 | Schema | ◐ | Campos novos validados na migração; **restaurar backup antigo não foi testado**. |
| 7 | Acessibilidade | ✖ | Só `aria-pressed` nos novos toggles; sem auditoria. |

## Pendências / observações
- **Sem testes automatizados** no projeto: tudo foi verificado à mão no navegador embutido (DOM + capturas), inclusive Livro de regras sob a CSP (sem violações).
- **Suspeita não resolvida:** "+N dados por condição" **soma** os dados extras em sistema d20 (viu-se `3d20+4`); o comportamento é anterior a esta rodada. Por isso o pacote isekai novo usa bônus (+1), não dado extra.
- Ainda sem teste: aba Saída/editor de ficha, Mapa, Diário, backup/restauração, importação `.nexus`, Tela dos jogadores.

## Bestiário melhorado (2026-10-16, a pedido)
- **Modelos de força** (🐀 Lacaio · 🗡️ Soldado · 🛡️ Elite · 👹 Chefe): atributos escalam entre o valor inicial e o máximo do sistema, PV pela fórmula de Vida, ataque com dano coerente e tag automática. Verificado: Lacaio 20 PV 1d4 · Elite 30 PV 2d6 · Chefe 35 PV 3d8.
- **Busca** por nome/tag/nota + **filtro por tag** (chips) + Recolher/Abrir tudo.
- **Cartão recolhido** (resumo: PV, Defesa, nº de ataques, tags, rolar o 1º ataque) — cabe bem mais criaturas na tela; cartão novo abre sozinho e a tela vai até ele.
- **⚔️ Ao combate** direto do cartão; **excluir com desfazer** (antes era `confirm()` sem volta).
- Não testado: NPCs (sem mudanças nesta rodada), imagem do inimigo.
