---
name: comanda-digital-estado
description: Comparativo entre o SRS "Comanda Digital" (10 blocos de nota) e o que o Bueno's House já implementa — o que está feito, o que falta e o que ainda não foi auditado
tags: [proj/bueno-s-house]
updated: 2026-09-25 (paginação e Swagger confirmados ausentes por grep/pom.xml)
---

# Comanda Digital — Estado Atual vs. SRS

## Contexto

Este comparativo usa dois insumos: (1) a auditoria capítulo-a-capítulo já feita em
2026-08-07 contra a versão anterior/parcial do material (registrada em [[bueno-s-house]]),
que cobriu Git, MySQL, API REST, SOLID e OWASP; (2) o SRS v3.2 completo em
[[comanda-digital-srs]], recebido em 2026-09-25, que é bem mais detalhado (fornecedores,
compras, cotação, ficha técnica com fator de correção, dashboard com Chart.js, etc.) e nunca
foi auditado linha a linha contra o código real do Bueno's House. **Vários pontos abaixo
estão marcados "não auditado" e precisam de verificação no código antes de virar
compromisso.**

## Conteúdo

### Status por bloco de nota (10 blocos de 0,1 do SRS §11)

| # | Bloco | Status estimado | Observação |
|---|---|---|---|
| 1 | Cardápio público e carrinho (RF-001 a 003) | 🟡 Parcial | `catalog` existe e serve cardápio, mas hoje **exige login staff** (auditoria 2026-08-07) — SRS pede `GET /api/cardapio` **público**. Carrinho é responsabilidade do frontend, não auditado no Angular ainda. |
| 2 | Jornada do pedido do cliente (RF-004 a 008) | 🔴 Gap principal | Maior gap já identificado: não existe role `CLIENTE`, nem auto-cadastro/login de cliente, nem permissão para o Cliente criar o próprio pedido, nem checagem de ownership em "ver meu pedido". Timeline de status existe internamente (mapeamento já confirmado no backend), só falta o Cliente conseguir lê-la. |
| 3 | CRUD de cardápio (RF-009, 010, 014) | 🟢 Provavelmente atendido | `catalog` (Categoria/Produto) já tem CRUD completo com soft delete, confirmado na auditoria de 2026-08-07 (Cap. 3 MySQL). Nomenclatura de campos (`prato` vs `product`, `modo_preparo`) não bate 1:1 com o SRS — não é bloqueante, mas API/DTOs usam nomes em inglês, não `snake_case` em português como o SRS sugere para o banco. |
| 4 | Ficha técnica e custos (RF-011 a 013) | ⚪ Não auditado | O Bueno's House **não tem módulo de ficha técnica nem cálculo de custo/food cost** conhecido — não apareceu em nenhuma auditoria anterior. Este é provavelmente um módulo novo a construir, não só "ligar" algo existente. **Maior risco do bloco de maior peso funcional-financeiro do trabalho.** |
| 5 | Pedidos e cozinha (RF-015, 016, 019, 020) | 🟢 Provavelmente atendido | `ordering`+`kitchen` cobrem o fluxo completo (RECEBIDO→...→PRONTO), painel de cozinha com WebSocket/STOMP já existe. Paginação e filtros (RF-019) não confirmados. |
| 6 | Integração pedido-estoque (RF-017, 018) | 🟢 Atendido (padrão equivalente) | `inventory.InventoryService.deductForOrderItem()` já faz baixa automática e **idempotente** ao concluir item na cozinha (confirmado em detalhe no hub do projeto). Cancelamento com estorno de estoque não confirmado — SRS exige motivo obrigatório (RN18/RN04). |
| 7 | Fornecedores e compras (RF-021 a 026) | ⚪ Não auditado | Módulos `fornecedor`, `fornecedor_produto`, `pedido_compra`, cotação comparativa — nunca mencionados nas auditorias anteriores do Bueno's House. Provavelmente **não existe** e precisa ser construído do zero. |
| 8 | Controle de estoque (RF-027 a 033) | 🟡 Parcial | Módulo `inventory` existe (`InventoryItem`, `StockMovement`, `Purchase`, `Recipe`/`RecipeItem` — este último pode já ser a base da ficha técnica do bloco 4, vale investigar antes de recriar). Alertas de mínimo (`below-minimum`) já existem como endpoint. Falta confirmar saldo em tempo real, saída manual com motivo obrigatório e log completo nos moldes do SRF. |
| 9 | Dashboard (RF-034 a 037) | ⚪ Não auditado | Módulo `reports` existe (`daily-revenue`, `average-ticket`, `top-products`, `low-stock` via `EntityManager`/JPQL) — cobre boa parte dos RF-034/035/036 conceitualmente, mas não usa Chart.js/ng2-charts no frontend (não confirmado) e não tem "vendas por período" (RF-037) confirmado. |
| 10 | Autenticação e RBAC (RF-038 a 043) | 🟡 Parcial | JWT + `@PreAuthorize` + `AuthGuard`/`RoleGuard`-equivalente já existem e são robustos (BCrypt, bloqueio por tentativas, RBAC por perfil) — mas **falta a role `CLIENTE`** e o cadastro público (RF-039). CRUD de usuários internos pelo Admin (RF-041) não confirmado. |

### Já validado como sólido (não é risco)

- Camadas `Controller → Service → Repository`, DTOs nunca expõem `@Entity`, tratamento
  global de exceção, queries parametrizadas (sem SQL Injection), BCrypt, `DECIMAL` para
  dinheiro (nunca `float`) — tudo confirmado na auditoria OWASP/SOLID de 2026-08-07 e
  compatível com os RNFs do SRS.
- Baixa automática de estoque idempotente ao concluir item na cozinha — já é exatamente o
  padrão que RF-017 pede.
- Confirmação de entrega por código já validada server-side.

### Gaps de RNF confirmados em 2026-09-25 (novos, não estimativa)

- **RNF08 (paginação) — AUSENTE.** `grep -rl Pageable` nos 23 `@RestController` do backend
  não retorna nenhum arquivo: nenhuma listagem é paginada hoje (nem pedidos, nem produtos,
  nem fornecedores). Impacta diretamente RF-019 (bloco 5 do SRS).
- **RNF11 (Swagger) — AUSENTE.** `pom.xml` não tem `springdoc-openapi` nem nenhuma outra
  lib de OpenAPI; não existe `/swagger-ui.html`. Precisa ser adicionado do zero (dependência
  + liberar rota pública no `SecurityConfig`). Ver detalhe em [[comanda-digital-plano]] Fase 7.

### Gaps confirmados (herdados da auditoria anterior, ainda valem)

1. **Sem Git** — projeto nunca foi versionado, sem `.gitignore` (`.env` solto). Bloqueante
   para a entrega (SRS pede repositório individual).
2. **Sem porta de entrada para o Cliente** — sem isso, os blocos 1 e 2 (0,2 pontos) não
   fecham.
3. **`mvn test` nunca executado de fato** nesta máquina (falta Docker para Testcontainers).

### Gaps novos, específicos deste SRS (não cobertos por auditorias anteriores)

1. **Ficha técnica + cálculo de custo/food cost (bloco 4)** — não confirmado que exista;
   maior incerteza do levantamento.
2. **Fornecedores, catálogo por fornecedor, cotação comparativa, pedido de compra (bloco 7)**
   — não confirmado que exista.
3. **Dashboard com Chart.js no frontend** (RF-035/037) — backend (`reports`) parece cobrir a
   base, frontend não confirmado.
4. **Cadastro público de Cliente + CRUD de usuários internos pelo Admin** (RF-039, RF-041).
5. **Deploy em nuvem** (back+front+banco com URL pública) — nada foi feito ainda, é passo 11
   do roteiro do SRS.
6. **DER visual exportado** — entregável extra do SRS, não existe ainda.

### Próximo passo recomendado

Antes de escrever qualquer código novo: **auditar especificamente os módulos `inventory`
(`Recipe`/`RecipeItem`) e `reports`** do Bueno's House linha a linha contra RF-011/012/013 e
RF-034 a 037 — é possível que parte do "ficha técnica" e do "dashboard" já exista sob outro
nome e só precise de ajuste, não reconstrução. Só depois decidir o que é gap real (fornecedores/
compras, Cliente, deploy) vs. o que é reaproveitável. Seguir o processo já combinado com a
usuária: levantar → aprovação → só então implementar.

## Relacionado
- [[bueno-s-house]]
- [[comanda-digital-srs]]
