---
name: espro-analise-roadmap
description: análise de 2026-10-07 do ESPRO — pontos a melhorar (segurança, código, offline, produto) e planejamento de features em ondas
tags: [projeto, proj/espro, planejamento, roadmap, analise]
updated: 2026-10-07
---

# ESPRO — Análise e planejamento (2026-10-07)

Hub: [[espro]] · dados: [[espro-dados]] · backlog anterior: [[espro-ideias-futuras]] · editor: [[espro-usabilidade-editor]].

## Pontos a melhorar
**Segurança/robustez:** cadastro aberto sem verificação de e-mail; sem limite de tentativas de senha; "último a editar vence" depende do relógio do aparelho; regras de cargo (diário, publicar) só na interface/parcial no servidor; `.env` existe local (está no `.gitignore`, ok) com `TEAM_CODE` obsoleto.
**Código:** ~280 KB de JS em arquivos densos (`editor.js` 58 KB, `views.js` 41 KB) sem testes nem build; ~6 usos de `innerHTML` a auditar; sem lint.
**Offline/PWA:** há manifest mas **nenhum service worker**; 1º login exige servidor.
**Armazenamento:** mídia no D1 (linhas ~3 MB) → migrar para R2; imagens em data-URL.
**Produto:** Quadro/agenda globais (não por edição); sem notificações reais; sem edição simultânea; D1 só parcialmente testado em ponta a ponta; identidade da empresa ("Minha Empresa") ainda não definida.

## Planejamento em ondas
1. **Estabilizar (1–2 sem):** teste ponta a ponta do D1 (diário, link público, cargos); limite de tentativas de login; verificação/convite por e-mail; validar cargo no servidor em todas as rotas; remover conta de teste; backup automático.
2. **PWA/offline (1 sem):** service worker (cache do app + fila de sync), instalar na tela inicial, aviso de conexão.
3. **Mídia (1 sem):** R2 para imagens, miniaturas, compressão no envio.
4. **Produto:** quadro por edição; notificações (prazos/revisão); comentários fixados em ponto da página; menções @; relatório do fechamento (PDF da edição + métricas por setor); templates de seção personalizáveis.
5. **Wow para a apresentação:** modo apresentação com QR, flipbook com som de página, tema por seção, assistente de IA (título/resumo/legenda), vitrine pública da empresa fictícia (pilar 1 ainda sem tela).
6. **Qualidade:** testes de unidade (store/sync/api), dividir `editor.js` em módulos, Vite opcional, CI no GitHub.
