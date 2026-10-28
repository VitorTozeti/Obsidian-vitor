---
name: comanda-digital-avaliacao-producao
description: Avaliação (postura de banca) do sistema publicado em https://bueno-s-house.vercel.app contra o SRS v3.2 "Comanda Digital" — testes reais em produção em 2026-10-28
tags: [proj/bueno-s-house, avaliacao, deploy]
updated: 2026-10-28
---

# Comanda Digital — Avaliação do sistema em produção (2026-10-28)

## Contexto

Teste black-box da URL final `https://bueno-s-house.vercel.app` (front Angular na Vercel,
`/api/*` com proxy para o backend) contra o [[comanda-digital-srs]], como avaliador. Usados
só os botões de **acesso rápido de demonstração** (cliente e administrador) — nenhuma senha
digitada, **nenhum pedido/cadastro/alteração enviado** (fluxos de escrita não foram exercitados:
checkout, confirmar→baixa de estoque, cancelar→estorno, receber compra, criar usuário).

## Conteúdo

### Critérios gerais
| Critério | Resultado |
|---|---|
| Stack (Angular + Spring Boot + MySQL) | ✅ Angular confirmado no bundle; backend Spring (`/api/health` → `restaurante-sistema-backend UP`) |
| Sistema no ar | ✅ mas o backend **hiberna**: 1ª chamada levou ~50–90 s (timeout/502). Acordar antes da banca |
| Swagger `/swagger-ui.html` (RNF11) | ❌ `/swagger-ui.html` cai no SPA (HTML do Angular); `/api/swagger-ui.html` e `/api/v3/api-docs` → **401**. Na URL pública não há Swagger acessível |
| Seed `admin@email.com` | ✅ usuário existe (ADMINISTRADOR); o login demo usa `admin@demo.local` |
| JWT 8h | ✅ `exp - iat = 8h` |
| Senha fora do JSON (RNF01) | ✅ `/api/users` só devolve `publicId,id,email,profileName,active` |

### Blocos de nota (SRS §11)
| # | Bloco | Veredito | Evidência / falha |
|---|---|---|---|
| 1 | Cardápio público + carrinho | ✅ | `/app/cardapio` sem login, filtro por categoria, toast ao adicionar, carrinho persiste (`bueno.cart`). ⚠️ sem página de **detalhe do prato** (RF-002); `/carrinho` exige login para ser *visto*; `GET /api/products` sem `unitId` → **500** (deveria ser 400) |
| 2 | Jornada do cliente | ✅ (leitura) | Checkout com endereço + pagamento simulado, timeline Recebido→…→Entregue, código de entrega, "Meus pedidos". Cadastro/checkout não submetidos |
| 3 | CRUD cardápio | 🟡 | Produtos: criar/editar/excluir. **Categorias sem editar** (só criar/excluir). **Sem campo "modo de preparo" (RF-014)** |
| 4 | Ficha técnica e custos | ✅ | Recalculei X-Bacon: custo R$ 15,40, food cost 44,1% = valores da tela e da API (`foodCostLevel: RED`); fator de correção ≥1; RN01 sinalizado |
| 5 | Pedidos e cozinha | ✅ | Painel com filtros status/canal/data, paginação real (`page/size` + `X-Total-Count`) |
| 6 | Pedido↔estoque | ⚪ não testado | Exigiria confirmar/cancelar pedido em produção. ⚠️ incoerência: dashboard mostra 1.904 pedidos/2.016 refrigerantes vendidos, mas o estoque tem 48 latas e 59 pães — histórico do seed não passou pela baixa |
| 7 | Fornecedores e compras | 🟡 | CNPJ, catálogo, cotação, pedido de compra (rascunho). **Fornecedor sem editar/desativar** na tela; **RF-026 histórico de preços com gráfico não encontrado**; nenhum pedido de compra no seed (fluxo RECEBIDO não demonstrável) |
| 8 | Estoque | ✅ (leitura) | Saldo, mínimo, alerta (Bacon), editar/desativar. Log de movimentações não verificado |
| 9 | Dashboard | 🟡 | Gráficos em `<canvas>` (diário 30 d + mensal 12 m), top produtos, food cost médio 29%, alerta. KPIs são de **30 dias**, não "do dia" (RF-034); "Top 5" lista 4 (só há 4 pratos) |
| 10 | Auth e RBAC | 🟡 | Cliente recebe 403 em `/api/users`, `/suppliers`, `/orders`…; guard Angular redireciona cliente de `/dashboard`. CRUD de usuários internos OK. ❌ **JWT sem role no payload** (só `sub`) — RF-038 pede explicitamente |

### Achados graves (fora da tabela de nota)
1. **Login de demonstração como Administrador em produção, sem senha.** Qualquer visitante da
   URL pública vira ADMIN em 1 clique e pode criar usuários, redefinir senhas, desativar contas
   e alterar cardápio/estoque. Inaceitável num sistema "no ar"; restringir ao perfil `dev` ou
   ao menos a perfis sem escrita.
2. Erros de parâmetro ausente viram **500** genérico (`/api/products`, `/api/categories`,
   `/api/suppliers` sem `unitId`) — o `@ControllerAdvice` (RNF06) não trata `MissingServletRequestParameterException`.
3. Swagger inacessível publicamente (checklist §13 do SRS).

### Prioridade de correção antes da banca
1. Remover/limitar o acesso rápido de ADMIN em produção. 2. Liberar Swagger público
(`permitAll` + rota no proxy da Vercel). 3. Colocar `role` no JWT. 4. Campo modo de preparo,
editar categoria/fornecedor, histórico de preços com gráfico. 5. KPIs do dia. 6. Seed com um
pedido de compra e estoque coerente com o histórico. 7. Tratar 400 para parâmetro faltando.
8. Testar manualmente (ambiente de teste) confirmar→baixa e cancelar→estorno.

## Relacionado
- [[bueno-s-house]] · [[bueno-s-house-dados]]
- [[comanda-digital-srs]] · [[comanda-digital-estado]] · [[comanda-digital-plano]]
