---
name: bueno-s-house-dados
description: mapa de localização de dados do Bueno's House / Comanda Digital — repositório, banco MySQL, migrations Flyway, endpoints REST, credenciais demo e ambiente local
tags: [projeto, proj/bueno-s-house, dados, mysql, api]
updated: 2026-09-29
---

# Bueno's House — Onde os dados vivem

Mapa de **localização** (não de regra de negócio) do [[bueno-s-house]]. Consolidado a partir das
notas já existentes do vault; nada foi lido fora da pasta do vault nesta consolidação.

## 1. Repositório e código
- **Pasta local:** `C:\Users\v.tozeti\Desktop\Vitor\teste\thiagolas\Bueno-sHouse` (fora do vault).
- **Remoto GitHub:** `Joaovsr98/Bueno-sHouse` — branch de trabalho `origin/feat/migracao-angular` (commit `f94d684`, 48 arquivos, 2026-09-25). Ver [[comanda-digital-plano]].
- **Pastas:** `backend/` (Spring Boot), `frontend/` (React+TS+Vite, staff), `frontend-angular/` (Angular 20, jornada do Cliente), `docker-compose.yml`, `CONTINUAR-PROJETO.md`, `comanda-digital-guia-base.md`.

## 2. Banco de dados
- **MySQL 8.4** nativo no Windows (não roda como serviço — iniciar manualmente a cada boot); em Docker via `docker-compose.yml`.
- **Migrations Flyway** (Maven): `V11__inventory.sql` (estoque/ficha técnica base), `V14__ficha_tecnica_custo.sql` (`correction_factor` em `recipe_items`), `V15__fornecedores_compras.sql` (`supplier_products`, `purchases.status`).
- **Entidades chave** por módulo: `catalog` (Categoria/Produto), `inventory` (`InventoryItem`, `StockMovement`, `Purchase`, `Recipe`/`RecipeItem`, `supplier_products`), `ordering`, `customers`, `identity` (User/perfis), `reports` (JPQL via `EntityManager`).
- **Hibernate:** `SPRING_JPA_HIBERNATE_DDL_AUTO=none` localmente (validação estrita desligada por divergência JPA × Flyway).

## 3. Credenciais e configuração
- `.env` real do backend fica no repo local, coberto pelo `.gitignore` (aqui só nomes de variável, nunca valores).
- Usuário demo do seed: `admin@demo.local` (senha de demonstração em [[comanda-digital-plano]]; **não** `admin@email.com`).
- Auth: JWT + BCrypt + bloqueio por tentativas; WebSocket/STOMP autenticado por JWT.

## 4. Endpoints REST principais
| Grupo | Rotas |
|---|---|
| Auth | `POST /api/auth/register` (público, RN10), login |
| Catálogo (público, RN09) | `GET /api/categories`, `/api/products`, `/api/units` |
| Pedidos | `POST /api/orders`, `GET /api/orders/mine`, `GET /api/orders/{id}`, `GET /api/orders?unitId&page&size`, `/orders/{id}/transition`, `/orders/{id}/cancel` |
| Estoque | `GET/POST /api/inventory/recipes/{productId}`, `below-minimum` |
| Fornecedores/Compras | `/api/suppliers`, `/api/suppliers/{id}/products`, `/api/suppliers/quote?inventoryItemId=`, `/api/purchases` (`send`, `receive`) |
| Relatórios | `/api/reports/daily-revenue`, `average-ticket`, `top-products`, `low-stock`, `average-food-cost` |
| Usuários (ADMIN) | `/api/users` |

## 5. Ambiente local
JDK 21 + Maven 3.9 + MySQL 8.4 nativos; `mvn test` (Testcontainers) e `npm run build` nunca validados nesta máquina.

## Relacionado
- [[bueno-s-house]] — hub do projeto
- [[comanda-digital-srs]] · [[comanda-digital-estado]] · [[comanda-digital-plano]]
- [[mapa-dados]] · ⭐[[mapa-projetos]]
