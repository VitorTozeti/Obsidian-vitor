---
name: greenfinance
description: app PWA de controle financeiro pessoal, carteira de investimentos e conciliação bancária (Pluggy/extratos)
tags: [projeto, proj/greenfinance, financeiro, pwa, react]
updated: 2026-08-31
---

# GreenFinance

App mobile-first de controle financeiro pessoal e análise de investimentos, operando como PWA (Progressive Web App) e hospedado estaticamente no GitHub Pages. Focado em uso individual (*single-user*), sem backend próprio, persistindo os dados no `localStorage` do navegador.

## Estado atual (2026-09-08)

- **Localização dos dados:** consulte [[greenfinance-dados]] para repositório, URLs, variáveis e APIs.
- **Detalhamento por página:** ver [[greenfinance-paginas]] — as 13 rotas + onboarding, tela a tela.
- **Produção:** publicado e funcional via GitHub Pages (`https://vitortozeti.github.io/Vitor_finan-as/`).
- **Open Finance:** integrado com Pluggy via Cloudflare Worker proxy (`https://blue-bonus-47ec.vitortozeti.workers.dev`).
- **Conciliação de Extratos:** importador local no navegador para arquivos OFX, CSV e PDF (via `pdfjs-dist`), com tela de revisão e deduplicação por `fitid`/chave composta.
- **Investimentos:** consulta de cotações B3 via brapi.dev e simulador de rentabilidade com perfis de risco.
- **Extras já implementados (mapeados em 2026-09-08):** benefícios (VA/VR/etc.), programas de cashback/pontos/milhas, **conquistas/gamificação** persistidas, regras de **transação recorrente** (catch-up de até 2 meses/load), **9 temas** + paleta personalizada e contas bancárias (`bankAccounts`) vindas do Open Finance.
- **Persistência:** `localStorage` na chave `greenfinance:v1` (debounce 400 ms) com migração de schema e backup de blob corrompido.

## Módulos e Funcionalidades

1. **Gestão de Gastos e Receitas:** lançamento rápido de transações, categorização automática por palavras-chave e controle de saldo.
2. **Orçamento e Metas:** limites mensais por categoria com alertas visuais e acompanhamento de metas financeiras.
3. **Conectar Banco:**
   - *Importação de Extrato:* leitura 100% no navegador (OFX, CSV e PDF de faturas de cartão/contas).
   - *Open Finance:* conexão bancária automática via widget Pluggy com intermediação de Cloudflare Worker para proteção de credenciais.
4. **Investimentos e Análise de Mercado:**
   - Acompanhamento de carteira (ações, FIIs, ETFs, renda fixa).
   - Cotações e destaques do mercado via API pública brapi.dev.
   - Simulador de evolução patrimonial com correção de inflação e perfis de risco.
5. **Benefícios e Relatórios:** gráficos comparativos mensais, fluxo de caixa e controle de benefícios (VR, VA, etc.).
6. **Configurações e Backup:** exportação completa em JSON e CSV, restauração de backup e limpeza de dados de demonstração.

## Arquitetura e Tecnologias

- **Frontend:** React 18, TypeScript, Vite, Tailwind CSS, Lucide React, Recharts.
- **Roteamento:** `HashRouter` (garante compatibilidade com GitHub Pages sem regras de fallback no servidor).
- **Offline / PWA:** `vite-plugin-pwa` para instalação na tela inicial e funcionamento offline da maior parte das telas.
- **Proxy Serverless:** Cloudflare Worker para autenticação OAuth no Pluggy sem expor `client_secret` no frontend estático.
- **CI/CD:** GitHub Actions (`.github/workflows/deploy.yml`) executando build e deploy a cada push na branch `main`.

## Notas detalhadas

- [[greenfinance-paginas]] — detalhamento página a página (rotas, seções da UI, dados lidos/escritos e cálculos de cada tela)
- [[greenfinance-dados]] — onde os dados vivem (repositório real, Cloudflare Worker, secrets, endpoints e armazenamento)
- [[greenfinance-arquitetura]] — arquitetura local-first, gerenciamento de estado no useStore, conciliação bancária e guia de evolução
