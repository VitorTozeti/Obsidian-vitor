---
name: greenfinance-dados
description: mapa de localização de dados, repositório, APIs, worker e armazenamento do GreenFinance
tags: [proj/greenfinance, dados, infra, integracao]
updated: 2026-09-08
---

# GreenFinance — Onde os Dados Vivem

Nota de localização técnica e dados de integração do projeto [[greenfinance]].

## Repositórios e Links

- **Repositório Local no Disco:** `C:\Users\Vitor\Desktop\projetos\greenfinance` (máquina original)
  - **Nesta máquina (v.tozeti):** `C:\Users\v.tozeti\Desktop\Vitor\teste\Vitor_finan-as`
- **Repositório GitHub:** `VitorTozeti/Vitor_finan-as` (`https://github.com/VitorTozeti/Vitor_finan-as`)
- **Deploy / URL de Produção:** `https://vitortozeti.github.io/Vitor_finan-as/`
- **Base path do Vite:** `/Vitor_finan-as/`

## Backend / Proxy Serverless

- **Cloudflare Worker URL:** `https://blue-bonus-47ec.vitortozeti.workers.dev`
- **Código-fonte do Worker:** `worker/worker.js` (mantido no repo como fonte de verdade e configurado no painel da Cloudflare).
- **Finalidade:** atuar como backend seguro para o Open Finance, guardando as credenciais da API do Pluggy e gerando `connectToken` para o widget frontend.

## Credenciais e Variáveis de Ambiente

> ⚠️ Apenas nomes de variáveis são listados aqui — segredos nunca são registrados no vault.

- **GitHub Actions Secrets** (em `Settings → Secrets and variables → Actions` do repo):
  - `VITE_BANK_PROXY_URL`: URL base do Cloudflare Worker (`https://blue-bonus-47ec.vitortozeti.workers.dev`).
  - `VITE_BRAPI_TOKEN`: (Opcional) Token para requisições com limites maiores na brapi.dev.
- **Cloudflare Worker Variables & Secrets** (no dashboard da Cloudflare):
  - `PLUGGY_CLIENT_ID`: Identificador de cliente do dashboard Pluggy.
  - `PLUGGY_CLIENT_SECRET`: Segredo de API do dashboard Pluggy (tipo *Secret*).
  - `ALLOWED_ORIGIN`: Origem autorizada (`https://vitortozeti.github.io`).

## APIs Externas e Endpoints

1. **brapi.dev (Cotações e Mercado B3):**
   - Serviço isolado em: `src/services/marketApi.ts`.
   - Consulta cotações, variações diárias/históricas e dados de ações, FIIs e ETFs.
2. **Pluggy / Open Finance:**
   - Serviço frontend: `src/services/bankApi.ts`.
   - Widget SDK: `https://cdn.pluggy.ai/pluggy-connect/latest/pluggy-connect.js`.
   - Endpoints do Worker Proxy (`worker/worker.js`):
     - `POST /connect-token` → chama Pluggy `POST /connect_token` e retorna `{ accessToken }` para inicializar o widget.
     - `GET /transactions/:itemId` → autentica em `POST https://api.pluggy.ai/auth`, pagina `GET /v2/transactions`, normaliza (`normalizeTx`) e retorna `{ transactions, accounts, investments, transactionsCount }`. Trata status `LOGIN_ERROR`/`INVALID_CREDENTIALS`.
     - CORS restrito a `ALLOWED_ORIGIN` = `https://vitortozeti.github.io`.

## Armazenamento e Persistência de Dados

- **Navegador (Client-side):** todos os dados transacionais (gastos, receitas, orçamentos, metas, carteira e configurações) são armazenados no `localStorage` do navegador do usuário.
- **Chave do `localStorage`:** `greenfinance:v1` (persistência com debounce de 400 ms). Blob corrompido é preservado em `greenfinance:v1:corrupted-backup` antes de recorrer aos dados de exemplo. Migração via `src/utils/stateSchema.ts` (`CURRENT_SCHEMA_VERSION`, `validateAndMigrate`).
- **Forma do estado (`AppState`, `src/types/index.ts`):** `settings`, `transactions`, `categories`, `budgets`, `goals`, `portfolio`, `recurringRules`, `benefits`, `cashbackPrograms`, `unlockedAchievements`, `bankAccounts?`, `demoDataCleared`, `schemaVersion`.
- **Estado Global:** gerenciado via React Context único em `src/store/useStore.tsx` (todas as actions de CRUD + `generateDueRecurring`, `importData`, `resetAll`).
- **Arquivos Intermediários / Formatos de Importação:**
  - *Extratos bancários:* OFX, CSV e PDF (parseados via `src/utils/statementImport.ts` e `src/utils/pdfExtract.ts`).
  - *Backup / Restauração:* exportação e importação de JSON completo ou CSV via tela de Configurações (`src/pages/Settings.tsx`).
