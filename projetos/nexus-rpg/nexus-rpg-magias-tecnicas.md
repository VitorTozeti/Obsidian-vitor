---
name: nexus-rpg-magias-tecnicas
description: 2026-10-16 — sistema de magias/técnicas por TIPO (cura, dano, buff, debuff, invocação, utilidade) com alcance/área, teste de resistência, condição, vários recursos, resultado na ficha e criaturas invocadas com cartão estilizado
tags: [projeto, proj/nexus-rpg, tecnicas, magias, invocacao, ui, ficha]
updated: 2026-10-16
---

# Nexus RPG — Magias e técnicas por tipo (2026-10-16)

Parte do [[nexus-rpg]]; evolui o "🪄 Usar na ficha" de [[nexus-rpg-codigo-icones-tecnicas]]. Pedido do Vitor: magias que
mexem em recursos, curam, dão buff, debuff em inimigos, disparo normal, área e invocações de criaturas **estilizadas**.
Código em `The-One-System` (ver [[nexus-rpg-dados]]).

## Modelo de dados (`ab.uso`, `sanitizarUsoHab` em `src/data/arquetipos.js`)
Campos novos (todos opcionais; fichas antigas continuam valendo — `tipo:''` é deduzido por `usoTipo`):
- `tipo`: `cura` · `dano` · `buff` · `debuff` · `invocacao` · `utilidade` → cor/ícone do cartão e campos do editor.
- `aplicaEm`: `eu` (fórmula mexe no **meu** recurso `alvoId`) ou `alvo` (rola e mostra o número: dano no inimigo, cura no aliado). Dano → `alvo` por padrão.
- `alcance` (`si`/`toque`/`distancia`/`area`), `alvos`, `area:{forma: circulo|cone|linha|cubo|aura, tam}` (metros), `tipoDano`.
- `teste:{attr, cd (fórmula), sucesso: metade|nada|sem}` — teste de resistência do alvo.
- `condId` + `condEm` (`alvo`/`eu`) + `duracao` — buff/debuff. Condição **em mim** liga sozinha na ficha (`d.conditions` com `via:'tecnica'`) e sai ao desligar.
- `extras:[{resId, formula, quem: eu|alvo}]` — mexe em vários recursos (ex.: Drenar vida, Pacto de sangue Vida→Mana).
- `invoc:{nome, icone, cor, estilo, vida, defesa, ataque, dano, mov, qtd, duracao, desc}` — vida/defesa/qtd aceitam fórmula (Nível, atributos).
- Ficha: `d.invocacoes[]` (instâncias com vida atual) — `sanitizeDraft`/`initDraft` em `example-system.js`.

## Editor (Mestre) — `usoHabEditor` em `src/ui/tecnicas-editor.js`
Grade de 6 tipos coloridos → seções que mudam por tipo: 🎯 Alcance (com **desenho SVG da área**), dano/cura (em mim × no alvo, média),
🎲 teste, 🌀 condição + duração, 🔗 outros recursos, 🐺 criatura (ícone, cor, 7 estilos, atributos, prévia ao vivo) e
"👁 Como aparece na ficha" (prévia do cartão). 

## Ficha (Jogador)
- `cartaoTecnica` substituiu o cartão em `habilidadesInner` (`player.js`): borda/gradiente da cor do tipo, chips (tipo, área, dano, teste, condição, duração), botão com verbo (Curar/Lançar/Invocar), brilho quando ligada.
- Ao usar: paga custo, rola, aplica em mim, e mostra **cartão de resultado** (`S.ui.usoUlt`: número grande, "metade se passar", condição, teste com CD calculada, área).
- **Invocações** (`invocacoesInner`, acima das habilidades): cartão por criatura com avatar, barra de vida, 🛡/⚔/💥/🦶, 🎲 Atacar (1d20+bônus e dano), ±1/±5, dispensar; estilos fera/espírito (flutua)/morto-vivo/elemental (brilho)/constructo/celestial/demoníaco; caída = cinza. Técnica liga/desliga com invocação remove as criaturas ao desligar.
- CSS novo: `assets/css/magias.css` (linkado no `index.html`).

## Modelos prontos (38)
Novos: Raio de gelo, Cone de chamas, Relâmpago em linha, Drenar vida, Bola de fogo (agora rola 6d6 + teste), Curar aliado à distância,
Círculo de cura, Pacto de sangue, Aura de coragem, Velocidade, Lentidão, Cegueira, Nuvem venenosa, Lobo espiritual, Levantar mortos,
Elemental de fogo, Familiar, Golem de pedra. Modelos que usam condição criam a condição no sistema se faltar (`_garanteCond`);
teste usa o primeiro atributo existente da lista (`_atrNome`).

## Testado
Navegador embutido, conta de teste local: Bola de fogo/Lobo/Drenar/Levantar mortos/Nuvem venenosa consumiram Mana certo,
Drenar curou Vida, Esqueletos ×2 criados, resultado com metade/CD/condição/área; sem erros no console.
Cache: o CSP (`connect-src 'none'`) bloqueia `fetch` — para recarregar scripts, abra a URL do arquivo e Ctrl+Shift+R.

## Pendências
- Aplicar condição/dano direto em fichas de inimigos do Bestiário/Combate (hoje o resultado é informativo para o Mestre).
- Invocações entrarem na iniciativa do combate.
