---
name: nexus-rpg-plano-melhorias
description: plano completo de melhorias do Nexus RPG por área (dados, segurança, arquitetura, testes/CI, UX/UI, funcionalidades, distribuição, docs) com evidências, esforço, impacto e ondas de execução
tags: [projeto, proj/nexus-rpg, planejamento, roadmap, auditoria]
updated: 2026-10-13
---

# Nexus RPG — Plano de melhorias (auditoria 2026-10-13)

Complementa [[nexus-rpg-planejamento]] (backlog antigo) e [[nexus-rpg-mapas-geradores]] (rodada de mapas/UX
já entregue, commit `8c10d43`). Fontes: leitura do código em `The-One-System` (~7,7k linhas) e medições
por busca (`grep`/`wc`). Itens marcados **(medido)** têm número verificado; **(inferido)** são julgamento.
Esforço: P (horas) · M (1–2 dias) · G (semana+). Impacto: ⭐ baixo · ⭐⭐ médio · ⭐⭐⭐ alto.

> **Atualização:** itens 1.1, 1.2, 1.4, 1.7, 3.5, 5.6, 5.8 (parcial), mapa editável e iniciativa/modo apresentação/.campanha foram entregues na [[nexus-rpg-v2-sistema-mapa-campanha]] (não commitado).

## 1. Dados e robustez
| # | Achado | O que fazer | Esf. | Imp. |
|---|---|---|---|---|
| 1.1 | **Importar `.nexus` não valida** — `master-pieces.js:931` faz `S.system=JSON.parse(...)` sem `migrateSystem`/`sanitizeSystem` **(medido)**. Arquivo antigo/malformado quebra telas | Passar por `migrateSystem` + checagem de schema/tamanho; mensagem de erro específica | P | ⭐⭐⭐ |
| 1.2 | **Backup só exporta** (💾 novo) — não há restaurar | Botão "Restaurar backup" (valida, pergunta se substitui/mescla) | P | ⭐⭐⭐ |
| 1.3 | Importar ficha (`players.js`) só trata erro de JSON; já usa `sanitizeDraft` ✔ | Validar versão/sistema da ficha e avisar divergência | P | ⭐⭐ |
| 1.4 | Campanha sem export próprio (`.campanha` está no backlog) | Exportar/importar campanha (mapas+bestiário+itens) com versão de schema | M | ⭐⭐⭐ |
| 1.5 | Imagens (mapas, fotos, terreno PNG) em base64 no `localStorage` (~5 MB) | Mostrar **medidor de uso**; mover mídia para **IndexedDB**; comprimir terreno (WebP) | M | ⭐⭐⭐ |
| 1.6 | `uid()` usa `Math.random` **(medido)** — colisão improvável, mas evitável | `crypto.randomUUID()` com fallback | P | ⭐ |
| 1.7 | Sem indicador de "salvo" | Selo "✔ salvo às HH:MM" no cabeçalho; aviso quando `persist()` falha | P | ⭐⭐ |

## 2. Segurança
| # | Achado | O que fazer | Esf. | Imp. |
|---|---|---|---|---|
| 2.1 | **Senha em texto plano** (`accounts.js`, já avisado no código) | Hash PBKDF2/WebCrypto + salt; migrar contas antigas no próximo login. Alternativa: deixar claro "sem senha real" | M | ⭐⭐ (local) |
| 2.2 | `h({html:})` e `innerHTML` (10 usos) **(medido)** — hoje escapam com `esc()`, sem falha achada | Restringir `html:` a literais; lint que proíbe `innerHTML` com dado do usuário | P | ⭐⭐ |
| 2.3 | Sem CSP | `<meta http-equiv="Content-Security-Policy">` (script/style `'self'`; `style-src 'unsafe-inline'` por causa dos estilos inline) | P | ⭐⭐ |
| 2.4 | Importações vindas de terceiros (.nexus/ficha/campanha) | Limitar tamanho, ignorar chaves `__proto__`/`constructor`, validar tipos (junto com 1.1) | P | ⭐⭐ |

## 3. Arquitetura e código
| # | Achado | O que fazer | Esf. | Imp. |
|---|---|---|---|---|
| 3.1 | **`render()` reconstrói a árvore inteira** — 419 chamadas **(medido)**; perde foco/rolagem, custo em telas grandes | Agrupar renders (rAF/debounce), preservar foco e scroll, re-render parcial por painel | M–G | ⭐⭐⭐ |
| 3.2 | Arquivos grandes: `player.js` 1253, `master-pieces.js` 947, `campaign-map.js` 848 **(medido)** | Quebrar por responsabilidade (blocos da ficha, abas do Mestre, mapa: ferramentas/tokens/props/geradores) | M | ⭐⭐ |
| 3.3 | Escopo global, 24+ `<script>` com ordem frágil | Namespace `Nexus.*` por módulo ou bundle gerado por script (sem exigir build p/ usar) | G | ⭐⭐ |
| 3.4 | ~272 estilos inline em `player.js`+`master-pieces.js` **(medido)** | Migrar para classes CSS (também destrava tema claro) | M | ⭐⭐ |
| 3.5 | 34 usos de `alert/confirm/prompt` **(medido)** | Componente modal/toast próprio (acessível, estilizado, com "desfazer") | M | ⭐⭐⭐ |
| 3.6 | Sem lint/format | ESLint + Prettier (config) e `.editorconfig`; o `.gitattributes` p/ evitar o aviso LF/CRLF | P | ⭐ |

## 4. Testes e CI
- **Estado:** nenhum teste automatizado; **Node não está instalado nesta máquina** **(medido)** — então testes devem rodar no **navegador**.
- **4.1 (P, ⭐⭐⭐)** Página `tests/index.html` (abre por `file://`) com testes de `formula-engine`, `dice-engine`, `sanitizeSystem/migrateSystem` e **geradores de mapa** (mesma semente → mesma saída; contagem de salas/reinos).
- **4.2 (M, ⭐⭐)** Smoke test automatizado do fluxo (cadastro → mestre → mapa → gerar) com Playwright/Chrome headless (o plugin Playwright do Claude está desconectado hoje; `chrome --headless --dump-dom` serve de fallback).
- **4.3 (P, ⭐⭐)** Trocar o workflow Jekyll por **deploy estático** (Pages direto) e rodar os testes no CI.
- **4.4 (M, ⭐)** Regressão visual dos mapas por semente (PNG de referência).

## 5. UX/UI
| # | Item | Esf. | Imp. |
|---|---|---|---|
| 5.1 | **Tema claro** (precisa de 3.4 antes; hoje há cores escuras fixas) | M | ⭐⭐ |
| 5.2 | Padronizar ícones (emoji misturado) → conjunto SVG único | M | ⭐⭐ |
| 5.3 | Editor de ficha — backlog: botões ↶ ↷ visíveis (37), lixeira (38), tema da ficha (32), snap/espaçamento (39), miniatura na paleta (40), mais modelos (33), ficha responsiva (36) | M–G | ⭐⭐⭐ |
| 5.4 | Responsividade: só ~6 `@media` **(medido)**; testar 360–768 px, mapa com gesto de **pinça** | M | ⭐⭐⭐ |
| 5.5 | Acessibilidade: `role=tablist/tab`, modais com focus-trap, teclado no canvas da ficha, auditoria de contraste, `alt` em imagens | M | ⭐⭐ |
| 5.6 | Onboarding: estados vazios com ação ("Crie seu primeiro mapa"), tour curto do Mestre | P–M | ⭐⭐ |
| 5.7 | Busca Ctrl+K cobrir mapas, bestiário, itens, NPCs | P | ⭐⭐ |
| 5.8 | "Desfazer" global por toast (excluir mapa/token/peça) | M | ⭐⭐⭐ |
| 5.9 | i18n (strings fixas em PT-BR) — só se houver público fora do BR | G | ⭐ |

## 6. Funcionalidades
- **Mapas:** névoa de guerra/revelar áreas · medir distância e gabaritos (cone/esfera/linha) · camadas e bloqueio · bibliotecas de peças/tokens por imagem · desenhar rotas/linhas · rótulos de cordilheiras/mares/lagos e culturas no gerador de mundo · salas com "iluminação" · mais geradores (cidade murada, nave/estação para tema futurista).
- **Mesa:** **iniciativa/ordem de turno** ligada aos tokens (backlog) · **modo apresentação**: janela/aba secundária para os jogadores (sincronizada por `BroadcastChannel`, funciona offline) · diário de sessões (`campaign.sessions` existe no modelo e é pouco usado — **inferido**) · sons/imagens por cena.
- **Conteúdo:** compêndio/SRD importável, gerador de encontros/loot por tabela, gerador de NPC/nomes (reaproveita `nomeProc`).
- **Ficha:** exportar PDF (CSS de impressão) · galerias de modelos prontos · cálculo de cargas/recursos com avisos.

## 7. Distribuição e plataforma
- **PWA** (manifest + service worker): instalável, offline mesmo via http, ícone na área de trabalho — impacto alto, esforço P–M.
- **Empacotar** (Tauri/Electron) apenas se precisar de arquivos nativos/atualização automática.
- **Backend opcional** (sincronizar, convidar por link, marketplace): só depois de 1.x–4.x; exige auth/banco/websocket e muda o "abrir com dois cliques" → decisão de produto (ver [[nexus-rpg-planejamento]]).

## 8. Documentação e projeto
- `README.md` do repo **não cita** campanha/mapas/geradores nem a pasta `src/master/campaign/` → atualizar (e adicionar capturas de tela).
- Criar `CHANGELOG.md` (hoje o log está em `nexus-rpg-prototipo.md`), `LICENSE`, `CONTRIBUTING` curto.
- Manter o vault em dia a cada rodada ([[nexus-rpg]], [[nexus-rpg-telas]], [[nexus-rpg-dados]]).

## Ondas de execução sugeridas
1. **Onda 1 — Segurança dos dados (1–2 dias):** 1.1, 1.2, 1.7, 2.4, 4.1 (testes dos motores/geradores), 3.6, docs (README/CHANGELOG).
2. **Onda 2 — UX que o usuário sente (3–5 dias):** 3.5 (modais) + 5.8 (desfazer), 5.3 (editor de ficha), 5.4 (mobile/pinça), 5.6/5.7, PWA.
3. **Onda 3 — Estrutura (1–2 semanas):** 3.1 (render parcial), 3.2/3.4 (quebrar arquivos, estilos → classes), 1.5 (IndexedDB), 4.3 (CI).
4. **Onda 4 — Recursos de mesa:** iniciativa, modo apresentação, névoa/medição, `.campanha`, rótulos no gerador de mundo, tema claro.
5. **Onda 5 — Decisão de produto:** backend/online/marketplace.

## Decisões que dependem do usuário
- Quem usa? Só uso pessoal (local basta) ou mesas com amigos (online/PWA/modo apresentação ganham prioridade)?
- Manter "abrir com dois cliques" (`file://`) como regra? Se sim, bundle/PWA/IndexedDB precisam respeitar.
- Senha: remover o conceito, ou fazer hash de verdade?

## Relacionado
[[nexus-rpg]] · [[nexus-rpg-planejamento]] · [[nexus-rpg-mapas-geradores]] · [[nexus-rpg-arquitetura]] · [[nexus-rpg-telas]] · [[nexus-rpg-dados]]
