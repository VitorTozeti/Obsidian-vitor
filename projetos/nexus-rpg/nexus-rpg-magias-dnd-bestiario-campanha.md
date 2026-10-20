---
name: nexus-rpg-magias-dnd-bestiario-campanha
description: 2026-10-20 — teste "dá para criar magias de D&D e um bestiário fácil e livre?" + tudo o que faltava para uma campanha inteira: regras de magia (execução, concentração, ataque, aumentar), pacote SRD, bestiário rápido, técnicas aplicadas no combate, Missões & Mundo, graus de sucesso, Sanidade X/Y, subir de nível, régua, modelos inspirados e livro da campanha
tags: [projeto, proj/nexus-rpg, magias, dnd, bestiario, combate, campanha, missoes]
updated: 2026-10-20
---

# Nexus RPG — Magias de D&D, bestiário fácil e o que faltava na campanha (2026-10-20)

Parte do [[nexus-rpg]]. Resposta ao pedido "adicione tudo que faltou, mas antes analisa se magias do D&D e o bestiário
são fáceis, livres e criativos". Fecha as lacunas de [[nexus-rpg-campanha-ponta-a-ponta]]. Commit `fd17949` (The-One-System, main).

## 1. Análise antes de mexer
### Magias do D&D no editor de técnicas (como estava)
| Magia | Dava? | O que travava |
|---|---|---|
| Mísseis Mágicos (3 dardos que não erram, +1 por círculo) | 🟡 | sem **aumentar** (upcast) |
| Rajada de Fogo (truque, 1d10→4d10 por nível, ataque) | ❌ | sem **rolagem de ataque** contra a Defesa; dados não cresciam por fórmula (`(…)d10`) |
| Bola de Fogo (8d6, esfera 6 m, Destreza metade, +1d6/círc.) | 🟡 | área e teste ok; faltava aumentar e **círculo** |
| Escudo (reação, +5 CA) | 🟡 | sem **tempo de execução** (reação/bônus) |
| Imobilizar Pessoa (paralisado, repete teste, concentração) | 🟡 | sem **concentração** e sem "repete o teste" |
| Bênção, Velocidade (concentração em aliados) | 🟡 | sem concentração |
| Arma Espiritual / Conjurar Animais | ✅ | invocação já existia |
| Espaços de magia | ❌ | nenhum jeito simples → resolvido com a variante oficial **Pontos de Magia** (DMG) |
**Veredito:** dava para fazer ~60% e o resto virava texto. Liberdade boa (tipos, área, condição), mas faltava a "gramática" de magia.

### Bestiário (como estava)
Atributos, PV, Defesa, ataques texto, tags, 4 modelos de força. **Faltavam:** técnicas/magias no inimigo, resistências, deslocamento,
ND, traços, fases de chefe, ações lendárias, arquétipos de criatura, importar statblock de livro, e o combate aplicar o efeito nos alvos.

## 2. O que foi adicionado
### Regras de magia — `src/ui/conjuracao.js` (+ campos em `sanitizarUsoHab`)
- `ab.uso`: `execucao` (ação/bônus/reação/movimento/livre/completa/minuto/hora), `concentracao`, `ritual`, `componentes`, `circulo`, `escola`,
  `repete`, `ataque {on,bonus}`, `aumenta {formula,custo,max}`. Editor "📜 Regras de magia" dentro do "Usar na ficha" (recolhido até usar).
- **Ficha:** pergunta "quantos níveis a mais" (aumentar soma `NdX` e custo), rola **ataque** (crítico dobra só os dados), marca a bolinha
  da ação certa nas Ações por turno, **concentração** única (começar outra encerra a anterior; chip "🧠 Concentrando em…" com encerrar).
- **Dados por fórmula:** `expandeDadosDinamicos` (dice-engine) — `(1 + piso((Nível + 1) / 6))d10` vira 1d10…4d10; aceita parênteses aninhados.
- **Pacote 📘 D&D 5e (SRD, CC-BY-4.0)** — 20 magias com texto próprio: Rajada de Fogo, Raio de Gelo, Rajada Mística, Mísseis Mágicos, Curar Ferimentos,
  Palavra Curativa, Escudo Arcano, Onda Trovejante, Bênção, Imobilizar Pessoa, Arma Espiritual, Passo Nebuloso, Bola de Fogo, Relâmpago, Contramágica,
  Velocidade, Revivificar, Conjurar Animais, Cone de Frio, Desintegrar. Se adaptam aos atributos do sistema (Destreza→Agilidade, Inteligência→Mente…).
- **📘 Pontos de Magia:** botão cria o recurso + coluna "Tabela PM" (4…133 por nível); custo por círculo 2/3/5/6/7/9/10/11/13.

### Bestiário rápido — `src/master/campaign/bestiario-extra.js`
- **Arquétipo × força:** 12 criaturas (lobo, goblin, esqueleto, zumbi, orc, bandido, aranha gigante, mago/cultista, golem, espírito/maldição,
  dragão jovem, chefe humanoide) × lacaio/soldado/elite/chefe — dois cliques e a ficha já vem com ataques, técnicas, resistências, movimento.
- **📋 Colar statblock** (D&D em inglês ou português): CA, PV, deslocamento, 6 atributos, imunidades/resistências, ND, ataques "+6 to hit … (2d8+4)"
  e habilidades com CD/teste ("DC 13 Dexterity … (4d10) … half") viram técnicas com área ("15-foot cone" → cone 4,5 m).
- Cartão com abas **✨ Técnicas** (mesmo editor das técnicas + modelos + assistentes), **🧾 Perfil** (ND, deslocamento, resistências, traços,
  "usa a regra de morte") e **👑 Chefe** (fases por % de vida, ações lendárias).

### Técnicas aplicadas no combate — `src/master/campaign/combate-acoes.js`
- Na linha expandida do combatente: botões das técnicas (inimigo do bestiário ou jogador com ficha importada) → painel de **alvos**
  (pré-marca inimigos ou aliados conforme o tipo; invocação fica do lado de quem invocou) → **Aplicar**: paga custo, rola dano 1×,
  **ataque contra a Defesa** ou **teste de resistência de cada alvo** (metade/anula), aplica dano/cura, condição, recursos extras, registra no log.
- **Invocações** entram na ordem logo após quem invocou, com botão 🎲 Atacar. **Regra de morte** para jogadores e inimigos marcados (caído, testes,
  contagem, estabilizar). **Fases do chefe** avisam ao cruzar o %. **Ações lendárias** com contador. Lembrete de **teste de concentração** ao sofrer dano.

### 📜 Missões & Mundo — `src/master/campaign/mundo.js` (nova seção na Mesa)
- **Arcos e missões** (estado, objetivos marcáveis, NPC contato, facção, local, recompensa, XP; concluir dá XP ao grupo e anota no diário).
- **Pistas** ligadas a missões ("onde", "leva a…"), botão 👁 que vira handout na Tela dos jogadores.
- **Facções** com reputação −3…+3 (muda anota no diário), objetivo, membros (campo Facção no cartão do NPC).
- **Calendário** (meses/dias/era próprios, avançar dias, eventos que avisam quando chegam).
- **Segurança:** linhas, véus, notas da sessão zero e **✋ Carta X** (pausa a Tela dos jogadores).
- **📕 Livro da campanha (PDF):** diário + missões + NPCs + facções + grupo.

### Outros — `src/ui/regras-extra.js`
- **Graus de sucesso** (aba 🎲 Dados): d20 vs CD com crítico ±10 e nat 20/1 (PF2e) ou d100 ≤ valor com difícil/extremo/desastre (CoC). Campo CD no bloco Dados.
- **😱 Teste e perda X/Y** por recurso (aba Recursos): botões "🎲 Testar" (1d100 ≤ atual) e "Perda X/Y" (ex.: 1/1d6).
- **⬆ Subir de nível** na ficha (bloco Nome): lista recursos que cresceram (e soma a diferença ao atual), habilidades novas, pontos, técnicas e escolhas.
- **Livro de regras:** capítulo automático "Morte, movimento e ações" (+ graus de sucesso).
- **Modelos de sistema "inspirados em"** Ordem Paranormal (pool d20, NEX, PV/PE/SAN, morrendo), Feiticeiros & Maldições (6 atributos com modificador,
  Energia Amaldiçoada, grau por coluna, proficiência) e Tormenta20 (½ nível, PV/PM, morte por vida negativa) — **aproximados**, conferir no livro
  ([[pesquisa-ordem-paranormal]], [[pesquisa-feiticeiros-e-maldicoes]], [[pesquisa-tormenta20]]).
- **📏 Régua no mapa** (botão ou Shift+arrastar): distância em metros/casas pela regra de movimento.

## Testado (navegador embutido, servidor sem cache na porta 8795, conta local apagada depois)
Dados `(…)d10` → 1d10/3d10; Bola de Fogo aumentada +2 (−7 PM, 10d6); Rajada com ataque e crítico; concentração troca e encerra; Palavra Curativa marca
"Ação bônus" e avisa na 2ª; dragão (sopro em 3 goblins com teste de cada um), chefe com fase a 50% e regra de morte, mago invocando 2 lobos; statblock
"Ogre Zombie" importado (CA, PV, ataque, sopro em cone 4,5 m); missão concluída dá 100 XP e entra no diário; pista vira handout; Carta X pausa a tela;
graus nos dois modos; subir de nível; livro; três modelos inspirados; régua "9 m · 6 casas". Nenhum erro de console do app.

## Limitações conhecidas
- Jogador na própria máquina não aplica técnica no combate do Mestre (app offline): o Mestre aplica pela linha do jogador importado.
- "Bênção" e "Velocidade" existem com o mesmo nome no grupo antigo e no 📘 D&D (estão em grupos separados no seletor).
- Os modelos inspirados usam números aproximados (livros oficiais não lidos).
