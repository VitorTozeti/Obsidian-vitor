---
name: mural
description: mural de post-its interativo para duas pessoas, leve e com post-its guardados/criptografados sincronizados via GitHub
tags: [projeto, proj/mural, app, postits, web, sincronizacao]
updated: 2026-09-28
---

# Mural de Post-its para Conversas

Um mural de post-its só para duas pessoas, com assuntos que queremos conversar, post-its customizáveis e post-its "guardados" que só aparecem quando quem criou decide revelar.

## Estado atual (2026-09-28)

- **Fase:** **Esqueleto completo (MVP + V2 + Extras de UX)** implementado e funcional em `C:\Users\v.tozeti\Desktop\Vitor\teste\Vitor-mural`.
- **Arquitetura aplicada:**
  - Front-end modular HTML5, CSS e JS nativo sem frameworks pesados.
  - Temas visuais (Cortiça, Madeira, Escuro) e suporte a arrastar com mouse ou touch em smartphones/tablets.
  - Post-its customizáveis (6 cores, 5 fontes manuscritas, 3 tamanhos, rotações orgânicas, badges de sensibilidade do assunto e reações rápidas ❤️/👀/😅).
  - Post-its guardados com criptografia de ponta a ponta (Web Crypto API AES-GCM + PBKDF2) e dicas públicas.
  - Sincronização Serverless via GitHub Pages com polling de 15s e tratamento automático de conflitos (HTTP 409).
  - Gaveta de Histórico de conversas resolvidas com opção de reabertura rápida.
- **Próximos passos:**
  - Subir a pasta `Vitor-mural` para um repositório no GitHub e ativar o GitHub Pages.
  - Gerar o Fine-grained Personal Access Token para ambos e testar o uso em tempo real nos dois navegadores/celulares.
- **Onde os dados vivem:** consulte [[mural-dados]] para o mapa de persistência e repositório.

## Notas detalhadas do projeto

- [[mural-dados]] — mapa de localização de dados, repositório, chaves do LocalStorage e fluxo da API GitHub
- [[planejamento-mural-postits]] — especificação completa de design, funcionalidades e fases
