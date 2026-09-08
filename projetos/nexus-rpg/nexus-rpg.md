---
name: nexus-rpg
description: motor e construtor de sistemas de RPG de mesa 100% offline, com editor visual de fichas e modos Mestre e Jogador
tags: [projeto, proj/nexus-rpg, rpg, vanilla-js, offline]
updated: 2026-09-08
---

# Nexus RPG

Aplicação web **100% offline**, sem dependências externas, sem build e sem servidor, desenvolvida em JavaScript puro (DOM manipulado via helper `h()`). Executa diretamente via protocolo `file://` no navegador e persiste todas as contas, sistemas e personagens no `localStorage`.

O projeto oferece um ambiente integrado para RPGs de mesa dividido em dois perfis de uso: **Mestre** (criação completa de regras e desenho livre da ficha) e **Jogador** (criação guiada de personagens e ficha interativa).

## Estado atual (2026-09-08)

- **Localização dos dados:** consulte [[nexus-rpg-dados]] para repositório, estrutura de arquivos, chaves do `localStorage` e carregamento.
- **Núcleo modularizado:** transição concluída de arquivo monolítico único (`nexus-rpg-prototipo.html`) para estrutura desacoplada em `src/` (`auth/`, `core/`, `data/`, `ui/`, `master/`, `player/`).
- **Sistema de Contas Local:** isolamento por conta (login local) onde o tipo do personagem selecionado (Mestre ou Jogador) define o acesso às ferramentas.
- **Motor de Fórmulas e Dados:** interpretador de expressões matemáticas customizadas e rolador com suporte a modificadores, pools e tags dimensionais.
- **Editor de Fichas:** canvas visual de 860px com snap magnético, 21 tipos de blocos e personalização avançada de atributos.
- **Detalhamento por tela:** ver [[nexus-rpg-telas]] — auth, as 17 abas do Mestre, editor de fichas (21 blocos), suíte de campanha e modo Jogador, tela a tela.

## Modos de Operação

### 1. 🛠️ Modo Mestre — 17 Abas em 4 grupos
Abas organizadas em 4 grupos (Fundação, Personagem, Mundo & Regras, Saída); ver a tabela completa em [[nexus-rpg-telas]]. Ambiente para desenhar sistemas de RPG do zero ou adaptar cenários existentes:
- **Campanha & Regras:** definição de limites de nível/grau, orçamento de atributos, modo de atributo (valor direto vs. modificador com fórmula customizada `(V-10)/2`) e temas visuais (10 presets).
- **Progressão & Degraus:** tabelas de progressão lineares ou por classe com colunas configuráveis (Nível, NEX, Grau).
- **Atributos & Recursos:** criação de atributos (FOR, AGI, etc.) e recursos de barra (Vida, Mana) ou valor (Defesa), com fórmulas dependentes e regras de recarga (descanso curto/longo).
- **Perícias & Proficiência:** vínculo com atributos, regras de treinamento e 3 modos de proficiência (nenhum, multiplicador estilo D&D ou graus fixos estilo Ordem Paranormal).
- **Classes, Origens & Escolhas:** árvore de habilidades com pré-requisitos e pontos de escolha dinâmicos ("escolha N de M").
- **Inventário, Itens & Espaços:** sistema de carga máxima calculada, slots de equipamento e teto de sintonização.
- **Condições & Matriz de Tags:** estados cumulativos/compostos e matriz de interação direcional entre tags (ex.: tag Fogo atingindo tag Gelo gerando dano ampliado).
- **Técnicas Autorais:** construtor de feitiços/rituais/técnicas com alocação de orçamento de componentes e cálculo de custo em recursos.
- **Exportação / Importação:** backup e compartilhamento de regras completas em formato `.nexus` (JSON).

### 2. 🖼️ Editor Visual de Fichas
- **Canvas Livre:** área de design de 860px escalável para telas menores.
- **21 Tipos de Blocos:** 16 blocos dinâmicos ligados aos dados do sistema (atributos, recursos, inventário, armas, rolagens, etc.) e 5 blocos decorativos livres (texto, divisores, formas, imagens, painéis).
- **Ferramentas de Layout:** snap magnético com guias, painel de camadas, seleção múltipla por marquee, barra de ações rápidas, histórico com Undo/Redo e atalhos de teclado.
- **Estilização de Atributos:** formatos variados (caixas, círculos, hexágonos, escudos, losangos) e arranjos em grade, colmeia ou flor/roseta com 6 presets temáticos prontos.

### 3. 🎲 Modo Jogador — Wizard & Ficha
- **Assistente Passo a Passo:** geração guiada de personagem (distribuição de atributos, escolha de classe/origem e seleção condicional de talentos/subclasses disponíveis para o nível).
- **Ficha Dinâmica:** interface interativa de jogo que calcula defesas, bônus de ataque e rolagens diretamente a partir dos dados do Mestre.

## Arquitetura e Motores Internos

- **Motor de Fórmulas (`src/core/formula-engine.js`):** tokenizer e avaliador recursivo próprio. Suporta variáveis com espaços/acentos, operadores aritméticos/lógicos, operadores de comparação e funções matemáticas (`min`, `max`, `round`, `floor`, `ceil`, `abs`, `modulo`, `if/se`).
- **Motor de Dados (`src/core/dice-engine.js`):** interpretação de notações `NdX`, filtros de manter/descartar maiores ou menores (`kh`, `kl`, `dh`, `dl`), pools de dados e vantagens/desvantagens contextuais.
- **Motor de Efeitos:** consolida modificadores de atributos, perícias e rolagens a partir de classes, itens equipados e condições ativas.
- **Migração de Schemas:** versionamento interno (`SCHEMA = 10`) com rotinas automáticas de migração retrocompatíveis desde o schema 6.

## Backlog e Próximos Passos

1. **Marketplace / Compartilhamento de Sistemas:** biblioteca centralizada para publicação e download de sistemas criados pela comunidade.
2. **Modo Online em Tempo Real:** sincronização entre dispositivos via WebSocket e links de convite (substituindo a troca manual de arquivos `.nexus`).
3. **Módulo Tático de Combate:** rastreador de ordem de iniciativa integrado ao mapa/tokens e rolagens automáticas de turno.

## Notas detalhadas

- [[nexus-rpg-telas]] — detalhamento tela a tela (auth, 17 abas do Mestre, editor de fichas com 21 blocos, campanha e modo Jogador, atalhos)
- [[nexus-rpg-dados]] — onde os dados vivem (repositório real, estrutura de scripts, chaves do LocalStorage e schema)
- [[nexus-rpg-arquitetura]] — funcionamento interno, motores de regras/dados, canvas de fichas e guia para futuras atualizações
