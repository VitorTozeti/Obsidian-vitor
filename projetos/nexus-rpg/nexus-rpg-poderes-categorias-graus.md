---
name: nexus-rpg-poderes-categorias-graus
description: 2026-10-30 — refatoração dos poderes em 3 categorias (técnica inata única com graus de crescimento estilo Jujutsu/F&M, magia aprendível com círculos e elementos estilo Ordem Paranormal, outros) + escolha/sorteio da técnica inata na ficha; modelos Ilimitado (Gojo) e Rituais paranormais
tags: [projeto, proj/nexus-rpg, poderes, tecnicas, magias, refatoracao]
updated: 2026-10-30
---

# Nexus RPG — Poderes por categoria, graus e círculos (2026-10-30)

Parte do [[nexus-rpg]]; refatora [[nexus-rpg-sistemas-de-poder]]. Código em `The-One-System` (commit `25ec264`, em `main`).

## Pedido do Vitor
Separar o sistema de **poder / técnica / magia** das habilidades de classe e origem. Dois tipos de poder:
1. **Técnica inata única** (estilo F&M / Jujutsu): técnica do Gojo, técnica do Megumi… cada personagem tem uma, com **grau de crescimento**.
2. **Poderes que qualquer um aprende** (estilo Ordem Paranormal): um sistema grande de magias/rituais aberto a todos.

## Modelo de dados (`src/data/poderes.js`)
- `P.categoria`: `tecnica` · `magia` · `outro` (`PODER_CATEGORIAS`). Sistemas antigos são migrados no `sanitizePoderes`: `modo:'escolher'`→magia, `exclusiva`→outro, resto→tecnica.
- `P.graus=[{id,nome,desc,nivel}]` — graus de crescimento (técnica) ou círculos (magia); `nivel` = nível mínimo (fórmula).
- `P.grauAuto` — sobe sozinho pelo nível (padrão em magia); senão o grau fica em `d.poder[pid].grau`, avançado na ficha (treino), nunca acima do que o nível permite (`grauMaxPorNivel`).
- `P.elementos=[{id,nome,icone,cor}]`; cada forma tem `f.grau` (índice) e `f.elemento` (id).
- Novo estado de forma `'grau'` em `formaEstado` (forma acima do grau atual).
- **Técnica inata**: técnica com `todos:true` vira opção de escolha; o personagem guarda **uma** em `d.tecnicaInata` (`poderesDoPersonagem` só inclui essa). Técnica dada por efeito de classe/origem continua valendo direto.

## Mestre (aba 🔮, `src/ui/poderes-ui.js`)
- Cabeçalho "Poderes, técnicas e magia" com botões **+ Técnica inata / + Magia aprendível / + Outro poder**; modelos agrupados por categoria; abas ordenadas por categoria.
- Seção 1 ganhou "Que tipo de poder é". Nova seção 3 **Graus de crescimento / Círculos** (nome, nível mínimo, descrição, nº de formas; toggle "sobe sozinho") + **Elementos**.
- Cada forma tem seletor de grau/círculo e de elemento; formas agrupadas por grau.
- Modelos novos: **♾️ Ilimitado** (Gojo — Infinito, Azul, Vermelho, Energia Reversa, Roxo, Vazio Infinito em 5 graus) e **🕯 Rituais paranormais** (5 elementos Sangue/Morte/Conhecimento/Energia/Medo, 4 círculos níveis 1/4/8/13, PE). Dez Sombras ganhou 4 graus; Grimório virou magia aberta com círculos reais.

## Ficha (Jogador)
- Bloco **🌀 Técnica inata**: escolher ou **🎲 Sortear** entre as técnicas marcadas; "🔄 trocar técnica inata".
- Cada sistema mostra categoria + grau atual; **trilha de graus** com "⬆ Subir para…" (bloqueado pelo nível) e ↓; filtro por elemento; chip colorido do elemento em cada forma.
- CSS em `assets/css/poderes.css` (bloco 2026-10-30).

## Testado
Navegador embutido (render direto de `tabPoderes`/`grimorioInner`, sem conta): 9 modelos criam sem erro; nível 7 → Rituais 2º círculo aberto, 3º trancado (`grau`); Ilimitado com grau 2 dominado libera Infinito, Azul, Vermelho e Energia Reversa (Roxo/Domínio trancados); Dez Sombras fora da ficha quando a inata escolhida é Ilimitado; console sem erros.

## Pendências
- Sorteio com pesos/raridade de técnica inata; impedir duas fichas da mesma campanha com a mesma técnica única.
- Afinidade de elemento (bônus ao escolher um elemento, estilo Ordem).
