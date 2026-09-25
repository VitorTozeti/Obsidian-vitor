---
name: comanda-digital-plano
description: Plano de implementação faseado do SRS "Comanda Digital" sobre o Bueno's House, com base em auditoria real do código (não estimativa)
tags: [proj/bueno-s-house]
updated: 2026-09-25
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

**Fase 0 — Fundação (bloqueante)**
1. `git init` + `.gitignore` (nessa ordem) — aguardando aprovação da usuária.
2. Rodar `mvn test` de verdade pelo menos uma vez (precisa Docker/Testcontainers).
3. Decidir consolidar em Angular e descontinuar o frontend React.

**Fase 1 — Auth do Cliente (fecha blocos 1+2 do SRS, RF-001 a 008)**
4. `POST /api/auth/register` público → cria `User` (perfil CLIENTE) + `Customer` vinculado.
5. Liberar `GET /api/categories`/`GET /api/products` sem login (RN09: só ativos).
6. Validar ownership de `/api/orders/*` já existente após ligar o cadastro público.

**Fase 2 — Ficha técnica e custo (bloco 4, RF-011 a 013 — maior risco técnico)**
7. Migration: `fator_correcao` em `recipe_items`, `rendimento` em `recipes`.
8. Serviço de cálculo: `custo_prato = Σ(quantidade × fator_correcao × custo_unitario) /
   rendimento`; `food_cost% = custo_prato/preco_venda × 100` com semáforo (RN02: >35% só
   avisa).
9. Endpoint de custo por produto + tela Angular com `FormArray` para a ficha técnica.

**Fase 3 — Fornecedores e Compras (bloco 7, RF-021 a 026 — do zero)**
10. Entidade `SupplierProduct` (fornecedor×ingrediente×preço×unidade).
11. `SupplierController`/`Service` + validação de CNPJ (criar validador).
12. Cotação comparativa por ingrediente.
13. `Purchase` com itens de linha + status; ação "receber" gera `StockMovement`
    `ENTRADA_COMPRA` (mecanismo já existe) e atualiza `costPerUnit` (RN05).
14. Telas Angular correspondentes.

**Fase 4 — Estoque completo (bloco 8, RF-027 a 033 — maioria já pronta)**
15. Confirmar saída manual com motivo obrigatório, saldo em tempo real, tela de log de
    movimentações (dado já existe, falta tela).

**Fase 5 — Dashboard (bloco 9, RF-034 a 037)**
16. Backend: food-cost médio (depende da Fase 2) + vendas por período.
17. Frontend: instalar Chart.js/ng2-charts (não existe hoje) e construir a tela.

**Fase 6 — Usuários internos (parte do bloco 10, RF-041)**
18. `UserController`/`Service` novo (dado já modelado) para ADMIN gerenciar staff.

**Fase 7 — Polimento, NFRs e Deploy**
19. Confirmar paginação em todas as listagens (RNF08, não confirmado).
20. Swagger/DTOs/`@ControllerAdvice` — parecem atendidos, só conferir.
21. DER visual exportado (entregável extra).
22. Deploy: banco gerenciado + backend + frontend Angular + CORS de produção — testar cedo
    (planos gratuitos têm pegadinhas).
23. README com URLs de produção + seed `admin@email.com`/`senha123`.

### Ordem de execução recomendada

Fase 0 → Fase 1 (fecha o maior gap de nota, blocos 1+2) → Fase 2 (maior risco técnico, fazer
cedo) → Fase 4 (rápida) → Fase 3 (mais trabalhosa, do zero) → Fase 5 → Fase 6 → Fase 7/Deploy
por último, mas testar deploy pelo menos uma vez com antecedência.

## Relacionado
- [[bueno-s-house]]
- [[comanda-digital-srs]]
- [[comanda-digital-estado]]
