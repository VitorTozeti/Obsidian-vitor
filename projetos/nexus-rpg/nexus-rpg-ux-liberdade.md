---
name: nexus-rpg-ux-liberdade
description: reflexão de UX/UI do Nexus RPG — princípios e propostas por tela para deixar o app agradável, livre para experimentar e ainda guiado/acessível
tags: [projeto, proj/nexus-rpg, ux, ui, acessibilidade, roadmap]
updated: 2026-10-14
---

# Nexus RPG — UX: liberdade criativa com rede de proteção (2026-10-14)

Complementa a seção 5 do [[nexus-rpg-plano-melhorias]]. Ainda é **proposta**, nada foi implementado.

## Diagnóstico
O app funciona, mas o fluxo foi pensado como **formulário com validação**: o checklist da aba Início,
o `canNext` do wizard e os erros de fórmula dizem "falta isso", e quase nada diz "experimente isso".
Ter 17 abas mais o modo avançado faz o Mestre sentir que precisa preencher tudo antes de jogar.
O medo de errar (excluir sem desfazer, o limite de ~5 MB do localStorage) inibe a experimentação.

## Princípios
1. **Nada é obrigatório para testar.** Todo sistema incompleto pode ser jogado: as lacunas viram padrões visíveis ("sem atributo → 10").
2. **Errar é barato.** Desfazer global, lixeira, snapshots/versões do sistema, "duplicar e brincar".
3. **Ajuda que convida, não que bloqueia.** Avisos aparecem como sugestões ("💡 dica"), nunca como travas. O checklist vira "o que dá para fazer agora".
4. **Feedback imediato.** Toda edição de regra mostra o efeito ao vivo numa ficha-exemplo.
5. **Divulgação progressiva.** O modo avançado é ligado por aba ou por recurso, e não como um muro global.
6. **Acessível por padrão.** Teclado, foco visível, contraste, `prefers-reduced-motion` e textos claros, sempre.

## Propostas por área
| Área | Proposta | Por quê |
|---|---|---|
| Global | **"▶ Testar agora"** sempre visível: abre uma ficha-exemplo gerada com o sistema atual, em gaveta lateral | ciclo criar→ver em segundos |
| Global | **Snapshots** ("Salvar versão", "Voltar para…") e "Duplicar sistema como rascunho" | coragem para experimentar |
| Global | Desfazer por toast em toda exclusão (5.8) + lixeira de 30 dias | errar barato |
| Global | Ctrl+K como **paleta de comandos** (ir para, criar, testar, alternar tema), não só busca | poder sem menus |
| Início | Trocar o checklist de "problemas" por **cartões de próxima ação** e um progresso leve; problemas em tom de sugestão | motivação em vez de cobrança |
| Início | **Modelos de partida** (D&D-like, Ordem-like, minimalista 3 atributos, em branco) | página em branco intimida |
| Abas de regras | Prévia ao vivo ("Ficha de teste: FOR 14 → mod +2, Vida 24") ao lado de cada fórmula | entender a regra sem rolar |
| Abas de regras | Padrões editáveis inline: clicar no texto para renomear e arrastar para reordenar (perícias, atributos, classes) | menos formulário |
| Abas de regras | Biblioteca pronta (como a de perícias) também para classes, origens, condições e itens | começar por remix |
| Fórmulas | Autocompletar de variáveis, erro explicado em português com exemplo de correção | fórmula é a parte mais assustadora |
| Editor de ficha | Botões ↶ ↷ visíveis, snap, guias de alinhamento, miniaturas na paleta, modo "pré-visualizar como jogador" | já no backlog 5.3, é o núcleo criativo |
| Editor de ficha | Mover/redimensionar blocos pelo teclado (setas, Shift+setas) | acessibilidade do canvas |
| Wizard do jogador | Etapas **não bloqueantes**: pular etapas e voltar; prévia da ficha sempre visível; "🎲 Rolar aleatório" por etapa | jogador também cria |
| Campanha/Mesa | Arrastar e soltar entre painéis (bestiário→mapa, item→jogador); estados vazios com ação | fluidez na sessão |
| Visual | Ícones SVG únicos (5.2), escala de espaçamentos e tipografia, microanimações curtas (respeitando reduced-motion) | acabamento "agradável" |
| Visual | Tema da **ficha** separado do tema do app (5.3) | identidade de cada sistema |
| Acessibilidade | `role=tablist`, focus-trap nos modais, `aria-live` nos toasts e rolagens, contraste AA em todas as paletas de `temas.js`, alvos ≥ 40px | manter a ajuda inclusiva |
| Ajuda | Glossário contextual com "?" ao lado de cada termo; tour opcional de 5 passos, que pode ser dispensado e reaberto | ajuda disponível, nunca imposta |

## Ordem sugerida (ondas)
1. **Rede de proteção:** desfazer/lixeira, snapshots, avisos sem bloquear. Isso destrava tudo o resto.
2. **Ciclo de teste:** "Testar agora" + prévia ao vivo nas fórmulas.
3. **Começo fácil:** modelos de partida, bibliotecas, estados vazios com ação.
4. **Acabamento:** ícones, ritmo visual, editor de ficha (5.3), acessibilidade (5.5).

Relacionado: [[nexus-rpg]] · [[nexus-rpg-telas]] · [[nexus-rpg-plano-melhorias]] · [[nexus-rpg-mesa-tokens]]
