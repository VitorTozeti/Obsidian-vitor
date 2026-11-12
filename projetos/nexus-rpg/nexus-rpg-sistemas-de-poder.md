---
name: nexus-rpg-sistemas-de-poder
description: 2026-10-20 — sistemas de poder (formas desbloqueáveis por ritual, destruíveis com herança, combinações A+B, cópia de técnicas, aprende N, equipa uma por vez), usos limitados e editor de técnica em blocos-frase; modelos Dez Sombras (Megumi), Cópia e Rika (Yuta), Seda e Brasões (Hornet), Elementos, Grimório, Posturas
tags: [projeto, proj/nexus-rpg, tecnicas, magias, ux, poderes]
updated: 2026-10-20
---

# Nexus RPG — Sistemas de poder e editor em blocos (2026-10-20)

Parte do [[nexus-rpg]]. O Vitor pediu que magias, técnicas e habilidades de classe ficassem mais fáceis de editar ("até eu fico confuso").
Também pediu um jeito de montar o **sistema de magias** do próprio RPG, livre o bastante para criar as 10 sombras do Megumi, as técnicas
do Yuta ou a Hornet de Silksong. Continua [[nexus-rpg-progressao-tags-criacao]].

## Editor de técnica em blocos — `src/ui/blocos-uso.js`
- Substitui os 5 passos como **padrão** da aba 🪄 Ação na ficha. O editor antigo continua no botão "🔧 Modo detalhado", que tem "🧱 Voltar".
- A técnica é uma lista de **blocos em frase**: o topo traz "✨ Usa e pronto / ⏻ Liga-desliga · custa [3] [Mana]".
- Blocos que dá para adicionar: 💥 Dano · 💚 Cura · 🔋 Recurso · 🌀 Condição · 🎲 Teste · 🎯 Ataque · 📏 Alcance/área · 🐺 Invocação ·
  🛡 Bônus enquanto ligada · ⏳ Duração · 🔁 Usos · 📘 Regras de magia · 📜 Texto.
- O **tipo** (cor, ícone, verbo do botão) é **deduzido** dos blocos, sem precisar escolher antes: invocação > dano > cura > debuff > buff > utilidade.
- **Receitas** para começar do zero: Ataque, Explosão, Cura, Buff, Debuff, Invocação, Golpe que carrega, Ferramenta.
- Os dados continuam em `ab.uso`. `us.blocos` guarda só a ordem; técnicas antigas deduzem os blocos do que já está preenchido.
- Dano e cura usam a mesma fórmula principal, então um esconde o outro. Recurso extra entra como bloco 🔋.

## Usos limitados (qualquer técnica)
- `ab.uso.usos = {max:'3', recarga:'longo'|'curto'|'cena'|'nunca'}`. O gasto fica em `d.usos[abId]`.
- O botão mostra "· 5/8" e desabilita quando zera. Os botões de descanso da ficha recarregam (`recarregarUsos`):
  - descanso longo volta longo, curto e cena;
  - descanso curto volta curto e cena.

## Sistemas de poder — `src/data/poderes.js` (motor) + `src/ui/poderes-ui.js` (aba 🔮 Poderes + grimório)
- Estrutura: `sys.poderes[]` = {nome, ícone, cor, desc, recursoId, **modo**, escolherQtd, **copia**, copiaMax, todos, formas[], combos[]}.
- **Modo:**
  - `todas` — tem todas que desbloquear;
  - `escolher` — aprende N, por fórmula ("2 + piso(Nível / 2)");
  - `exclusiva` — equipa uma por vez (brasão, postura).
- **Forma** = habilidade normal (blocos + efeitos) com mais três campos:
  - `grupo`;
  - `perdivel` (pode ser destruída);
  - `desbloq.tipo`: `livre` · `ritual` (texto; alguém marca "✓ Conquistado" na ficha) · `forma` (depois de outra) · `perdida` (herança: libera quando outra for destruída).
- **Combinações** `{a, b, ab}`: aparecem sozinhas quando as duas formas estão ativas.
- **Cópia** (estilo Yuta): botão "📋 Copiar uma técnica" na ficha. Busca qualquer técnica usável do sistema (classes, origens, outros poderes) e guarda em `d.poder[id].copias`.
- **Quem recebe:**
  - efeito novo `poder` ("🔮 Concede um sistema de poder") em habilidade, escolha ou item;
  - atalho "Dar para classe/origem…", que cria a habilidade com o efeito;
  - ou marcar "Todo personagem tem".
- **Motor:** `fontesDePoder` entra no `gatherEffects` como fonte `tipo:'poder'`. Por isso efeitos, botões, concentração e invocações funcionam como qualquer técnica.
  - Estados: `formaEstado` → ativa / nivel / ritual / requer / perdida / escolher / guardada.
  - Estado do personagem: `d.poder[id] = {des, perd, esc, equip, copias}`.
- **Ficha:** bloco 🔮 no topo das Habilidades, um painel recolhível por sistema com:
  - recurso e contagem;
  - formas por grupo, cada uma com a ação do seu estado: ✓ Conquistado, 🎓 Aprender (respeita o limite), 🎽 Equipar, 💀 destruída / ↺ restaurar;
  - combinações;
  - cópias.

## Modelos prontos (um clique cria recurso, formas, desbloqueios e combinações)
- **Dez Sombras (Megumi):**
  - Energia Amaldiçoada;
  - Cães Divinos livres; Nue, Sapo, Serpente, Coelhos, Elefante, Cervo, Boi e Tigre por ritual e nível;
  - Cão Divino: Totalidade como herança quando os Cães são destruídos;
  - Mahoraga por ritual no nível 15;
  - Expansão de Domínio 1×/descanso;
  - 2 fusões.
- **Cópia e Rika (Yuta):**
  - reserva grande de Energia Amaldiçoada;
  - Rika parcial (liga/desliga) e completa (ritual, 1×/descanso);
  - Energia Reversa, Lâmina reforçada, Fala Amaldiçoada (exemplo de cópia) e cópia ilimitada.
- **Seda e Brasões (Hornet), dois sistemas:**
  - Agulha e Seda: o golpe dá +1 Seda; Atar gasta 9 e cura; habilidades de seda; ferramentas com usos (Alfinetes 8×, Bomba 2×);
  - Brasões: exclusiva, Caçador / Ceifador / Errante / Besta.
- **Elementos:** aprende 2 + Nível/4 entre Fogo, Água, Terra e Ar; 6 fusões (Vapor, Lava, Tempestade, Areia, Tornado, Lama).
- **Grimório arcano:** aprende 2 + Nível/2 entre 10 magias da biblioteca, em círculos.
- **Posturas:** exclusiva, Tigre / Tartaruga / Garça / Dragão.
- Os textos são próprios (inspirados, não copiados) e os números são aproximados.

## Testado (navegador embutido, servidor sem cache 8795, conta temporária apagada)
- Os 6 modelos criaram 7 sistemas; o recurso é reaproveitado pelo nome.
- Desbloqueio por ritual libera a fusão. Destruir os Cães libera a Totalidade.
- Elementos: aprender Fogo + Água libera Vapor, e o 3º fica bloqueado no limite.
- Brasão equipado soma +1 ataque e +1 dano.
- Invocar Cães gasta 2 EA. Alfinetes vão de 8/8 a 0/8 (botão desabilita) e voltam no descanso longo.
- Atar zera a Seda e o golpe soma +1.
- Cópia adiciona a técnica.
- Editor em blocos: a receita Explosão monta 3 blocos; +Condição e +Usos entram; tirar Dano muda o tipo para debuff.
- Sem erros novos no console.

## Armadilhas encontradas
- A classe `.blk` já existe no CSS da ficha (`position:absolute`) e escondia os blocos. Por isso as classes do editor são `.tbk`.
- `.btn.mini` tem `width:38px` fixo. Botões com texto precisam de `width:auto` (feito em `.graf-ac` e `.blk-corpo>.btn`).

## Pendências
- Não há trava de "trocar brasão só no descanso": a troca é livre e a regra fica no texto.
- Cópia não exige Rika ligada (fica a critério da mesa).
- O livro de regras ainda não tem capítulo de sistemas de poder.
