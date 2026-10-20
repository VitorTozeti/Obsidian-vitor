---
name: nexus-rpg-morte-movimento-assistentes
description: 2026-10-20 — regras gerais que faltavam após o teste aprofundado: morte e quedas (testes, contagem, vida negativa, resgates, cicatrizes), movimento e ações por turno, e assistentes de criação de técnica/magia, poder de classe/origem e modificação física
tags: [projeto, proj/nexus-rpg, regras, morte, movimento, tecnicas, classes, origens]
updated: 2026-10-20
---

# Nexus RPG — Morte, movimento e assistentes de criação (2026-10-20)

Parte do [[nexus-rpg]]. Pedido do Vitor depois de testar o sistema a fundo: faltavam **regras gerais**
(o que acontece quando o personagem morre e como salvá-lo, movimentação) e **métodos melhores** para criar
técnicas/magias e poderes de classe/origem, incluindo **modificações físicas**.
Commit `00c3c2e` no `The-One-System` (main). Ver [[nexus-rpg-dados]].

## Aba nova: ☠️ Morte & Movimento (grupo Fundação, depois de Regras)
`src/data/regras-gerais.js` (motor) + `src/ui/regras-gerais-ui.js` (editor e painéis da ficha) + `assets/css/regras.css`.

### Morte e quedas — `sys.morte`
- **Recurso que mata** (Vida) + **condição ao cair** (cria “Caído” ao ligar).
- **4 modos:** 🎲 testes contra a morte (dado, CD fórmula, N sucessos/falhas, máximo levanta com 1, 1 = 2 falhas, dano caído = falhas) ·
  ⏳ contagem de rodadas (“Morrendo”, fórmula tipo `1 + Vigor`) · 🩸 vida negativa (limite fórmula) · ☠️ morte instantânea.
- **Predefinições:** D&D 5e, Ordem Paranormal, Tormenta20, Mortal (OSR), Retorno pela morte (Re:Zero).
- **Estabilizar:** perícia + CD (aliado socorre). **Resgates** (botões na ficha): levanta com Vida (fórmula) · estabiliza · +sucesso · +rodadas,
  pagando um recurso (Ponto de sorte, Intervenção divina, Poção, Vontade de viver, Aguentar firme).
- **Cicatrizes:** tabela rolada (dado) toda vez que cai. **Ao morrer:** fica morto · retorna (enche tudo, conta `d.morte.mortes`) · Mestre decide.
- Ficha: `d.morte = {estado: ok|caido|estavel|morto, suc, fal, rodadas, neg, cicatrizes[], mortes}`; painel “💫 Caído” aparece no topo do
  bloco **Recursos**; gancho `morteAoMudar` em `setRes` (player.js), roda junto dos ⚡ Gatilhos.

### Movimento e ações — `sys.movimento`
- Unidade (m / quadrados / pés / zonas), **deslocamento base por fórmula**, tamanho do quadrado, corrida ×, terreno difícil ×, salto (fórmula).
- **Sobrecarga** (carga > máximo): não afeta / metade / −N / parado. **Condições** que dão ½, 0 ou −N (atalho cria Lento/Agarrado/Imobilizado).
- Característica numérica **“Deslocamento”** de traços soma no total; caído = parado.
- **Ações por turno** (Padrão, Movimento, Livre, Reação… com quantidade): bolinhas marcáveis + “↻ Novo turno” (`d.turno.usadas`).
- Predefinições: D&D 5e, Tormenta20/Ordem, Pontos de ação (PF2e), Narrativo. Aparece no topo do bloco **Características**.

## Assistentes de criação — `src/ui/assistentes.js`
Botões em Classes → Habilidades por nível, Classes → Técnicas e Origem → Traços físicos (`botoesAssistente`).
Sobreposição `assistenteOverlay()` chamada no `masterView` (formula-field.js); alvo guardado em `_AS` (variável do módulo).
- **🧙 Técnica/magia** (5 passos): efeito (6 tipos) → força (Leve/Moderada/Forte/Devastadora → dados por tipo) + cresce com nível →
  alcance/área (desenho) → teste de resistência, condição (cria rápidas: Lento, Cego, Envenenado, Em chamas…), duração, liga/desliga → nome e custo.
- **Pontos de poder** (prévia ao vivo com medidor): força×2 + distância 1 / área 2 + condição 2 + liga/desliga 1 + escala 2 + alvos extras − teste “metade” 1.
  Custo sugerido = pontos; nível sugerido = metade. Gera `ab.uso` no mesmo formato de [[nexus-rpg-magias-tecnicas]].
- **✨ Poder de classe/origem:** bônus passivo (atributo, recurso ×Nível, rolagem, +técnica) · resistência · sentido/movimento · **modificação física** ·
  poder ativo (pula para o assistente de técnica) · narrativo.
- **🧬 Modificações físicas (21):** asas, membranas, guelras, garras, presas, chifres, cauda, carapaça, pele de pedra, braços extras, olhos de predador,
  antenas, corpo grande/pequeno (muda `visual.tamanho`), pernas de corredor, membros elásticos, regeneração, ferrão venenoso, sangue de dragão,
  corpo etéreo, camuflagem. Cada uma = efeitos + **ataque natural usável** (vira técnica na ficha) + **lado ruim** opcional (marcado por padrão).
- Card “📐 Como criar técnicas, magias e poderes equilibrados” na aba nova resume a regra de bolso.

## Testado (navegador embutido, conta local temporária, apagada depois)
Vida a 0 → Caído + cicatriz; dano caído soma falhas → morto; testes até estável/morto; contagem com `1 + Vigor`; resgate levanta com 1;
“Trazer de volta”. Movimento 9 m → 7,5 m com carapaça → 3,8 m com Lento; bolinhas e novo turno. Assistente criou bola de fogo (11 pontos)
e 5 traços + 2 ataques naturais na origem. Sem erros de console do app.

## Pendências
- Capítulo automático dessas regras no 📕 Livro de regras.
- Inimigos do Bestiário/Combate usarem a mesma regra de morte e o deslocamento no mapa da Mesa.
- Bloco próprio de “Movimento” no estúdio da ficha (hoje vive dentro de Características/Recursos).
