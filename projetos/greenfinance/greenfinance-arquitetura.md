---
name: greenfinance-arquitetura
description: arquitetura local-first, gerenciamento de estado no useStore, conciliação bancária e guia de evolução do GreenFinance
tags: [proj/greenfinance, arquitetura, react, local-first, dev-guide]
updated: 2026-09-07
---

# GreenFinance — Arquitetura e Guia de Atualizações Futuras

Documento técnico detalhado cobrindo a engenharia do [[greenfinance]], seu modelo de persistência *local-first*, o pipeline de processamento de extratos e orientações para o desenvolvimento de novas funcionalidades.

---

## 1. Intuito e Filosofia de Design

A maioria dos aplicativos de finanças pessoais impõe taxas recorrentes ou exige que o usuário envie credenciais e históricos de gastos para servidores corporativos na nuvem. O **GreenFinance** foi concebido como uma alternativa de **soberania financeira individual**:

1. **Privacidade Absoluta (*Local-First*):** 100% dos dados financeiros (saldos, transações, investimentos e regras) residem exclusivamente no navegador do usuário (`localStorage`).
2. **PWA Mobile-First:** instalável em smartphones iOS/Android e desktops como aplicativo nativo via `vite-plugin-pwa`, funcionando offline para consultas e lançamentos manuais.
3. **Open Finance Seguro e Sem Custo:** em vez de armazenar senhas bancárias em um banco de dados central, utiliza um proxy serverless leve (Cloudflare Worker) apenas para assinar requisições com a Pluggy, sem reter nenhuma transação ou dado sensível em servidor.

---

## 2. Funcionamento Interno e Arquitetura

### Gerenciamento de Estado Centralizado (`src/store/useStore.tsx`)
A aplicação é guiada por um React Context único que expõe o estado global e métodos mutadores para toda a árvore de componentes:
- **Persistência Atômica:** a cada modificação disparada por uma ação (`addTransaction`, `updateBudget`, `setInvestments`), o estado completo é validado e sincronizado com o `localStorage`.
- **Sanitização e Schema (`src/utils/stateSchema.ts`):** ao inicializar, o store valida os dados recuperados do disco do navegador com um schema de fallback, garantindo que versões antigas de dados não causem quebras de tela por campos nulos (`undefined`).

### Pipeline de Importação e Conciliação de Extratos
O GreenFinance possui um dos motores de conciliação mais flexíveis executados puramente no cliente:
1. **Extratos OFX (`statementImport.ts`):** parser para extratos bancários padrão SGML/XML bancário brasileiro, extraindo data do lançamento, `FITID` (ID único para evitar transações duplicadas), descrição e valor.
2. **Arquivos CSV (`statementImport.ts`):** detecção heurística de delimitadores (vírgula, ponto-e-vírgula) e mapeamento dinâmico de colunas.
3. **Faturas de Cartão em PDF (`src/utils/pdfExtract.ts`):** utiliza `pdfjs-dist` no próprio navegador para ler o texto dos PDFs de fatura (Nubank, Itaú, Inter, etc.), isolando padrões de linhas de compra com data e valor monetário.
4. **Categorização Automática:** regras heurísticas baseadas em palavras-chave que atribuem categorias instantâneas (ex.: "Uber" → Transporte; "iFood" → Alimentação).

### Integração de Mercado e B3 (`src/services/marketApi.ts`)
- **Consulta de Cotações:** integrado à brapi.dev para obter cotações atualizadas e indicadores fundamentalistas de ações, FIIs e ETFs brasileiros.
- **Cache Local com TTL:** cotações consultadas recebem cache em memória para economizar chamadas de API e evitar atingir os limites da cota gratuita da brapi.dev.
- **Dicionário Estático (`src/data/b3-tickers.json`):** lista offline para preenchimento automático (*autocomplete*) ultra-rápido de códigos da B3 na interface de compra.

---

## 3. Guia Prático para Atualizações Futuras

### A. Como Adicionar uma Nova Página ou Rota
1. Crie a página em `src/pages/MinhaNovaTela.tsx`.
2. Em `src/App.tsx`:
   - Importe a nova página.
   - Adicione a rota dentro de `<Routes>`:
     ```tsx
     <Route path="/minha-rota" element={<MinhaNovaTela />} />
     ```
3. Atualize a navegação para que o usuário possa acessar:
   - Para menus desktop: `src/components/Sidebar.tsx`.
   - Para menu mobile: `src/components/BottomNavigation.tsx` ou `src/pages/More.tsx`.

### B. Como Alterar ou Estender o Modelo de Dados
Caso seja necessário criar um novo campo (ex.: adicionar campo `tag` em transações):
1. **Atualizar os Tipos (`src/types/index.ts`):**
   ```typescript
   export interface Transaction {
     // campos existentes...
     tags?: string[];
   }
   ```
2. **Atualizar o Schema e Defaults (`src/utils/stateSchema.ts` e `src/data/defaults.ts`):**
   - Adicione os valores padrão para transações novas e garanta que na função de sanitização de importação `sanitizeState()` o campo receba um array vazio `[]` caso seja ausente em registros antigos.
3. **Atualizar a Interface de Formulário (`src/components/TransactionForm.tsx`):**
   - Adicione o input correspondente e vincule ao método `addTransaction()` do store.

### C. Como Adicionar um Novo Parser de PDF Bancário
1. Em `src/utils/pdfExtract.ts`, observe os padrões de expressão regular existentes para bancos específicos.
2. Adicione uma nova função de expressão regular capturando a data, descrição e valor conforme a formatação do extrato do novo banco.
3. Conecte no seletor de layouts da tela `src/pages/ConnectBank.tsx`.

### D. Armadilhas e Cuidados Críticos
- **HashRouter para GitHub Pages:** nunca troque o `HashRouter` pelo `BrowserRouter`. Como o GitHub Pages não possui reescrita de rotas no servidor, qualquer recarregamento de página (`F5`) em uma rota como `/investimentos` retornaria erro 404 caso o `HashRouter` (`/#/investimentos`) não fosse utilizado.
- **Base Path do Vite (`vite.config.ts`):** o repositório é publicado sob a subpasta `/Vitor_finan-as/`. Qualquer importação de assets ou scripts estáticos deve respeitar o `base: '/Vitor_finan-as/'`.
- **LocalStorage Quota:** para backups e dados volumosos de extratos com muitos anos, oriente os usuários a utilizar a exportação JSON periódica em Configurações.
