---
name: nexus-rpg-classes-origens
description: 2026-10-14 — classes e origens reformuladas (fórmula de recurso por classe, habilidades por nível, técnicas de classe, traços com efeito, efeito por código) + correções de layout/contraste
tags: [projeto, proj/nexus-rpg, classes, origens, efeitos, ux]
updated: 2026-10-14
---

# Nexus RPG — Classes, origens e efeitos (2026-10-14)

Parte do [[nexus-rpg]]. Pedido do Vitor: layout mal espaçado + deixar classes e origens tão fáceis
de criar/editar quanto as perícias, com classe mexendo no cálculo de recursos, habilidades que todo
membro da classe ganha num nível, técnicas escolhidas por nível, efeitos variados (resistência,
força, defesa, especial via código) e origem afetando visual/corpo (asas → voo).
Commit `b7c508d` no repo `The-One-System` (ver [[nexus-rpg-dados]]).

## Modelo de dados (novos campos)
- **Classe e origem:** `icon`, `color`, `recursos:[{resId, modo:'substitui'|'soma', formula}]`.
  Na fórmula, `Base` = valor da fórmula do sistema (ex.: Vida do Bárbaro `Base + Nível * 3`).
  Ordem: sistema → "substitui" → "soma" → efeitos de recurso com fórmula.
- **Habilidade de classe/origem:** a mesma `abilities[]`, com `req.level` = nível em que TODO
  personagem da classe ganha automaticamente (editor mostra como linha do tempo).
- **Técnicas de classe:** `classe.tecnicas = {nome, formula, opcoes[]}`. Quantas escolhe =
  `formula` (ex.: `Nível`, `1 + piso(Nível / 2)`) + efeitos "técnica extra" de qualquer fonte,
  limitado às opções liberadas no nível. Rascunho do jogador: `d.classTechs[]`.
- **Origem:** `visual {aparencia, tamanho}`; `traits[]` agora têm `icon` e `effects[]` (aplicados).
- `sys.codigoBloqueado` — true ao importar `.nexus` que tem efeito por código.

## Novos tipos de efeito (`applyEffectTo`)
| kind | o que faz |
|---|---|
| `rolagem` | bônus fixo em ataque/dano/defesa/perícia/técnica/todos (`B.rollBonus`; entra em perícias e ataques) |
| `resistencia` | reduz N / ½ / imune / vulnerável ×2 por tipo de dano (`B.resist`) |
| `capacidade` | Voo, Natação, Visão no escuro… com alcance; vira variável de fórmula (`B.caps`) |
| `tecnicas` | +N técnicas de classe |
| `recurso` + `formula` | bônus de recurso que cresce (ex.: `Nível`) |
| `codigo` | JavaScript do Mestre recebendo `fx` (`fx.rolagem`, `fx.resistencia`, `fx.capacidade`, `fx.atributo`, `fx.nota`, `fx.nivel`, `fx.attr()`…) |

Efeito por código: compilado com `new Function` e cacheado; erros aparecem na ficha; sistema
importado roda nada até o Mestre clicar "Li o código — liberar" (risco: código roda no navegador).

## Arquivos
- `src/data/arquetipos.js` — motor (sanitize, baldes, resistências, capacidades, código, técnicas, fórmula de recurso).
- `src/ui/classes-origens.js` — editor master-detail (lista à esquerda, editor com abas Visão/Recursos/
  Habilidades por nível/Técnicas/Tabela ou Traços), prévia ao vivo por nível, receitas de efeito,
  catálogos com mecânica (Guerreiro, Mago, Ladino, Clérigo, Bárbaro…; Humano, Elfo, Anão, Alado, Tritão, Draconato, Autômato…).
- `assets/css/classes.css`; `player.js` (passo de Técnicas no wizard, cartões de classe/origem, bloco
  Características com movimento/resistências/bônus); `master-pieces.js` (`effectRow` com grupos).
- Removidos: `featureCard/featureItem/traitEditor/abilityEditor` e os catálogos só-identidade.

## Layout/contraste corrigidos
- `.btn` base usava texto branco fixo → botões ghost invisíveis no tema Pergaminho; agora `var(--txt)`.
- Cabeçalho limitado a 900px → 1700px; painel **Sistema** ocupa a linha inteira (`.mpane.wide`).
- Ficha ao vivo começa recolhida em tela < 1380px (cobria o editor).
- Papel da ficha (`.cv`) tinha fundo escuro fixo → segue o tema; cores hex escuras inline viraram variáveis.
- Rail "Jogadores" mostrava 3 ícones (emoji ZWJ) → 🤝; ícones de classe/origem não passam pelo `iconPass`.
- `h()` aceita variáveis CSS em `style` (`--arq`).
