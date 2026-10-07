---
name: comanda-digital-plano
description: Plano de implementação faseado do SRS "Comanda Digital" sobre o Bueno's House, com base em auditoria real do código (não estimativa)
tags: [proj/bueno-s-house]
updated: 2026-09-29 (Fases 5 e 7 fechadas; Fase 6 e parte da 7 + telas Angular simples implementadas no working tree, NÃO compiladas nem commitadas)
---

# Comanda Digital — Plano de Implementação

## Contexto

Em 2026-09-25, após o SRS completo ([[comanda-digital-srs]]) e o levantamento inicial por
estimativa ([[comanda-digital-estado]]), foi feita uma **auditoria real do código** do
backend Spring Boot (`inventory`, `ordering`, `identity`, `customers`, `reports`) e dos dois
frontends (`frontend-angular/`, `frontend/`). Esta nota substitui as partes "não auditado" de
[[comanda-digital-estado]] por fatos confirmados no código, e organiza o trabalho restante em
fases executáveis. Nenhum código foi alterado nesta rodada — é só plano, aguardando execução.

## Conteúdo

### Correções ao levantamento anterior (fatos, não mais estimativa)

- **CLIENTE já é um gap menor do que se pensava:** a role `CLIENTE` já existe e já é
  funcional — `POST /api/orders` aceita CLIENTE, `GET /api/orders/mine` e
  `GET /api/orders/{id}` já têm checagem de ownership certa
  (`OrderController.java`/`CustomerService.customerIdOfUser()`), e o Angular já tem telas de
  cliente completas (`customer-menu`, `customer-checkout`, `customer-orders`,
  `customer-order-track`). **O que falta de verdade é só o auto-cadastro público**
  (`POST /api/auth/register` não existe — só login) e liberar o cardápio (`catalog`) para
  acesso sem login.
- **Ficha técnica/food cost (bloco 4) é pior do que se pensava:** `Recipe`/`RecipeItem`
  existem mas **sem** `fator_correcao` nem `rendimento` (confirmado na migration
  `V11__inventory.sql`), e **não existe nenhum cálculo de custo ou food cost em lugar
  nenhum do código**. É o bloco de maior risco.
- **Fornecedores/compras (bloco 7) é praticamente do zero:** `Supplier` e `Purchase` só têm
  entidade+repositório, **zero controller/service**, `Purchase` não tem itens de linha nem
  status (`RASCUNHO/ENVIADO/RECEBIDO`), não existe `fornecedor_produto` nem cotação.
- **Dashboard (bloco 9) é melhor do que se pensava no backend:** `reports` já cobre
  daily-revenue, average-ticket, top-products (aceita `limit=5`), low-stock. Só falta
  food-cost médio (depende do bloco 4) e "vendas por período" como série. **Frontend não tem
  Chart.js/ng2-charts em nenhum dos dois projetos** — dashboard visual é 100% a construir.
- **Usuários internos (parte do bloco 10) não existe:** `User`/`Profile` estão modelados,
  mas não há nenhum `UserController`/`UserService` — Admin não tem como criar
  Gerente/Cozinheiro pela API hoje.
- **Dois frontends em paralelo:** Angular (`frontend-angular/`) é mais completo, inclui o
  fluxo do cliente; React (`frontend/`) espelha só as telas de staff. Recomendação: consolidar
  em Angular (é a stack exigida pelo SRS de qualquer forma) e não investir mais no React.

### Fases do plano

**Fase 0 — Fundação (bloqueante) — ✅ concluída em 2026-09-25**
1. ~~`git init` + `.gitignore`~~ — **correção**: o Git já existia (remoto
   `github.com/Joaovsr98/Bueno-sHouse`, branch `feat/migracao-angular`,
   `.gitignore` já cobrindo `.env`/`node_modules`/`target`), contradizendo a
   auditoria de agosto. Nada a fazer aqui.
2. Rodar `mvn test` de verdade — **ainda pendente**, este ambiente (sessão do
   Claude) não tem Java/Maven/Node instalados para validar; precisa ser
   rodado localmente pela usuária.
3. Decidir consolidar em Angular — **decisão tomada**, mantida como
   recomendação (React não foi removido ainda, só não deve receber mais
   trabalho).

**Fase 1 — Auth do Cliente (fecha blocos 1+2 do SRS, RF-001 a 008) — ✅ implementada em 2026-09-25 (compilação não verificada, ver Pendências)**
4. `POST /api/auth/register` público → cria `User` (perfil CLIENTE) + `Customer` vinculado. Feito: `RegisterRequest` DTO, `AuthService.register()`, `AuthController`, `EmailAlreadyExistsException` (409, RN10), liberado em `SecurityConfig`.
5. Cardápio público sem login (RN09: só produtos `available=true`). Feito: `ProductService.listPublicByUnit/listPublicByCategory` + `ProductRepository` com filtro `AvailableTrue`; `ProductController` decide staff vs. público via `SecurityContextHolder` (CLIENTE logado também vê só o público); `GET /api/categories`, `/api/products`, `/api/units` liberados no `SecurityConfig`.
6. Ownership de `/api/orders/*` já existia (confirmado por auditoria de código, não precisou de mudança).
7. **Extra além do previsto no plano original:** o Angular guardava `/app/*` inteiro (inclusive o cardápio) atrás de `authGuard` — isso quebraria RF-001 na prática (cardápio não era navegável sem login). Corrigido: `cardapio` ficou público, só `carrinho`/`pedidos`/`pedidos/:orderId` continuam guardados. Criada tela `features/register/` (formulário nome/e-mail/telefone/senha). `authGuard` agora preserva `returnUrl` e o login redireciona de volta pra lá (RF-005). Header do app do cliente mostra "Entrar" para anônimo e "Sair" só para logado.

**Pendências abertas desta fase:**
- Compilar/testar de verdade (`mvn -Dmaven.test.skip=true compile`, depois `mvn test` com Docker; `npm run build` no `frontend-angular`) — não foi possível neste ambiente.
- Carrinho é só em memória (signal, some ao recarregar a página) — pré-existente, não é regressão desta fase, mas vale registrar como fricção de UX.
- Endereço de entrega não é capturado no cadastro (fica para o checkout, `CustomerAddress`) — consistente com o fluxo do SRS, mas o cliente precisa cadastrar um endereço em algum momento antes do checkout; hoje não há tela para isso no `customer-checkout` além de listar endereços existentes.

**Fase 2 — Ficha técnica e custo (bloco 4, RF-011 a 013) — ✅ backend implementado em 2026-09-25**
7. Migration `V14__ficha_tecnica_custo.sql`: `correction_factor` em `recipe_items` (DEFAULT 1),
   `yield_quantity` em `recipes` (DEFAULT 1) — default seguro para fichas já cadastradas.
8. `InventoryService.toRecipeResponse()` calcula `costPerServing` (= `custo_prato`) e
   `foodCostPercent` com o semáforo `GREEN`/`YELLOW`/`RED` (RN02: só avisa, nunca bloqueia) —
   embutido direto na resposta da ficha técnica, sem endpoint separado.
9. Novo `GET /api/inventory/recipes/{productId}` (antes só existia `POST`). `RecipeItemRequest`
   agora exige `correctionFactor >= 1.0` (RN08) e `RecipeRequest` exige `yieldQuantity`.
10. **Pendente:** RN01 ("prato só ATIVO com ficha técnica") **não foi implementada** de
    propósito — enforçar isso hoje quebraria todo produto existente sem ficha técnica ao ser
    editado. Registrado como decisão consciente, não esquecimento.
11. **Pendente:** tela Angular com `FormArray` para a ficha técnica — só backend foi feito
    (sem Node/npm neste ambiente para validar um componente Angular novo com segurança).

**Fase 3 — Fornecedores e Compras (bloco 7, RF-021 a 026) — ✅ backend implementado em 2026-09-25**
12. Migration `V15__fornecedores_compras.sql`: tabela `supplier_products` (cotação),
    `purchases.status` (`RASCUNHO/ENVIADO/RECEBIDO/CANCELADO`, default `RASCUNHO`), tabela
    `purchase_items` (linhas do pedido de compra). `purchases.purchased_at` virou opcional
    (só é preenchido no recebimento).
13. `CnpjValidator` (algoritmo de dígito verificador) + `SupplierService`/`SupplierController`
    (`/api/suppliers`, CRUD, `/api/suppliers/{id}/products` para o catálogo do fornecedor,
    `/api/suppliers/quote?inventoryItemId=` para a cotação comparativa ordenada por preço).
14. `PurchaseService`/`PurchaseController` (`/api/purchases`): criar em `RASCUNHO` com itens,
    `PATCH /{id}/send` → `ENVIADO`, `POST /{id}/receive` → `RECEBIDO` (gera `StockMovement`
    `ENTRADA_COMPRA` via `InventoryService.receiveStock()` e atualiza `costPerUnit`, RN05),
    `PATCH /{id}/cancel`.
15. **Pendente:** telas Angular (fornecedores, catálogo, cotação, fluxo de compra) — não
    construídas nesta rodada.

**Fase 4 — Estoque completo (bloco 8, RF-027 a 033) — ✅ concluída em 2026-09-25**
16. Já estava quase tudo pronto (saldo em tempo real, alertas de mínimo, log de movimentações
    via API). Único gap real: `AJUSTE_PERDA` (saída manual) aceitava motivo em branco — agora
    `InventoryService.registerManualMovement()` rejeita com 422 se `reason` vier vazio (RF-030).
17. **Extra, fora do plano original:** a auditoria da Fase 1 tinha marcado RF-018
    ("cancelamento com estorno de estoque") como não confirmado. Confirmado que **não
    existia** — `ESTORNO_CANCELAMENTO` só aparecia como comentário no código, nunca usado.
    Implementado: `InventoryService.reverseDeductionForOrderItem()` (idempotente, reverte só o
    que foi de fato baixado) chamado por `OrderService.transitionTo()` sempre que um pedido
    vira `CANCELADO`. `OrderService.cancel()` agora também exige motivo não vazio.
    **Gap remanescente, não resolvido:** RN04 ("cancelamento livre antes de EM_PREPARO, depois
    só GERENTE/ADMIN") não é diferenciado por status no endpoint genérico `/orders/{id}/transition`
    — GARCOM/CAIXA ainda podem cancelar por ali em qualquer status permitido pela máquina de
    estados. Só o endpoint dedicado `/orders/{id}/cancel` é restrito a ADMIN/GERENTE.

**Fase 5 — Dashboard (bloco 9, RF-034 a 037) — backend concluído, frontend pendente**
18. `InventoryService.averageFoodCostPercent()` + `GET /api/reports/average-food-cost` (média
    do food cost só dos produtos que têm ficha técnica com preço válido).
19. "Vendas por período" (RF-037) já era coberto por `GET /api/reports/daily-revenue`
    (série por dia) — nenhuma mudança necessária, só reaproveitar no gráfico de linha.
20. **Pendente:** instalar Chart.js/ng2-charts e construir a tela de dashboard em Angular — não
    feito nesta rodada (risco alto de código não compilável sem Node para validar).

**Fase 6 — Usuários internos (RF-041) — ✅ backend implementado em 2026-09-29 (não compilado)**
18. `UserController` (`/api/users`, só ADMINISTRADOR): `GET` lista staff (exclui CLIENTE), `POST` cria
    usuário com perfil escolhido, `PATCH /{id}` troca perfil / ativa-desativa / redefine senha (zera
    bloqueio de login). Regras: perfil CLIENTE nunca por aqui; admin não altera o próprio perfil nem
    se desativa. Arquivos em `modules/identity/{controller,service,dto}`. **Pendente:** tela Angular.

**Fase 7 — Polimento, NFRs e Deploy — parcial (2026-09-29)**
19. **Paginação (RNF08) — ✅ para pedidos (RF-019):** `GET /api/orders?unitId&page&size` (size máx.
    100, mais recentes primeiro) devolve total em `X-Total-Count` (exposto no `CorsConfig`). Sem `page`
    mantém a lista completa, para não quebrar painéis atuais. **Demais listagens (produtos,
    fornecedores…) continuam sem paginação.**
20. **Swagger/OpenAPI (RNF11) — ✅:** `springdoc-openapi-starter-webmvc-ui` 2.6.0 no `pom.xml`; rotas
    `/v3/api-docs/**`, `/swagger-ui/**` públicas no `SecurityConfig`. UI em `/swagger-ui.html`.
21. DER visual exportado — **pendente**.
22. Deploy (banco gerenciado + back + Angular + CORS prod) — **pendente**, depende de conta/plataforma da usuária.
23. README — ✅ seção "API docs, paginação e usuários internos" adicionada (seed real de dev:
    `admin@demo.local` / `admin123`; a nota antiga citava `admin@email.com`/`senha123`, incorreto).

### Telas Angular simples (2026-09-29, sem estilo, por pedido da usuária)

Criadas em `frontend-angular/src/app/features/`, sem CSS (só `<table border>`/form crus), rotas em
`app.routes.ts` e itens no menu do `staff-layout`; `ApiService.patch()` adicionado:
`users/` (`/usuarios`), `suppliers/` (`/fornecedores`: fornecedores, catálogo, cotação, pedidos de
compra com enviar/receber/cancelar), `recipes/` (`/fichas-tecnicas`, `FormArray`, mostra custo e food
cost), `dashboard/` (`/dashboard`: **tabelas, sem Chart.js** — decisão de simplicidade). Não compiladas
(sem Node neste ambiente). Fica pendente, se quiserem gráficos: instalar Chart.js/ng2-charts.

### Envio ao GitHub (2026-09-25)

Commit `f94d684` (48 arquivos) enviado para `origin/feat/migracao-angular` em
[github.com/Joaovsr98/Bueno-sHouse](https://github.com/Joaovsr98/Bueno-sHouse). Sem conflito
(branch estava atualizada antes do fetch). **Compilação ainda não verificada** — próximo
passo obrigatório antes de confiar no branch é rodar `mvn -Dmaven.test.skip=true compile` e
`npm run build` localmente.

### Status consolidado das fases (2026-09-29)

| Fase | Status | O que falta |
|---|---|---|
| 0 Fundação | ✅ | `mvn test` real (rodar localmente) |
| 1 Auth do cliente | ✅ | compilar/testar; tela de endereço no checkout |
| 2 Ficha técnica/custo | ✅ backend + tela simples | RN01 (prato ATIVO só com ficha) deliberadamente não feita |
| 3 Fornecedores/compras | ✅ backend + tela simples | validar em execução |
| 4 Estoque | ✅ | RN04 (cancelar após EM_PREPARO só gerente) no endpoint genérico `/transition` |
| 5 Dashboard | ✅ backend + gráficos (linha/barras) | `npm install` + build (chart.js ^4 adicionado ao package.json) |
| 6 Usuários internos | ✅ backend + tela simples | compilar |
| 7 Polimento/Deploy | ✅ pronto p/ front | deploy real em plataforma (depende da usuária); revisar seed V900 em prod |

**Rodada de 2026-09-29 (Fases 5 e 7 fechadas, não compiladas):**
- Gráficos: `features/dashboard/chart.ts` (`<app-chart>`, Chart.js puro, sem ng2-charts) usado no dashboard
  (linha = faturamento/dia, barras = top 5).
- Paginação opcional `?page&size` (+ `X-Total-Count`) em produtos, fornecedores, compras e itens de
  estoque via helper `config/Paging.java`; sem `page` tudo segue igual (não quebra telas).
- DER: `docs/DER.md` no repo (Mermaid gerado das migrations: 43 tabelas, 71 FKs).
- Deploy: `frontend-angular/Dockerfile` + `nginx.conf` (proxy `/api` e `/ws` → backend, fallback SPA),
  serviço `frontend-angular` no `docker-compose.yml` (porta `ANGULAR_PORT`, padrão 4200), `.env.example` atualizado.
- Ressalva: a migration `V900__seed_demo_data.sql` está no mesmo `locations` do Flyway e o `AuthService`
  depende do perfil CLIENTE vindo dela — antes de produção real, separar seed de perfis (obrigatório) do seed demo.

**Restam de verdade:** (a) build/teste real de tudo (`mvn test`, `npm run build`) — bloqueia confiar
nas Fases 1-7; (c) estilizar as telas Angular cruas (= próxima etapa: construção do front); (d) ~~RN04~~ feita em 2026-10-07;
(g) deploy real; (h) commitar/enviar o working tree das Fases 6-7 (não commitado).


### Rodada de 2026-10-07 (RN04, endereço no checkout, base visual) — não compilada

- **RN04 resolvida:** `OrderController.transition` (`POST /api/orders/{id}/transitions`) agora recusa
  `CANCELADO` (422) para quem não é ADMINISTRADOR/GERENTE quando o pedido já passou de RECEBIDO/CONFIRMADO
  (`OrderService.canCancelFreely`, usa `NOT_CANCELLABLE`). Antes disso qualquer perfil do endpoint cancela.
- **Endereço no checkout:** `customer-checkout` ganhou formulário "Novo endereço" (`POST /api/customers/{id}/addresses`);
  abre sozinho se o cliente não tem endereço e já seleciona o recém-criado.
- **Base visual:** classe global `.page-basic` em `styles.css` (host das telas usuarios, fornecedores, fichas
  técnicas, dashboard) estiliza tabelas/inputs/botões no tema escuro/laranja sem reescrever os templates.
- Continua pendente: compilar/testar tudo (sem Java/Node/Docker ativo nesta sessão), deploy real, separar seed V900.

### Ordem de execução recomendada

Fase 0 → Fase 1 (fecha o maior gap de nota, blocos 1+2) → Fase 2 (maior risco técnico, fazer
cedo) → Fase 4 (rápida) → Fase 3 (mais trabalhosa, do zero) → Fase 5 → Fase 6 → Fase 7/Deploy
por último, mas testar deploy pelo menos uma vez com antecedência.

## Relacionado
- [[bueno-s-house]]
- [[comanda-digital-srs]]
- [[comanda-digital-estado]]
