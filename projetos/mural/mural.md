---
name: mural
description: mural de post-its interativo para duas pessoas, leve e com post-its guardados/criptografados sincronizados via GitHub
tags: [projeto, proj/mural, app, postits, web, sincronizacao]
updated: 2026-09-28
---

# Mural de Post-its para Conversas

Um mural de post-its só para duas pessoas, com assuntos que queremos conversar, post-its customizáveis e post-its "guardados" que só aparecem quando quem criou decide revelar.

## Estado atual (2026-09-28)

- **Fase:** **Fase 1 (Scaffold/Esqueleto de Projeto) concluída** em `C:\Users\v.tozeti\Desktop\Vitor\teste\Vitor-mural`.
- **Arquitetura aplicada:** HTML5 + CSS puro (fundo estilo cortiça com efeito pin-board, layout responsivo) + JS nativo modular (`app.js`, `board.js`, `postit.js`, `github.js`, `crypto.js`) e `data.json` inicial.
- **Próximos passos:**
  - Configurar repositório remoto no GitHub e ativar o GitHub Pages.
  - Inserir o Personal Access Token (Fine-grained) e testar a sincronização remota entre os dois usuários.
- **Onde os dados vivem:** consulte [[mural-dados]] para o mapa de persistência e repositório.

## Notas detalhadas do projeto

- [[mural-dados]] — mapa de localização de dados, repositório, chaves do LocalStorage e fluxo da API GitHub
- [[planejamento-mural-postits]] — especificação completa de design, funcionalidades e fases
