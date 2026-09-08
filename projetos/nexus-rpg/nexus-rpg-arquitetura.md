---
name: nexus-rpg-arquitetura
description: funcionamento interno, motores de regras/dados, canvas de fichas e guia para futuras atualizações do Nexus RPG
tags: [proj/nexus-rpg, arquitetura, motores, dev-guide]
updated: 2026-09-07
---

# Nexus RPG — Arquitetura e Guia de Atualizações Futuras

Documento técnico aprofundado cobrindo o propósito de design, o funcionamento dos motores internos e as diretrizes práticas para manutenção e extensão do [[nexus-rpg]].

---

## 1. Intuito e Filosofia de Design

O **Nexus RPG** nasceu com uma premissa clara: **autonomia e soberania total do usuário**. Em vez de depender de plataformas fechadas na nuvem (que cobram assinaturas ou impõem sistemas de regras fixos), o objetivo do projeto é oferecer um construtor de RPGs de mesa universal com as seguintes características:

1. **Zero-Build & Zero-Install:** abrir o `index.html` em qualquer navegador funciona imediatamente. Não requer Node.js, compilação nem servidor HTTP local (opera nativamente via protocolo `file://`).
2. **Sistemas Livres:** o Mestre não é forçado a jogar D&D ou Tormenta; ele cria os atributos (FOR, AGI, Sanidade), recursos (Mana, Fadiga, Estresse), perícias e regras matemáticas do seu próprio universo.
3. **Privacidade e Isolamento:** nenhum dado sai da máquina do usuário. Contas e personagens são salvos no `localStorage`.

---

## 2. Funcionamento Interno e Ciclo de Vida

### Ciclo de Renderização Reativo
A aplicação utiliza um padrão reativo simplificado baseado em estado global:
- O estado mestre reside no objeto global `S` (definido em `src/core/state.js`).
- Modificações de estado chamam `render()`.
- O helper `h()` (`src/core/helpers.js`) monta nós DOM reais diretamente na memória e substitui o conteúdo do container `#root`.
- **Desfazer / Refazer (Undo/Redo):** o arquivo `src/core/history.js` mantém uma pilha de snapshots clonados do estado do canvas da ficha, permitindo reverter edições via `Ctrl+Z` e `Ctrl+Y`.

### Motor de Fórmulas (`src/core/formula-engine.js`)
O interpretador de expressões não utiliza `eval()` por questões de segurança e controle sintático. Ele é composto por:
1. **Tokenizer:** varre caracteres, identifica operadores (`+`, `-`, `*`, `/`, `%`, `>`, `<`, `>=`, `<=`, `==`, `!=`, `&&`, `||`, `e`, `ou`), números reais e casamentos gananciosos de variáveis.
   - *Regra de desempate:* uma função nativa (`FORM_FN`) vence um atributo com o mesmo prefixo somente se for sucedida imediatamente por `(`.
   - *Suporte a nomes complexos:* aceita variáveis com acentos e espaços (ex.: `Modificador de Força`, `Nível`).
2. **Parser Descendente Recursivo:** respeita a precedência formal matemática:
   - Nível 0: `ou` / `||`
   - Nível 1: `e` / `&&`
   - Nível 2: Comparações lógicas
   - Nível 3: Adição e Subtração
   - Nível 4: Multiplicação, Divisão e Módulo
   - Nível 5: Unários (`-`, `!`) e chamadas de funções

### Motor de Dados (`src/core/dice-engine.js`)
Interpreta expressões de rolagem e calcula resultados probabilísticos:
- Notação clássica `NdX` (ex.: `3d6`, `1d20`).
- Filtros de seleção:
  - `kh` / `kl`: manter os maiores (*keep highest*) ou menores (*keep lowest*).
  - `dh` / `dl`: descartar os maiores (*drop highest*) ou menores (*drop lowest*).
- Tags e bônus aplicados por escopos (`ataque`, `dano`, `pericia`, `defesa`).

### Módulo de Campanha do Mestre (`src/master/campaign/`)
Além da edição de regras, o Mestre conta com uma suíte tática:
- **Bestiário (`bestiary.js`):** cadastro de inimigos com statblocks dinâmicos gerados a partir dos atributos do sistema e NPCs com cards de relacionamento.
- **Mapa Tático (`campaign-map.js`):** suporte a upload de imagem de mapa (convertida em DataURL), grid quadriculado configurável (tamanho em pixels e toggle) e tokens arrastáveis com percentuais relativos (`xPct`, `yPct`) para manter o alinhamento em diferentes tamanhos de tela.
- **Log de Dados (`campaign-dice.js`):** histórico das últimas 60 rolagens da mesa com data/hora e autor.

---

## 3. Guia Prático para Atualizações Futuras

### A. Como Adicionar Novas Funções Matemáticas
Para disponibilizar uma nova função nas fórmulas das fichas e das regras:
1. Abra `src/core/formula-engine.js`.
2. Adicione a função ao objeto `FORM_FN`:
   ```javascript
   const FORM_FN = {
     // funções existentes...
     dobro: (x) => x * 2,
     potencia: (base, exp) => Math.pow(base, exp),
   };
   ```
3. O tokenizer e o parser reconhecem automaticamente novas funções adicionadas a esse objeto sem necessidade de alterar o restante do fluxo.

### B. Como Adicionar um Novo Tipo de Bloco na Ficha
1. Em `src/master/master-pieces.js`, localize a lista de definições de blocos (`TIPOS_BLOCO`).
2. Defina o identificador, nome, ícone e propriedades padrão (largura, altura, cor, campos vinculados).
3. No renderizador de ficha em `src/player/player.js` (ou `src/master/campaign/dashboard.js`), adicione o case correspondente no switch de renderização de blocos para gerar o HTML do novo bloco.

### C. Como Adicionar uma Nova Aba de Regras no Mestre
1. Em `src/master/master-nav.js`, adicione a nova aba à lista de abas (`MESTRE_TABS`) com seu `id` e rótulo.
2. Em `src/master/master-pieces.js`, implemente a função que desenha a tela correspondente (ex.: `renderAbaMagias(sys)`).
3. Se a aba criar dados novos que precisem persistir no sistema, adicione os campos padrão na função `defaultSystem()` em `src/data/example-system.js` e preveja a sanitização para retrocompatibilidade.

### D. Armadilhas e Cuidados Críticos
- **Sem Módulos ES:** não use `import` ou `export`. Todo o código compartilha o escopo `window`.
- **Ordem dos `<script>` em `index.html`:** scripts do topo não enxergam variáveis dos scripts abaixo. Se um arquivo chamar uma função de outro, certifique-se de que ela foi carregada antes na tag `<script>`.
- **Tamanho do `localStorage`:** imagens embutidas no mapa tático ou fotos de personagens são salvas como base64. Imagens muito pesadas podem estourar a cota de ~5MB do navegador. Recomenda-se adicionar compressão no `readPhoto()` caso sejam incluídos mapas muito grandes.
