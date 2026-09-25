---
name: comanda-digital-plano
description: Plano de implementação faseado do SRS "Comanda Digital" sobre o Bueno's House, com base em auditoria real do código (não estimativa)
tags: [proj/bueno-s-house]
updated: 2026-09-25 (Fases 0-5 implementadas e enviadas ao GitHub; frontend de fichas técnicas/fornecedores/dashboard pendente; paginação e Swagger confirmados ausentes)
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

**Fase 6 — Usuários internos (parte do bloco 10, RF-041)**
18. `UserController`/`Service` novo (dado já modelado) para ADMIN gerenciar staff.

**Fase 7 — Polimento, NFRs e Deploy**
19. **Paginação (RNF08) — confirmado AUSENTE em 2026-09-25:** nenhum dos 23
    `@RestController` do backend usa `Pageable` (`grep -rl Pageable` no
    `src/main/java` retorna zero arquivos). Todas as listagens (pedidos,
    produtos, fornecedores, etc.) hoje devolvem a lista inteira. Bloqueia o
    bloco 5 (RF-019 "lista de pedidos paginada") do SRS — precisa ser
    implementado, não é só "conferir".
20. **Swagger/OpenAPI (RNF11) — confirmado AUSENTE em 2026-09-25:** o
    `pom.xml` não tem nenhuma dependência `springdoc-openapi` (só
    `web/data-jpa/validation/security/websocket/mysql/flyway/jjwt/lombok`).
    Não existe `/swagger-ui.html` hoje. Precisa adicionar
    `springdoc-openapi-starter-webmvc-ui` e liberar a rota no
    `SecurityConfig` (`/v3/api-docs/**`, `/swagger-ui/**` públicos). DTOs e
    `@ControllerAdvice` continuam atendidos (confirmado nas auditorias
    anteriores, Cap. 04/07).
21. DER visual exportado (entregável extra).
22. Deploy: banco gerenciado + backend + frontend Angular + CORS de produção — testar cedo
    (planos gratuitos têm pegadinhas).
23. README com URLs de produção + seed `admin@email.com`/`senha123`.

### Envio ao GitHub (2026-09-25)

Commit `f94d684` (48 arquivos) enviado para `origin/feat/migracao-angular` em
[github.com/Joaovsr98/Bueno-sHouse](https://github.com/Joaovsr98/Bueno-sHouse). Sem conflito
(branch estava atualizada antes do fetch). **Compilação ainda não verificada** — próximo
passo obrigatório antes de confiar no branch é rodar `mvn -Dmaven.test.skip=true compile` e
`npm run build` localmente.

### Ordem de execução recomendada

Fase 0 → Fase 1 (fecha o maior gap de nota, blocos 1+2) → Fase 2 (maior risco técnico, fazer
cedo) → Fase 4 (rápida) → Fase 3 (mais trabalhosa, do zero) → Fase 5 → Fase 6 → Fase 7/Deploy
por último, mas testar deploy pelo menos uma vez com antecedência.

## Relacionado
- [[bueno-s-house]]
- [[comanda-digital-srs]]
- [[comanda-digital-estado]]
