---
name: greenfinance-paginas
description: detalhamento página a página do GreenFinance (rotas, seções da UI, dados lidos/escritos e cálculos de cada tela)
tags: [proj/greenfinance, paginas, ui, referencia-tecnica]
updated: 2026-09-08
---

# GreenFinance — Detalhamento de Todas as Páginas

Mapa tela a tela do [[greenfinance]], derivado da leitura direta do código-fonte
(`src/App.tsx`, `src/pages/*`, `src/components/*`, `src/store/useStore.tsx`). Cada
seção descreve rota, propósito, blocos da interface, o que a página lê/escreve no
[[greenfinance-dados|store]] e os cálculos-chave. Para a engenharia interna ver
[[greenfinance-arquitetura]].

## Casca da aplicação (`src/App.tsx`)

- **Roteamento:** `HashRouter` (URLs `/#/rota`). Toda a árvore é embrulhada em
  `ErrorBoundary` → `StoreProvider` → `HashRouter` → `AppShell`.
- **Gate de onboarding:** se `state.settings.onboarded` for falso, `AppShell`
  renderiza **somente** `Onboarding` (nenhuma rota fica acessível antes disso).
- **Tema reativo:** um `useEffect` aplica `applyTheme(settings.theme)` a cada
  mudança; se o tema for `custom`, aplica a paleta do usuário via
  `buildCustomPalette(settings.customPalette)`.
- **Layout persistente:** `Sidebar` (desktop) à esquerda, conteúdo central com
  `md:max-w-3xl`, `BottomNavigation` (mobile) fixa embaixo e `ToastHost` global.

## Tabela de rotas

| Rota | Página (arquivo) | Função |
|---|---|---|
| `/` | `Dashboard.tsx` | Visão geral financeira e de investimentos |
| `/gastos` | `Expenses.tsx` | Lista e edição de transações |
| `/graficos` | `Charts.tsx` | Gráficos de gastos/fluxo e de investimentos |
| `/investimentos` | `Investments.tsx` | Explorador de mercado B3 + carteira |
| `/investimentos/:ticker` | `AssetAnalysis.tsx` | Análise de um ativo específico |
| `/carteira` | `Portfolio.tsx` | Carteira: ativos, rentabilidade e alocação |
| `/beneficios` | `Benefits.tsx` | Benefícios, cashback e conquistas |
| `/metas` | `Goals.tsx` | Metas financeiras |
| `/orcamento` | `Budget.tsx` | Limites por categoria |
| `/simulador` | `Simulator.tsx` | Projeção de patrimônio |
| `/conectar` | `ConnectBank.tsx` | Importar extrato + Open Finance (Pluggy) |
| `/configuracoes` | `Settings.tsx` | Preferências, temas e backup |
| `/mais` | `More.tsx` | Índice de todas as ferramentas |
| *(condicional)* | `Onboarding.tsx` | Primeiro acesso (fora do `<Routes>`) |

---

## 1. Onboarding (`Onboarding.tsx`)
Tela de primeiro acesso, exibida enquanto `settings.onboarded === false`.
- **Coleta:** renda principal, dia de pagamento e descrição da meta principal.
- **Escreve:** `updateSettings({ mainIncome, payDay, mainGoalDescription, onboarded: true })`.
- Ao concluir, o gate cai e o app passa a renderizar as rotas normais.

## 2. Dashboard (`/`, `Dashboard.tsx` — 347 linhas)
Página inicial com saudação dinâmica (`greeting()` por horário → "Bom dia/tarde/noite 👋").
- **Blocos:** cartão de saldo/visão geral (considera **todos** os lançamentos, sem
  recorte por mês); receita cai para `settings.mainIncome` quando não há entradas
  registradas; resumo de gastos do mês; valor da carteira ao vivo; mini-gráficos.
- **Lê do store:** `transactions`, `settings`, `portfolio`.
- **Chamada externa:** `getMultipleQuotes()` (brapi.dev) para precificar a carteira e
  montar os gráficos de investimento do topo.
- **Insights:** usa `src/utils/insights.ts` (`generateInsights`, `financialSummary`).

## 3. Gastos (`/gastos`, `Expenses.tsx` — 163 linhas)
Lista das transações registradas, agrupadas por data.
- **Componentes:** `TransactionList` (render + swipe/editar/excluir) e o
  `TransactionForm` para lançamento rápido.
- **Estado vazio:** card "Você ainda não possui gastos registrados."
- **Escreve:** via store `addTransaction`, `updateTransaction`, `deleteTransaction`,
  `restoreTransaction` (desfazer exclusão via toast).

## 4. Gráficos / Análise (`/graficos`, `Charts.tsx` — 485 linhas)
Duas seções alternáveis (`SECTION_OPTIONS`): **"Gastos & Fluxo"** e **"Investimentos"**.
- **Períodos (`PERIODS`):** Mês, 3M, 6M, 12M.
- **Gastos & Fluxo:** `PieChart` por categoria, `AreaChart` de série diária,
  `BarChart` de comparação mensal e `AreaChart` de evolução de saldo.
- **Investimentos:** `PieChart` de alocação, `BarChart` de rentabilidade por ativo;
  estado vazio "Nenhum ativo na carteira" apontando para a Carteira.
- **Chamada externa:** `getMultipleQuotes()` para os gráficos de investimento.
- **Biblioteca:** Recharts.

## 5. Investimentos (`/investimentos`, `Investments.tsx` — 561 linhas)
Explorador de mercado da B3 + resumo da carteira.
- **Serviços:** `getQuote`, `getMultipleQuotes`, `getQuotesBatch`, `listQuotes`
  (brapi.dev). A taxonomia de setores é buscada **uma vez** (independente dos
  filtros ativos) para a lista de chips de setor nunca encolher ao filtrar.
- **Fallback:** sem token/offline/rate-limited, cai para uma lista curada pequena.
- **Filtros:** tipo (ação/FII/ETF), setor e ordenação.
- Clicar num ativo navega para `/investimentos/:ticker` (AssetAnalysis).

## 6. Análise de Ativo (`/investimentos/:ticker`, `AssetAnalysis.tsx` — 212 linhas)
Página de detalhe de um único ticker (parâmetro de rota `:ticker`).
- **Serviços:** `getQuote`, `computePeriodPerformance`, `computeVolatility`.
- **Cálculos:** histórico recortado por janela para o gráfico; retorno de 6 meses
  **anualizado** (composto 2×) e limitado a uma banda sã para não projetar números
  absurdos a partir de um semestre atípico; medida de volatilidade.

## 7. Carteira (`/carteira`, `Portfolio.tsx` — 562 linhas)
Gestão dos ativos do usuário e rentabilidade.
- **Escreve:** `addPortfolioAsset`, `updatePortfolioAsset`, `deletePortfolioAsset`.
- **Cálculos:** alocação por classe (Ações / FIIs / ETFs); rentabilidade não
  realizada por ativo (ordenada) para o gráfico de barras; melhor/pior ativo;
  **taxa de crescimento anualizada** implícita na série de ~6 meses (~21 pregões/mês)
  para projetar valor futuro — cai para 8% a.a. conservador sem histórico suficiente.
- **Serviços:** `getMultipleQuotes`, `getQuote`. Ativos sem cotação na brapi (renda
  fixa, fundos, Tesouro) usam `marketValue` informado pelo banco como fallback.

## 8. Benefícios (`/beneficios`, `Benefits.tsx` — 641 linhas, a maior página)
Três subsistemas numa só tela — título "Benefícios 🎁 · O que você recebe, acumula e conquista":
- **Benefícios:** cadastro de VA, VR, Transporte, Saúde, PLR, Outro (tipo, valor,
  frequência mensal/único/anual, `resetDay`, saldo atual de cartão recarregável e
  operadora — Alelo/VR/Caju/Flash/Sodexo). Store: `addBenefit`/`updateBenefit`/`deleteBenefit`.
  Resumo via `summarizeBenefits` (`src/utils/benefits.ts`).
- **Cashback / Pontos / Milhas:** programas com unidade `R$`/`pontos`/`milhas` e
  lançamentos de crédito. Store: `addCashbackProgram`, `deleteCashbackProgram`,
  `addCashbackEntry`, `deleteCashbackEntry`; total via `cashbackTotal`.
- **Conquistas (gamificação):** `computeAchievements(state)` calcula badges em runtime;
  `computeConqueredSavings(state, portfolioValue)` estima "economia conquistada". As
  conquistas desbloqueadas são persistidas (`markAchievementsUnlocked`) para não
  re-notificar a cada load; usa `getMultipleQuotes` para valorar a carteira.

## 9. Metas (`/metas`, `Goals.tsx` — 244 linhas)
Objetivos financeiros com alvo, valor guardado e prazo opcional.
- **Ordenação:** prazo mais próximo primeiro; metas sem prazo por último.
- **Escreve:** `addGoal`, `updateGoal`, `deleteGoal`. Estado vazio "Nenhuma meta criada ainda".

## 10. Orçamento (`/orcamento`, `Budget.tsx` — 171 linhas)
Limites mensais por categoria.
- **Ordenação inteligente:** categorias com orçamento primeiro (pior % de uso no
  topo), depois as sem limite — mantém no topo o que precisa de atenção.
- **Escreve:** `setBudget(categoryId, limit)`, `deleteBudget`.
- Cor/estado de saúde via `computeHealthStatus(percentUsed, trendWorse)` (`utils/finance.ts`).

## 11. Simulador (`/simulador`, `Simulator.tsx` — 277 linhas)
Projeção de evolução patrimonial com juros compostos.
- **Perfis (presets):** botões de perfil que preenchem o retorno estimado (% a.a.);
  taxa padrão inicial 13% a.a. e inflação padrão 4,5% a.a.
- **Entradas:** investimento inicial, aporte mensal, período (meses), retorno % a.a.,
  meta opcional e toggle "valor real" (desconta inflação → poder de compra).
- **Cálculo:** taxa mensal = `(1+rateYear/100)^(1/12) − 1`; inflação mensal análoga
  quando `realValue` ligado. Saídas: total investido, rendimento, patrimônio final e
  renda mensal ao final; `ReferenceLine` de meta no gráfico e mês estimado para atingi-la.
- Sugere ativos que combinam com o perfil selecionado.

## 12. Conectar Banco (`/conectar`, `ConnectBank.tsx` — 565 linhas)
Duas vias de entrada de lançamentos:
- **Importação de extrato (100% no navegador):** OFX, CSV e PDF de fatura. O parser
  (`utils/statementImport.ts` + `utils/pdfExtract.ts`) gera uma **tela de revisão**
  antes de confirmar; grava via `addTransactionsBulk` (deduplica por `fitid` do OFX ou
  por chave composta `data|valor|tipo|descrição`).
- **Open Finance (Pluggy):** carrega o SDK `window.PluggyConnect`, pede um
  `connectToken` ao Cloudflare Worker (`isBankSyncConfigured`/`createConnectToken` em
  `services/bankApi.ts`, só ativo se `VITE_BANK_PROXY_URL` estiver setado), abre o
  widget (produção: `includeSandbox:false`) e, no sucesso, `fetchBankData(itemId)`
  traz contas+saldos (`setBankAccounts`), cartões/histórico (reaproveita a tela de
  revisão) e investimentos (`addOrUpdatePortfolioAssets`, com `marketValue` de fallback).

## 13. Configurações (`/configuracoes`, `Settings.tsx` — 322 linhas)
Preferências, aparência e backup.
- **Perfil:** renda, dia de pagamento, fontes de renda extra (`updateSettings`).
- **Temas:** 9 presets (ver [[greenfinance-arquitetura]]) + modal "Paleta
  personalizada" (bg/primary/accent → tema `custom`).
- **Dados:** exportar/importar JSON e CSV (`utils/exportImport.ts` → `importData`),
  "Limpar dados de demonstração" (`clearDemoData`, remove ids `demo-*`) e "Apagar
  todos os dados" (`resetAll`, limpa `localStorage`).

## 14. Mais (`/mais`, `More.tsx` — 38 linhas)
Menu-índice mobile ("Todas as ferramentas do GreenFinance") com atalhos para todas
as telas que não cabem na `BottomNavigation`.

---

## Componentes compartilhados (`src/components/`)
- **Header** — título + subtítulo padrão no topo de cada página.
- **Sidebar** — navegação desktop; **BottomNavigation** — navegação mobile fixa.
- **TransactionForm** — formulário de lançamento rápido (usa `AmountInput`).
- **TransactionList** — lista agrupada por data com editar/excluir/desfazer.
- **CategoryManager** — CRUD de categorias personalizadas.
- **RecurringRulesManager** — regras de transação recorrente (ver store abaixo).
- **TickerAutocomplete** — autocomplete de códigos B3 (usa `data/b3-tickers.json`).
- **AmountInput** — input monetário com máscara (`parseAmountInput`).
- **ChartKit** — wrappers de Recharts reutilizados pelas telas de gráfico.
- **Primitives** — `Modal`, `StatTile`, `ToastHost`/`pushToast`, botões etc.
- **ErrorBoundary** — captura erros de render e evita tela branca total.

## Recorrências automáticas (regra de negócio importante)
`generateDueRecurring()` roda **uma vez por load**: para cada `RecurringRule` ativa,
gera as transações dos meses vencidos ainda não gerados, **no máximo 2 meses de
catch-up por regra por execução** (evita inundar o histórico após ausência longa),
nunca antes da criação da regra, respeitando `dayOfMonth` (ajustado ao último dia do
mês quando necessário). Marca `lastGeneratedMonth`.

## Onde os dados são persistidos
Tudo no `localStorage` sob a chave **`greenfinance:v1`** (debounce de 400 ms), com
backup do blob corrompido em `greenfinance:v1:corrupted-backup` e migração de schema
via `utils/stateSchema.ts` (`CURRENT_SCHEMA_VERSION`, `validateAndMigrate`). Detalhes
de forma do estado e integrações em [[greenfinance-dados]].
