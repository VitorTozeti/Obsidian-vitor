---
name: greenfinance-dados
description: mapa de localização de dados, repositório, APIs, worker e armazenamento do GreenFinance
tags: [proj/greenfinance, dados, infra, integracao]
updated: 2026-09-07
---

# GreenFinance — Onde os Dados Vivem

Nota de localização técnica e dados de integração do projeto [[greenfinance]].

## Repositórios e Links

- **Repositório Local no Disco:** `C:\Users\Vitor\Desktop\projetos\greenfinance`
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
   - Endpoints do Worker Proxy:
     - `POST /connect-token` → retorna `{ accessToken }` para inicializar o widget.
     - `GET /transactions/:itemId` → retorna `{ transactions }` normalizadas da conta conectada.

## Armazenamento e Persistência de Dados

- **Navegador (Client-side):** todos os dados transacionais (gastos, receitas, orçamentos, metas, carteira e configurações) são armazenados no `localStorage` do navegador do usuário.
- **Estado Global:** gerenciado via React Context em `src/store/`.
- **Arquivos Intermediários / Formatos de Importação:**
  - *Extratos bancários:* OFX, CSV e PDF (parseados via `src/utils/statementImport.ts` e `src/utils/pdfExtract.ts`).
  - *Backup / Restauração:* exportação e importação de JSON completo ou CSV via tela de Configurações (`src/pages/Settings.tsx`).
