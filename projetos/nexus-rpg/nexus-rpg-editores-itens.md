---
name: nexus-rpg-editores-itens
description: 2026-10-14 — editores master-detail unificados (Recursos, Itens, Técnicas, Classes/Origens), efeito condicional "quando vale", itens com Uso/raridade/biblioteca com mecânica e validação por classe
tags: [projeto, proj/nexus-rpg, itens, efeitos, recursos, tecnicas, ux]
updated: 2026-10-14
---

# Nexus RPG — Editores unificados, itens e efeito condicional (2026-10-14)

Parte do [[nexus-rpg]]; continua [[nexus-rpg-classes-origens]]. Pedido do Vitor: deixar classe, origem,
**recursos** e **técnicas** tão editáveis quanto perícias, e dar aos **itens** o mesmo método de casos
especiais (efeitos) das classes. Código no repo `The-One-System` (ver [[nexus-rpg-dados]]); ainda sem commit.

## Peça nova: `master-detail.js`
Lista à esquerda (digitar nome+Enter cria, busca, biblioteca) e editor à direita com abas. Funções:
`mdLayout`, `mdCab`, `mdBotoes` (▲▼ reordenar, duplicar, excluir com Desfazer), `mdAbas`, `mdCartao`,
`mdAbrirTudo`, `clonarComIds`, `moverNaLista`. Usada por Classes, Origens, Recursos, Itens e Tiers de técnica.

## Efeito condicional — "⏱ Vale"
Qualquer efeito de topo (classe, origem, item, condição, escolha) aceita `ef.quando`:
`{tipo:'nivel', n, m}` (do nível n até m; m=0 sem fim) ou `{tipo:'atributo', attrId, n}` (atributo ≥ n,
lido da 1ª passagem para não depender de ordem). Motor: `quandoOk` em `example-system.js`; o rótulo
(`effectLabel`) mostra ` ⏱ Nível 5+`. Ex.: Espada flamejante ganha +1 de dano no nível 5 e outro no 10.
Efeito por código também passou a ter `fx.fonte`/nota com o **nome do item/condição** (antes ficava o último).

## Itens (`itens-editor.js`)
- Abas: 📋 Básico · ⚔ Combate (ataque/armadura) · ✨ Efeitos (receitas prontas + ⏱ + código) · 🧪 Uso.
- Novos campos: `icon`, `raridade` (cor do cartão), `uso{on,resId,formula,consome,texto}`.
- **Uso:** botão "🧪 Usar" no inventário do jogador (`usarItem`): rola a fórmula (aceita dados `2d4+2`),
  soma/tira do recurso limitado ao máximo e gasta 1 unidade. Fórmula de uso é texto simples validado
  por `mediaExpr` — o `campoFormula` comum **não aceita dados**.
- `CATALOGO_ITENS2`: ~22 itens com mecânica (armas já com ataque, armaduras que definem Defesa, Botas
  aladas = Voo, Anel contra o fogo, Espada flamejante que cresce, Medalhão por código, poções com Uso).
- Avisos de aba: item com efeito que não é equipável nem usável; uso sem fórmula/inválido.

## Recursos e Técnicas (`recursos-tecnicas.js`)
- **Recursos:** abas 📐 Fórmula (tabela de valores por nível) · ♻ Recarga · 🔗 Quem mexe (lista classes,
  origens, armaduras, itens, condições que alteram o recurso). Campos novos `icon`, `desc`. Biblioteca
  de 8 recursos já ligados ao atributo certo (Vida, Mana, Estamina, Sanidade, Defesa, PA, Sorte, Fé).
- **Técnicas (tiers):** tiers viraram cartões com `icon`/`desc`, ▲▼/duplicar, custo base por degrau e
  **simulador de custo final**; 3 modelos prontos de tiers (substituição com Desfazer).

## Classes/Origens — melhorias de edição
▲▼ e busca na lista, "Expandir/Recolher tudo", **Copiar habilidades de outra classe**, comparação
"sistema → com esta classe" por nível nos recursos, `arqProblemas` (fórmulas inválidas, nível acima do
máximo, código com erro de sintaxe, resistência sem tipo) no cartão, na aba Visão e no aviso da aba.
Catálogo ganhou mecânica para Bardo, Druida, Paladino, Detetive, Arqueiro, Nobre e Órfão.

## Como testar
`launch.json` → `the-one-system` (porta 8794). No painel abra **Sistema**; abas avançadas (Técnicas)
exigem `irParaAba('tecnicas')` (o Modo Simples esconde). Sem `node` na máquina: validei no navegador.
