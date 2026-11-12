---
name: nexus-rpg-progressao-tags-criacao
description: 2026-10-20 — progressão refeita (modelos automáticos D&D/Ordem/T20, regras de ganho em frase, linha do tempo, colunas com atalhos), pontos por habilidade e treino por nível, tags com pacotes e matriz em grade, e criação de habilidades/técnicas menos confusa (barra única, biblioteca, cartão em abas, editor em passos com prévia)
tags: [projeto, proj/nexus-rpg, progressao, tags, tecnicas, ux]
updated: 2026-10-20
---

# Nexus RPG — Progressão, tags e criação de habilidades (2026-10-20)

Parte do [[nexus-rpg]]. Pedido do Vitor: tabela de progressão "muito confusa", progressão automática, ganho de atributo por nível ou
por habilidade de classe, perícias a mais por nível, modo de treinamento, tags melhores e técnicas/habilidades "confusas para criar".
Commit `ecfd9e9` (The-One-System, main).

## Progressão — `src/data/progressao.js` (motor) + `src/ui/progressao-ui.js` (aba 📈)
- **`sys.ganhos[]`** = regras: `{tipo, qtd, cada, aPartir, ate, niveis:'4,8,12', alvoId, nota}`. Tipos: pontos de atributo (livres),
  **atributo fixo** (soma sozinho), perícias novas, **melhorias de treino**, técnica de classe, recurso (soma no máximo), escolha/talento (aviso).
- Cada regra mostra uma **frase** ("💪 +2 pontos de atributo nos níveis 4, 8, 12, 16, 19"; plural do eixo: níveis/NEX/graus).
- O antigo `perLevel` ("+N a cada N degraus") é **convertido** em regras na primeira leitura (`sanitizeGanhos`).
- `levelPoints(sys,level,eff)` agora devolve `attrPoints, skillCount, treino, tecnicas` (regras + pontos dados por habilidades).
- Automáticos (`aplicaGanhosAuto` no fim do `gatherEffects`): atributo fixo → `attrBonus`, recurso → `resBonus`, técnica → `techExtra`.
- **Aba nova em 5 blocos:** 1 Eixo · 2 ⚡ Modelos (D&D 5e, Ordem Paranormal aprox., Tormenta20 aprox., Linear, Marcos) · 3 📋 Regras em frase
  (modo "a cada N" ou "em níveis certos") · 4 🗓 **Linha do tempo** gerada (o que cada degrau dá, totais acumulados, colunas e, opcional,
  habilidades de uma classe) · 5 🔢 Colunas extras recolhidas, com atalhos (Prof D&D, dado que cresce, ataques por turno, NEX %, patente).

## Treino e pontos por habilidade
- Efeitos novos (aba ⚙️ do cartão): **💪 +Pontos de atributo**, **🎯 +Perícias**, **🎓 +Melhorias de treino** (`B.pts`, somam no `levelPoints`;
  combinam com "⏱ Vale" para valer a partir de um nível).
- Graus de treino (`profTiers`) ganharam **`nivelMin`** ("libera no nível"); no passo Perícias do jogador o grau bloqueado aparece "(a partir do N)"
  e, havendo regra de treino, um contador "🎓 Melhorias de treino: usadas/total" limita subir graus.

## Tags — `src/ui/tags-ui.js`
- Tag com ícone, categoria (dano, elemento, criatura, material, paranormal) e descrição; filtro por categoria.
- **Pacotes** com relações prontas: Elementos, Físico, Ordem Paranormal (ciclo Sangue▸Conhecimento▸Energia▸Morte), Criaturas, Jujutsu (F&M).
- **Matriz em grade** (linha ataca, coluna recebe): clique cicla ×2 → ×½ → ×0 → +1 dado → −1 dado → normal. Anotações num recolhível.
- As tags viram sugestão (`datalist`) no "tipo de dano" das técnicas.

## Criar habilidades e técnicas — `src/ui/habilidades-ux.js` + mudanças em `classes-origens.js`/`tecnicas-editor.js`
- **Barra única "Criar"** (classes, técnicas de classe, traços, bestiário): 🧙 Assistente (destacado) · ✨ Poder passivo · 📚 Modelos prontos ·
  ✏️ Em branco. A **biblioteca** tem busca e categorias com cartões (ícone, nome, descrição).
- **Cartão em 3 abas:** ✏️ O que é (descrição, requisitos, e um guia "Passiva ou Ação?") · ⚙️ Sempre ativo (efeitos) · 🪄 Ação na ficha.
  No topo, a **frase** do que a habilidade faz.
- **Editor de uso em passos numerados** (1 Tipo · 2 O que faz · 3 Custo e duração · 4 Regras de magia · 5 Texto) com **prévia do cartão e
  resumo ao lado**; vira uma coluna quando o painel é estreito (container query).

## Testado (navegador embutido, servidor sem cache 8795, conta temporária apagada)
Migração do perLevel → 2 regras; modelos D&D e Ordem (frases, treino 2/4 nos NEX 7/14, Veterano 7 / Expert 14); atributo fixo somando;
habilidade com +2 atributo/+1 treino; passo Perícias com contador e grau bloqueado; pacotes de tags (10 tags, 8 relações) e grade 10×10;
biblioteca (58 modelos, busca "fogo"); cartão em abas; editor em 5 passos. Sem erros novos no console.

## Pendências
- Tela de subir de nível ainda não deixa distribuir os pontos ali mesmo (usa os passos de criação).
- O construtor de tiers (aba 🌀 Técnicas, técnica autoral do jogador) não foi redesenhado.
