---
name: nexus-rpg-mesa-tokens
description: rodada 2026-10-14 do Nexus RPG — editor de mapas antigo aposentado e substituído por Mesa simples (imagem de mapa salva + tokens com foto, categorias, tokens próprios e anel de condição), atributos/perícias de criação rápida com biblioteca de perícias prontas e correção do "pulo para o topo" do render()
tags: [projeto, proj/nexus-rpg, mapas, tokens, ux, atributos, pericias]
updated: 2026-10-14
---

# Nexus RPG — Mesa (mapa + tokens), atributos/perícias rápidos e fim do "pulo pro topo" (2026-10-14)

Parte do [[nexus-rpg]]. Pedido do Vitor: facilitar a criação de atributos, ter perícias pré-prontas,
parar de ser jogado para o topo a cada alteração e **trocar a parte do mapa** por algo simples.
Código em `The-One-System` (ver [[nexus-rpg-dados]]). **Substitui** o editor de [[nexus-rpg-mapas-geradores]]
e o "mapa 100% editável" da [[nexus-rpg-v2-sistema-mapa-campanha]] (estes ficam como histórico).

## 1. Página não pula mais para o topo
- Causa: `render()` esvazia `#root` e reconstrói tudo; o documento encolhe e o navegador zera a rolagem.
- Correção em `src/core/state.js`: `render()` guarda `scrollX/Y`, segura a altura antiga do `#root`
  durante a reconstrução, e restaura rolagem **e foco** (campo + seleção de texto) quando a "tela"
  é a mesma (`chaveDaTela()` = conta/personagem/view/tab/step/grupo). Mudou de tela → vai ao topo como antes.
- Verificado no navegador: adicionar atributo/perícia com a página rolada manteve `scrollY`.

## 2. Atributos — criação rápida (`src/ui/atributos-pericias.js`)
- Campo "digite o nome + **Enter**" que continua focado para o próximo; nomes únicos (as fórmulas usam o nome).
- **Conjuntos prontos** (D&D 6, Ordem 5, Fantasia 5, Investigação 4, Sobrevivência 4, Narrativo 3) — só entram os que faltam.
- Sugestões em chips que somem ao serem usadas; sigla automática; campo `desc` (descrição curta); setas ▲▼ para ordenar;
  remover com **Desfazer** (toast) e "Limpar todos"; resumo "o jogador distribui X pontos…".

## 3. Perícias — biblioteca de perícias prontas
- 6 grupos / **41 perícias**: Exploração (Percepção, Investigação, Furtividade, Sobrevivência, Navegação, Prontidão),
  Social (Persuasão, Enganação, Intimidação, Intuição, Atuação, Liderança, Diplomacia), Físicas (Atletismo, Acrobacia,
  Ladinagem, Cavalgar, Pilotagem, Fortitude, Reflexo, Vontade), Combate (Luta, Pontaria, Defesa, Tática),
  Conhecimento (Medicina, História, Arcanismo, Natureza, Religião, Ocultismo, Tecnologia, Política, Idiomas),
  Ofícios (Artesanato, Alquimia, Mecânica, Hacking, Adestramento, Disfarce, Culinária).
  As descrições das 4 listas do pedido original foram mantidas.
- Um clique adiciona e **liga ao atributo que mais combina** (procura por nome: Percepção→Sabedoria/Mente…); clique de novo remove (com Desfazer).
  "+ todas" por grupo, "Adicionar todas", filtro de busca, criação de perícia própria (nome + Enter).

## 4. Mesa: mapa + tokens (`src/master/campaign/mesa-mapa.js`, `assets/css/mapa.css`)
- **Removidos:** `campaign-map.js`, `map-editor.js`, `map-gen.js` (geradores, pincel, objetos vetoriais, camadas…).
  `nomeProc` (nomes procedurais) foi movido para `table-tools.js`.
- **Mapa** = imagem carregada (JPEG ≤2200 px, fica salva em `c.maps[]`) ou "quadro em branco"; vários mapas; trocar imagem
  (ou arrastar um arquivo sobre o mapa); zoom (roda/pinça), arrastar, enquadrar; **grade** opcional (tamanho da casa + ímã no centro).
  Mapas do editor antigo continuam abrindo: aparecem imagem, pintura (`terrain`) e locais; objetos/peças vetoriais ficam guardados mas não são exibidos (aviso no topo).
- **Tokens:** biblioteca por **categoria** — automáticas (Jogadores, Inimigos, NPCs, vindas de jogadores/bestiário, com a foto deles) e as do Mestre
  (padrão: Criaturas, Objetos, Marcadores; criar/renomear/excluir). Tokens prontos só-ícone + **tokens próprios** (nome, categoria, foto recortada
  em quadrado 256 px ou emoji, cor, tamanho). Editor do token: nome, foto, ícone, cor, tamanho, PV, marcas, ocultar/travar, duplicar, remover (Desfazer).
- **Anel de condição:** cada token ganha borda colorida por condição — do sistema (`sys.conditions`), padrão (12: Envenenado, Sangrando, Atordoado…)
  ou **criadas** (`c.tokenConds`). Várias condições dividem o anel em fatias. Vale para qualquer token (incl. jogadores).
- Arrastar/selecionar mexem só no DOM (sem `render()`): o mapa não pisca nem perde zoom. Teclas: Delete remove, Esc solta, setas empurram.
- **Tela dos jogadores** (`presentation.js`): desenha o mapa com a proporção da imagem, fotos dos tokens e o anel de condições; tokens ocultos continuam não indo.

## Dados novos (compatíveis com campanhas antigas — `sanitizeCampaign`)
`c.tokenCats[] {id,nome,ic}` · `c.tokenLib[] {id,name,cat,img,icon,color,size}` · `c.tokenConds[] {id,n,c,ic}` ·
`mapa.aspect` (largura/altura) · `token.conds[]` (chaves `sys:<id>` / `cus:<id>` / `std:<k>`) · `token.libId` · `sys.attributes[].desc`.

## Pendências / ideias
- Névoa de guerra, régua e gabaritos de magia (existiam no editor antigo) — reintroduzir como camadas simples se fizer falta.
- Mídia em base64 no `localStorage` (cota ~5 MB): considerar IndexedDB (item 1.5 do [[nexus-rpg-plano-melhorias]]).
- Testado só no navegador do preview (Chromium); sem testes automatizados.

Relacionado: [[nexus-rpg]] · [[nexus-rpg-telas]] · [[nexus-rpg-dados]] · [[nexus-rpg-arquitetura]]
