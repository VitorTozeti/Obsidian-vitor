---
name: nexus-rpg-teste-leigo-multisistema
description: 2026-10-27 — teste às cegas "como leigo" com 3 agentes montando 13 estilos de RPG (D&D, PF2, T20, OP, CoC, F&M, Re:Zero, Fate, PbtA, V5, Savage Worlds, Blades, GURPS); achados priorizados
tags: [projeto, proj/nexus-rpg, teste, ux, backlog]
updated: 2026-10-27
---

# Teste leigo multi-sistema (2026-10-27)

Teste do [[nexus-rpg]] (The One System) via preview `the-one-system-nocache` (8795). Três agentes testaram como usuários leigos, cada um com sua conta e sua aba. Ninguém editou código. Continua o [[nexus-rpg-teste-rezero-ux]] e usa a [[pesquisa-sistemas-rpg]].
> Os agentes dividiram o mesmo navegador, ou seja, o mesmo `localStorage`. Por isso viram a sessão uns dos outros. Mesmo assim isso revela um risco real em PC compartilhado.

## O que dá para montar

| Sistema | Resultado |
|---|---|
| D&D 5e | Parcial: falta espaços de magia e PV por dado de vida |
| Tormenta20 | Sim, pelo modelo, mas raso (3 classes, sem círculos) |
| Pathfinder 2e | Não fiel: sem proficiência TEML; 3 ações e 4 graus ficam escondidos no Modo Avançado |
| Ordem Paranormal | Parcial: sem rituais nem elementos; NEX vai de 1 a 20 em vez de % |
| Call of Cthulhu | Não: rolagem d100 errada, sem perícias em %, Sorte nem 8 características |
| F&M | Parcial: modelo sem técnicas; grau só como texto |
| Re:Zero | Sim (gatilho de retorno pela morte) |
| PbtA / GURPS | Aproximado: rola, mas sem faixas 6-/7-9/10+ nem roll-under fora do d100 |
| Fate, V5, Savage Worlds, Blades | Não: sem dF, sem explosão, sem contagem de sucessos, sem relógios nem caixas de estresse |

## Crítico
1. **O jogador não consegue usar o sistema do mestre.** "Criar Jogador e entrar" abre o sistema genérico de exemplo. Falta perguntar "com qual sistema?". "Meus personagens" mistura sistemas e fichas.
2. **A rolagem de CoC usa o bônus da perícia como alvo.** Resultado: "1d100 ≤ 4", sempre falha. Fica em `src/player/player.js:764`. Precisa de perícia percentual (0–100, metade/quinto).
3. **A ficha de teste some.** Some no F5, ao trocar de personagem (`S.draft`, `players.js:57`) e em "Adicionar meu personagem de teste". Não há aviso. Fazer rascunho automático e aviso antes de sair.
4. **Escolha de magias falha em silêncio.** O Avançar passa sem as magias e o bônus do Escudo não é aplicado. Travar o Avançar como já é feito em atributos.
5. ~~Sessão compartilhada~~ — **descartado pelo Vitor (2026-10-27):** o app ainda está em teste; contas/segurança não são objetivo agora.

### Causas no código (lidas em 2026-10-27)
- (1) `bindPersonagem` em `src/core/state.js` faz `S.system=defaultSystem()` para todo jogador. O comentário diz "por enquanto". O cartão Jogador em `auth-ui.js` também promete "sistema de exemplo".
- (3) Para o mestre, `bindPersonagem` zera `S.draft`, e a ficha de teste nunca é salva no personagem mestre. `adicionarPersonagemDeTeste` (`players.js`) depende de `S.draft` vivo.
- (4) Em `player.js`, o `avancar()` avança de propósito mesmo com pendência e só mostra um toast. A perda das magias marcadas ainda precisa ser reproduzida.
- (2) `rolarPericia` (`player.js` ~764) usa `valor` (atributo + proficiência) como alvo do "abaixo".

## Alto
- **Motor de dados** (`dice-engine.js`):
  - faltam `dF`, explosão `!`, contagem de sucessos (≥X), faixas de resultado configuráveis e roll-under com dado e limiar configuráveis;
  - `5d10>=6` devolve 1 em silêncio;
  - `4dF` só gera um aviso amarelo.
- **Recursos:** falta um tipo "caixas marcáveis" ou "relógio de N segmentos". Também falta o campo Aspectos (invocar = +2 ou rerrolar) e pontos de destino.
- **Modelos sem `morte.resId`** (OP, F&M, T20): a aba Início já nasce com o aviso "morte sem recurso de Vida".
- **Pacote de atributos "D&D (6)":** gera faixa 0–5 em modo "valor direto". Deveria ligar Modificador, 8–15 e compra de pontos pela tabela.
- **Vida:** a fórmula padrão `CON*5+10` não cresce com o nível. Falta dado de vida por classe.
- **Perícias no Multiplicador:** entram como "Metade". O rótulo "treinada" está velho.
- **Faltam:** espaços de magia por círculo, trava de círculo por nível e preset de proficiência TEML (PF2).
- **Números contraditórios** no checklist (perícias iniciais 7/3/11, pontos "Hoje 10" e "distribui 6"). Precisa de uma só fonte de verdade, no nível 1.
- **Carregamento:** ~12 s de tela branca (60 scripts) e o F5 não volta à aba onde a pessoa estava. Fazer tela de carregamento ou bundle, e lembrar a última aba.
- **Modelos rasos:**
  - OP: sem rituais nem elementos, só 3 origens, teste de SAN desligado;
  - F&M: sem técnicas;
  - T20: só 3 classes.
- **CoC:** sem modelo "Percentual (CoC/BRP)"; o assistente não deixa adicionar atributos.

## Médio
- Regras de d20 seguem ativas com outra base de dado (crítico ≥20 em d100 ou 4dF; vantagem em 2d20). Esconder conforme o modo.
- **Assistente:**
  - o título "Crie seu personagem" aparece para o Mestre;
  - não explica campanha × sistema;
  - o tema é opcional e depois é cobrado;
  - cobra classe/origem em Fate/PbtA;
  - o modal abre rolado;
  - "Em branco" nasce com o aviso de 7 perícias.
- **Navegação:** são 5 níveis de menu e o painel do mestre empilha seções. Nomes ambíguos: Regras × Mundo & Regras, Combate duas vezes.
- **Ctrl+K:** não tem sinônimos (ritual, magia, d100, sorte) e perde o primeiro texto digitado.
- **Validação:** PV negativo no bestiário e mínimo de atributo -3 passam. O erro de fórmula cita uma "lista abaixo" que não existe.
- **Personagem e combate:**
  - Equilibrar e Me surpreenda ignoram a classe;
  - a compra de pontos é linear;
  - "+ Jogadores" no combate não faz nada;
  - o grupo de monstros entra sem perguntar a quantidade;
  - a iniciativa não mostra o modificador;
  - Movimento vem no estilo T20 mesmo em sistema D&D.
- **Acessibilidade:** botão de perícia leva a descrição como nome; texto do login ilegível para leitor de tela; seletor de Graus não interativo.

## Baixo
- Jargão: "Expressão base", "kh/kl", "LocalStorage" no rodapé.
- Celular: o cabeçalho quebra em 3 linhas; usar um menu ☰.
- Cadastro sem confirmar senha. Ícones das classes não combinam com o tema.

## O que funcionou
- Desfazer/refazer, presets de morte D&D de ponta a ponta, prévia de fórmula por nível, preset Multiplicador D&D, assistente de 3 passos e wizard do jogador com prévia ao vivo.
- Combate com iniciativa e registro. Notação 2d6+2, 4d6kh3, melhor de N. Gatilho Re:Zero.

## Ordem sugerida de ataque
1. Jogador escolhe o sistema + rascunho que não se perde (críticos 1, 3, 5).
2. Perícia percentual + correção do CoC (crítico 2).
3. Motor de dados: sucessos, explosão, dF, faixas, roll-under configurável. Recursos tipo caixas/relógio. Isso destrava 6 sistemas.
4. Corrigir os presets: D&D, `morte.resId`, magias por círculo, TEML.
5. Polimento do assistente, da navegação e da validação.

## Correções feitas (2026-10-27) — commits `6cdf057`, `7418f33`, `dce2a18`
Testado no preview 8795 (ver [[nexus-rpg-dados]]):
- **(4) Magias:** a causa era o `h()` em `helpers.js`. Ele gravava `disabled="0"` quando recebia `disabled:0` (`bloq&&!on` dá `0`), o que desativava todo botão de técnica. Agora atributos booleanos falsos são ignorados no app inteiro. O Avançar do passo de técnicas trava até a escolha estar completa.
- **(1) Jogador no sistema do Mestre:** "Criar Jogador" tem o seletor `#pj-sys` (Mestres da conta, exemplo ou `.nexus`). O personagem jogador ganhou `mestreId` e uma cópia em `system`. `sistemaDoJogador(p)` (em `state.js`) sempre puxa a versão atual do Mestre. O cartão do hub mostra "Ficha no sistema: X".
- **(3) Ficha de teste:** o mestre ganhou `p.testDraft`, salvo pelo `persist()` e restaurado no `bindPersonagem`. Sobrevive ao F5 e à troca de personagem. O botão 🧪 sem ficha leva direto ao Testar.
- **(2) CoC:** `ehPercentual(sys)` e `pctDe(sys,d,s)` ficam em `regras-extra.js`. A perícia ganhou `basePct` (padrão 20) e a ficha ganhou `d.pct[id]` (0–99), editável na tabela de perícias, que no modo d100 mostra todas as perícias com difícil/extremo. A rolagem usa 1d100 contra o %. O dado bônus pega o menor. O "Crítico ≥ 20" fica escondido. Verificado: 400 rolagens com 60% batem com os graus.
