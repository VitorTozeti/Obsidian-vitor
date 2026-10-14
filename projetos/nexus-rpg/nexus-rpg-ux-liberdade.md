---
name: nexus-rpg-ux-liberdade
description: proposta de UX/UI do Nexus RPG organizada pela jornada do usuário (Mestre e Jogador) — fluxo mais curto, livre para experimentar, com ajuda e acessibilidade
tags: [projeto, proj/nexus-rpg, ux, ui, acessibilidade, roadmap]
updated: 2026-10-14
---

# Nexus RPG — UX: um fluxo que convida a criar (2026-10-14)

**Status (2026-10-14): implementado quase tudo (ver “Implementado” no fim).** Complementa a seção 5 do [[nexus-rpg-plano-melhorias]].

## O problema em uma frase
Hoje o Mestre precisa **montar o sistema inteiro antes de ver algo funcionando**: 17 abas,
um checklist de "problemas" e um wizard que trava. A recompensa (ver uma ficha viva, jogar)
vem tarde demais, e o medo de errar (pouco desfazer) desestimula a experimentação.

## A ideia central
> **Jogável desde o primeiro minuto, e melhor a cada ajuste.**

O fluxo deixa de ser "preencher tudo → testar" e vira um **ciclo curto**:
**escolher um ponto de partida → ver a ficha ao vivo → ajustar → ver de novo.**
A ajuda aparece no caminho como sugestão e nunca bloqueia.

---

## Jornada do Mestre

### 1. Primeiro contato (0–1 min)
**Hoje:** login → personagem → 17 abas vazias.
**Proposto:** uma tela de boas-vindas com 3 cartões grandes:
- **Começar de um modelo** (estilo D&D, estilo Ordem, minimalista de 3 atributos)
- **Começar em branco**
- **Importar `.nexus`**

O modelo já vem jogável. A pessoa sai daqui com um sistema funcionando, não com uma lista de tarefas.

### 2. Criar e ajustar (o núcleo)
Layout em **duas colunas**: à esquerda, a aba de regras; à direita, a **ficha de teste ao vivo**
(gaveta que pode ser recolhida). Tudo o que mudar na esquerda aparece na hora na direita
("FOR 14 → +2 · Vida 24").
- **Menos abas visíveis:** as 4 seções (Fundação, Personagem, Mundo, Saída) viram uma barra lateral
  com progresso leve (●○). As abas avançadas aparecem quando a pessoa clica em "+ mais
  recursos" ou quando o modelo já as usa. Fim do muro do modo avançado global.
- **Editar onde se vê:** renomear com um clique no texto e reordenar arrastando (atributos,
  perícias, classes). O painel lateral fica para os detalhes, como já foi feito em Perícias.
- **Bibliotecas prontas** em todas as listas (classes, origens, itens, condições), não só em perícias.
- **Fórmulas sem medo:** autocompletar de variáveis, erro explicado em português com uma sugestão
  de correção que dá para aplicar com um clique, e o resultado de exemplo ao lado.

### 3. Validar sem travar
**Hoje:** o checklist da aba Início lista "problemas".
**Proposto:** um indicador discreto no topo ("Pronto para jogar · 2 sugestões"). Ao abrir,
aparecem **sugestões com ação** ("Nenhuma classe ainda: adicionar da biblioteca?"). Lacunas
nunca impedem o teste; elas usam um valor padrão visível e marcado em cinza.

### 4. Desenhar a ficha
O editor visual passa a abrir **já com o layout do modelo**, e a pessoa ajusta em vez de partir do zero.
Inclui desfazer/refazer visíveis, guias de alinhamento, encaixe, miniaturas na paleta, setas do teclado
para mover os blocos e um botão **"Ver como jogador"**.

### 5. Levar para a mesa
Botão fixo **"▶ Testar / Jogar"**: abre o wizard do jogador com o sistema atual, num modo de teste
que pode ser descartado. Ao voltar, a pessoa cai exatamente onde estava.

## Jornada do Jogador
- **Wizard não bloqueante:** etapas viram abas que dá para visitar em qualquer ordem; a **prévia da
  ficha fica sempre ao lado**; o que falta aparece como "falta escolher 2 perícias", sem desabilitar
  o Avançar.
- **"🎲 Me surpreenda"** por etapa e na ficha inteira, para quem quer só jogar.
- **Explicação no lugar:** "?" ao lado de cada termo abre o glossário do próprio sistema.

## Rede de proteção (vale para tudo)
- **Desfazer por toast** em toda exclusão, e uma **lixeira** de onde dá para restaurar.
- **Versões salvas automaticamente** ("há 10 min", "ontem") e "Duplicar como rascunho" para experimentar.
- Salvamento silencioso com indicador "✓ salvo", sem botão de salvar para lembrar.

## Ajuda e acessibilidade (sem atrapalhar quem já sabe)
- Tour opcional de 4 passos, que pode ser dispensado e reaberto pelo "?". Dicas somem depois de usadas.
- Ctrl+K vira paleta de comandos (ir para, criar, testar, trocar tema).
- Teclado em tudo (inclusive o canvas), foco visível, `role=tablist`, modais com foco preso,
  `aria-live` em toasts e rolagens, contraste AA em todas as paletas, alvos ≥ 40px,
  `prefers-reduced-motion`.
- Visual: um único conjunto de ícones SVG, escala consistente de espaçamentos e fontes, e
  microanimações curtas que confirmam a ação.

---

## Ordem de execução (cada passo já melhora o fluxo sozinho)
1. **Ficha de teste ao vivo + "Testar / Jogar"**: fecha o ciclo criar→ver. *(maior ganho)*
2. **Rede de proteção**: desfazer, lixeira, versões automáticas.
3. **Boas-vindas com modelos** + checklist transformado em sugestões.
4. **Wizard do jogador não bloqueante** + "Me surpreenda".
5. **Barra lateral enxuta**, bibliotecas em todas as listas, edição inline.
6. **Acabamento**: editor de ficha, ícones, acessibilidade completa.

Relacionado: [[nexus-rpg]] · [[nexus-rpg-telas]] · [[nexus-rpg-plano-melhorias]] · [[nexus-rpg-mesa-tokens]]

## Implementado (2026-10-14, repositório The-One-System)
| Passo | O que entrou | Onde |
|---|---|---|
| 1 | **Ficha ao vivo**: gaveta com herói de exemplo calculado com as regras atuais (atributos, recursos, perícias em ordem alfabética), seletor de nível, atalhos “Layout da ficha” e “▶ Testar / Jogar”; recolhe numa pílula (preferência em `nexus_live`) | `src/ui/ficha-viva.js`, `assets/css/ficha-viva.css`, `sampleDraft(sys,level)` |
| 2 | **Versões automáticas** (até 8 por personagem, a cada ~4 min de edição e ao sair da aba; “🕘 Versões” lista e restaura, e restaurar é desfazível) + botões **↶ ↷** visíveis na barra do editor | `src/ui/versoes.js` (`nexus_ver_<id>`) |
| 3 | Aba Início: “Verificação” virou **“Sugestões do app”** (💡, tom sem cobrança) e o botão **“▶ Testar assim mesmo”** fica sempre disponível; avisos nas abas idem | `src/master/master-nav.js`, `formula-field.js` |
| 4 | **Wizard do jogador não bloqueante**: etapas clicáveis (teclado ok), Avançar nunca trava (mostra 💡 do que falta), **“🎲 Me surpreenda”** sorteia nome, classe, origem, atributos e perícias dentro das regras | `src/player/player.js` (`surpreendaFicha`) |
| 5 | **Biblioteca de condições prontas** (14, sem efeitos mecânicos) e **Modo Simples como padrão** para quem ainda não escolheu | `src/ui/bibliotecas.js`, `state.js` |
| 6 | Esc fecha Versões; foco ao abrir. Foco visível, `prefers-reduced-motion` e `aria-label` já existiam | `shortcuts.js` |

| 7 | **Tour opcional** de 4 passos (abre 1ª vez, “❓ Tour” reabre, Esc/“Pular” dispensa; `nexus_tour_visto`) | `src/ui/tour.js` |
| 7 | **Boas-vindas no Início vazio**: 3 cartões (modelo · do zero · importar `.nexus`) | `master-nav.js` (`.bv-grid`) |
| 7 | **Bibliotecas** de classes, origens e itens prontos (só identidade; efeitos o Mestre liga) | `src/ui/bibliotecas-extra.js` |
| 7 | **Desfazer por toast** ao excluir classe/origem/item/condição (`comDesfazer`) | `bibliotecas-extra.js` |
| 7 | **Foco preso** (Tab) e `role=dialog` em busca, glossário, versões e tour | `tour.js`, `helpers.js` (`a11yPass`) |

**Já existia e não precisou mexer:** autocompletar/diagnóstico de fórmulas (`formula-field.js`), foco preso nos diálogos de confirmação, setas movendo blocos no canvas da ficha, ↑↓ para reordenar atributos, assistente de modelos na criação do Mestre.

**Decidido não fazer agora:** padronizar todos os ícones em SVG (5.2 do plano) — troca transversal de centenas de emojis, alto risco de regressão visual e pouco ganho de fluxo; fica como item próprio. Edição inline por clique no texto e arrastar-e-soltar para reordenar também ficaram de fora (✎ painel lateral e ↑↓ já cobrem).
