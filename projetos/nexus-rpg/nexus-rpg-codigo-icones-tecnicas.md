---
name: nexus-rpg-codigo-icones-tecnicas
description: 2026-10-15 — seletor de 670 ícones, valores de efeito como fórmula, editor de código no estilo do campo de fórmula, recursos especiais, técnicas/magias usáveis e liga/desliga, início rápido de item, layout mais largo
tags: [projeto, proj/nexus-rpg, ui, efeitos, codigo, tecnicas, itens, icones]
updated: 2026-10-15
---

# Nexus RPG — Ícones, código, técnicas e itens (2026-10-15)

Parte do [[nexus-rpg]]; continua [[nexus-rpg-editores-itens]] e [[nexus-rpg-classes-origens]]. Pedido do Vitor: UI ainda
incomodava, criar técnicas/itens era difícil, faltavam ícones e o "código" devia ser tão amigável quanto as fórmulas de
recurso (Vida), com técnicas/itens mexendo em recursos. Código em `The-One-System` (ver [[nexus-rpg-dados]]); **sem commit** ainda.

## Novidades
- **Seletor de ícones** (`src/ui/icon-picker.js`): botão que abre gaveta com ~670 emojis em 12 categorias, busca por nome, recentes
  (`localStorage nexus-icones-recentes`) e campo para colar qualquer emoji. Usado em itens, técnicas/habilidades, recursos, classes,
  origens, condições e efeito "recurso especial". Evita emojis ZWJ (a passada de SVG em `icones.js` quebraria).
- **Valor de efeito = número OU ƒ fórmula** (`master-pieces.js` + `example-system.js`: `efNum`, `efEmFormula`, `varsDoEfeito`): vale para
  atributo, rolagem, dados, resistência, capacidade, técnicas extras, característica numérica. Variáveis: Nível, atributos.
- **Editor de código novo** (`src/ui/codigo-editor.js`): realce de cores, autocomplete (`fx.` e nomes reais de recurso/atributo/perícia/tipo de dano),
  ⊞ Montar (comando guiado, condições, 10 receitas, variáveis, todos os comandos), diagnóstico em português (sintaxe, `fx.x` inexistente,
  nome errado com "usar …"), erro com número da linha e prévia automática em 3 níveis. API ganhou `fx.formula()`, `fx.novoRecurso()`,
  atalhos `fx.ataque/dano/defesa` e valores aceitam texto de fórmula. Nome desconhecido agora avisa (antes ignorava em silêncio).
- **Recursos especiais:** efeito `recursoNovo` (UI) ou `fx.novoRecurso(nome,max,{icone,cor,recarga})` cria uma barra na ficha enquanto a fonte
  (item equipado, técnica escolhida, código) valer; mesmo nome de recurso existente = soma no máximo. Entram em `ctx.allRes` (`granted:true`).
- **Técnicas/magias** (`src/ui/tecnicas-editor.js`): 22 modelos prontos (cura, escudo arcano, fúria, voo, reserva de poder…); aba "🪄 Usar na ficha":
  custo em recurso + efeito com dados num recurso (instantânea) ou **liga/desliga** (efeitos só valem ligada; `d.ativas`, `habLigada`).
  Botões na ficha (`habilidadesInner`). Ícone em toda habilidade/técnica.
- **Itens:** banner "Começar rápido" (arma, armadura, poção, acessório, recurso especial, código) para item vazio; chips de receita visíveis.
- **Correção importante:** efeito "rolagem em Defesa" agora **soma no valor de Defesa** (recurso `ehDefesa`, ou chamado Defesa/CA, ou definido por armadura).
- **Layout:** com o Sistema aberto os menus laterais viram só ícones (<1800px); bibliotecas prontas viram gaveta recolhível (`mdBib`); slots de equipamento foram para o fim da aba Itens.

## Notas de teste
Servidor `the-one-system` (porta 8794) faz cache dos scripts: use `fetch(url,{cache:'reload'})` em todos os scripts antes de recarregar.

## Livro de regras (PDF/.doc) — 2026-10-15
- Nova aba **📕 Livro de regras** (grupo Saída, `src/ui/livro.js`, dados em `sys.livro`): capa (título, subtítulo, autor, cor, imagem), sumário clicável,
  capítulos automáticos (regras gerais, atributos, recursos, perícias, classes, origens, itens, técnicas, condições, escolhas) que se atualizam com o sistema,
  capítulos livres, ▲▼ para reordenar, texto de abertura (`# ` subtítulo, `- ` lista) e **imagens** por capítulo (reduzidas a ~1100px, legenda e tamanho).
- Prévia em páginas A4 (iframe) nas visões **Jogadores** (sem código, sem fórmulas internas, sem capítulos "só Mestre") e **Mestre**.
- Exportar: **PDF** via impressão do navegador (iframe oculto → "Salvar como PDF", numeração de página por `@page`), **.doc** (HTML que abre no Word/LibreOffice/Google Docs) e **.html**.
- Pendente: reformar o editor da ficha do jogador (canvas de blocos) para ser mais editável/divertido.
