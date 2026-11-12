---
name: ideias-como-realizar
description: método passo a passo para transformar uma ideia em projeto real — validação, MVP, escolha de stack, plano faseado e checklist de lançamento
tags: [ideias, processo, ideia/metodo, sempre-considerar]
updated: 2026-09-29
---

# Como realizar uma ideia (do papel ao projeto)

## 1. Clarear (30 min)
- **Problema:** que dor resolve? Para quem (você, outra pessoa, público)?
- **Uma frase:** "Ajuda [quem] a [fazer o quê] sem [dor]."
- **Já existe?** Pesquise 15 min. Existir não mata a ideia — diga o que seria diferente.

## 2. Validar barato
- Conversar com 2–3 pessoas do público ou usar você mesma como usuária.
- Protótipo de papel/Figma/planilha antes de código.
- Restrições: custo (APIs gratuitas? veja o padrão em [[meu-spotify-dados]]), legal, tempo.

## 3. Definir o MVP
- Liste funcionalidades; risque tudo que não é essencial para a **primeira** versão.
- Regra: MVP em **1–2 semanas** de trabalho. Se maior, corte de novo.
- Critério de pronto: uma pessoa consegue completar o fluxo principal.

## 4. Escolher a stack pelo tipo de ideia
| Tipo | Caminho sugerido | Estudar |
|---|---|---|
| Site/PWA local-first | HTML/JS ou React, LocalStorage/IndexedDB | [[estudos-front-end]] |
| App com login e dados | React/Angular + API (Spring/Node) + banco | [[estudos-full-stack]], [[estudos-back-end]] |
| Jogo | Godot / Unity / Phaser | [[estudos-jogos]] |
| Ferramenta/agente IA | Python/Node + API de LLM + tool-calling | [[kemy-tool-calling-seguro]], [[grok-code-cli]] |
| Sistema grande | modelar antes de codar | [[estudos-modelagem-software]] |

## 5. Planejar em fases
Copie o formato de [[comanda-digital-plano]] ou [[nexus-rpg-planejamento]]: fases curtas, cada uma com entregável testável e checklist entregue/pendente.

## 6. Executar
Uma fase por vez; commit pequeno; teste manual do fluxo principal a cada fase. Ao descobrir/mudar algo, atualize o vault (protocolo do `CLAUDE.md`).

## 7. Virar projeto do vault
Pasta `projetos/<slug>/`, hub, `<slug>-dados` (obrigatória), tag `proj/<slug>`, cor nova no graph, linha em [[mapa-projetos]], [[mapa-dados]] e `_INDEX.md`.

## 8. Lançar e aprender
Publicar (GitHub Pages/Cloudflare Pages como o [[mural-dados]]), pedir feedback, registrar lições no hub.

## Relacionado
- [[ideias]] · [[ideia-template]] · [[estudos-programacao]] · [[mapa-projetos]]
