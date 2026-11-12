---
name: comanda-digital-srs
description: SRS v3.2 (Ago/2026) do trabalho acadêmico "Comanda Digital" — UNASP, Prof. Thiago Silva — especificação completa de requisitos, modelo de dados, regras de negócio e roteiro de entrega
tags: [proj/bueno-s-house]
updated: 2026-09-25
---

# Comanda Digital — Guia Base do Projeto (SRS v3.2)

## Contexto

Especificação oficial do professor (UNASP SP, Análise e Desenvolvimento de Sistemas, Prof.
Thiago Silva) para o trabalho acadêmico até agora chamado internamente de **"DaHorta"** em
[[bueno-s-house]] — este SRS v3.2 (Ago/2026) é a versão formal e detalhada desse mesmo
trabalho, com nome **"Comanda Digital"**. Documento recebido na íntegra em 2026-09-25 e
transcrito aqui como referência canônica; ver [[comanda-digital-estado]] para o comparativo
"o que o Bueno's House já cobre vs. o que falta" e status por bloco de nota.

Repositório de trabalho: `C:\Users\v.tozeti\Desktop\Vitor\teste\thiagolas\Bueno-sHouse`
(cópia deste guia já existe lá em `comanda-digital-guia-base.md`).

## Conteúdo

### 1. Visão geral

Sistema web full-stack (**Angular + Spring Boot + MySQL/PostgreSQL**) para gerenciar uma
**Dark Kitchen** (cozinha sem salão, só delivery). Duas frentes:

| Frente | Quem usa | O que faz |
|---|---|---|
| Loja (público) | Cliente final | Cardápio, carrinho, login/cadastro, pedido, status, histórico |
| Painel Admin | Admin, Gerente, Cozinheiro | Cardápio/fichas técnicas, pedidos, estoque, fornecedores, compras, dashboard |

Coração do sistema: **ficha técnica** — cálculo automático de custo por prato e **food cost
(%)**, com **baixa automática de estoque** a cada pedido confirmado (margem de dark kitchen é
apertada).

Entrega: sistema **no ar** (deploy em nuvem, front+back+banco), **entrega individual**
(mesmo em dupla — cada um envia seu próprio repositório + vídeo pitch de 5 min no YouTube).

### 2. Perfis de usuário (atores)

| Perfil | Quem é | Faz o quê | Como é criado |
|---|---|---|---|
| `CLIENTE` | Consumidor final | Cardápio, carrinho, pedido, status, histórico | Cadastro público (`/register`) |
| `ADMIN` | Dono da cozinha | Tudo | Seed no banco (Flyway) |
| `GERENTE` | Operações | Pedidos, estoque, fornecedores, dashboard | Criado pelo ADMIN |
| `COZINHEIRO` | Prepara pratos | Pedidos pendentes, muda status (CONFIRMADO→EM_PREPARO→PRONTO) | Criado pelo ADMIN |

Regra chave: `CLIENTE` nunca acessa o painel admin. RBAC obrigatório (`@PreAuthorize` no
back, `Guards` no Angular).

### 3. Stack obrigatória (não pode trocar)

Back: Spring Boot 3.x + Java 17+, Spring Data JPA/Hibernate (nunca `ddl-auto=create`),
Spring Security + JWT (expira 8h), Bean Validation, SpringDoc OpenAPI/Swagger em
`/swagger-ui.html`, Flyway. Front: Angular 17+, TypeScript, Angular Material/PrimeNG/
Bootstrap (livre), `HttpClient`+Interceptor (injeta JWT), Reactive Forms
(`FormGroup`/`FormArray` para ficha técnica), Angular Router + `AuthGuard`+`RoleGuard`,
Chart.js (ng2-charts) no dashboard. Banco: **MySQL 8+ ou PostgreSQL 15+** (um só, do início
ao fim).

Pacotes obrigatórios no back-end: `controller/`, `service/` (regra de negócio SEMPRE aqui),
`repository/`, `model/entity/`, `dto/` (nunca retornar `@Entity` direto), `config/`,
`exception/` (`@ControllerAdvice`).

Deploy: back em Render/Railway/Fly.io, front em Vercel/Netlify, banco gerenciado (Railway/
Render/Aiven/Neon/Clever Cloud — nunca dentro do back), CORS liberado para domínio de
produção + `localhost:4200` em dev. ⚠️ Planos gratuitos hibernam — acordar antes do vídeo/
apresentação.

### 4. Modelo de dados

**Tabelas (Flyway, `snake_case`):** `usuario`, `categoria`, `prato`, `ingrediente`,
`ficha_tecnica`, `ficha_tecnica_item`, `fornecedor`, `fornecedor_produto`, `pedido_compra`,
`pedido_compra_item`, `pedido`, `pedido_item`, `estoque_movimentacao`. Colunas-chave de cada
uma estão na versão completa deste guia em `comanda-digital-guia-base.md` (repositório do
projeto) — resumo dos relacionamentos:

- `usuario (CLIENTE)` 1:N `pedido`; `pedido` 1:N `pedido_item` N:1 `prato`
- `prato` 1:1 `ficha_tecnica` 1:N `ficha_tecnica_item` N:1 `ingrediente`
- `pedido → CONFIRMADO` gera `estoque_movimentacao` (baixa automática via ficha técnica)
- `pedido_compra → RECEBIDO` gera `estoque_movimentacao` (entrada automática)
- `fornecedor` N:N `ingrediente` (via `fornecedor_produto`)

📌 Entregável extra: DER visual (dbdiagram.io/DBeaver), salvo como imagem no repositório.

**Fórmulas de negócio (no Service, nunca no Controller):**
```
custo_prato   = SUM(quantidade × fator_correcao × custo_unitario_ingrediente) / rendimento
food_cost (%) = (custo_prato / preco_venda) × 100
```
Semáforo do food cost: verde ≤30% · amarelo 31–35% · vermelho >35%.

### 5. Requisitos funcionais (RF) — por módulo

Prioridade ALTA = obrigatório para nota; MÉDIA = importante, não reprova.

- **5.1 Área do Cliente:** RF-001 cardápio público c/ filtro categoria (ALTA) · RF-002
  detalhe do prato + adicionar ao carrinho (ALTA) · RF-003 carrinho completo (ALTA) ·
  RF-004 cadastro cliente, email único (ALTA) · RF-005 login JWT, redireciona ao checkout
  (ALTA) · RF-006 checkout c/ resumo+endereço+pagamento simulado (ALTA) · RF-007 timeline de
  status RECEBIDO→CONFIRMADO→EM_PREPARO→PRONTO→SAIU_ENTREGA (ALTA) · RF-008 histórico "Meus
  Pedidos" (MÉDIA).
- **5.2 Cardápio & Fichas Técnicas:** RF-009 CRUD categorias (ALTA) · RF-010 CRUD pratos
  (ALTA) · RF-011 ficha técnica (ingredientes+qtd+unidade+fator correção+rendimento) (ALTA) ·
  RF-012 custo automático em tempo real (ALTA) · RF-013 food cost com semáforo (ALTA) ·
  RF-014 modo de preparo texto livre (MÉDIA).
- **5.3 Pedidos & Cozinha:** RF-015 pedido novo entra RECEBIDO (ALTA) · RF-016 ciclo de
  status completo + CANCELADO (ALTA) · RF-017 baixa automática de estoque ao CONFIRMAR,
  `@Transactional` (ALTA) · RF-018 cancelamento c/ estorno + motivo obrigatório (ALTA) ·
  RF-019 lista de pedidos paginada c/ filtros (ALTA) · RF-020 detalhe do pedido (MÉDIA).
- **5.4 Fornecedores & Compras:** RF-021 CRUD fornecedores c/ validação CNPJ (ALTA) ·
  RF-022 catálogo por fornecedor (ALTA) · RF-023 cotação comparativa entre fornecedores
  (ALTA) · RF-024 pedido de compra RASCUNHO→ENVIADO→RECEBIDO (ALTA) · RF-025 recebimento →
  entrada estoque + atualiza custo (ALTA) · RF-026 histórico de preços c/ gráfico (MÉDIA).
- **5.5 Controle de Estoque:** RF-027 CRUD ingredientes (ALTA) · RF-028 entrada de estoque
  auto/manual (ALTA) · RF-029 saída automática via ficha técnica (ALTA) · RF-030 saída
  manual (perdas) c/ motivo obrigatório (ALTA) · RF-031 saldo em tempo real (ALTA) · RF-032
  alertas de estoque mínimo (ALTA) · RF-033 log de movimentações (MÉDIA).
- **5.6 Dashboard:** RF-034 KPIs do dia (faturamento, pedidos, ticket médio, food cost médio)
  (ALTA) · RF-035 top 5 pratos mais vendidos, gráfico de barras (ALTA) · RF-036 alertas de
  estoque no dashboard (ALTA) · RF-037 vendas por período, gráfico de linha (MÉDIA).
- **5.7 Autenticação & Usuários:** RF-038 login único, JWT c/ role no payload (ALTA) ·
  RF-039 cadastro público só cria CLIENTE (ALTA) · RF-040 RBAC `@PreAuthorize`+Guards (ALTA)
  · RF-041 CRUD de usuários internos pelo Admin (ALTA) · RF-042 HttpInterceptor JWT + trata
  401 (ALTA) · RF-043 `AuthGuard`+`RoleGuard` (ALTA).

### 6. Regras de negócio (RN) — sempre no Service

RN01 prato só ATIVO com ficha técnica ≥1 ingrediente · RN02 food cost >35% → aviso, não
bloqueia · RN03 estoque insuficiente → 422 informando o que falta · RN04 cancelamento livre
antes de EM_PREPARO, depois só GERENTE/ADMIN · RN05 recebimento de compra atualiza custo
unitário · RN06 soft delete sempre (`status=INATIVO`), nunca `DELETE` físico · RN07 validar
CNPJ · RN08 fator de correção ≥1.0 · RN09 cardápio público só mostra pratos ATIVO · RN10
email único (409 se já existir).

### 7. Requisitos não funcionais (RNF)

RNF01 BCrypt, senha nunca no JSON · RNF02 JWT 8h + `@PreAuthorize` · RNF03 CORS · RNF04
Controller→Service→Repository, lógica só no Service · RNF05 DTOs, nunca `@Entity` exposta ·
RNF06 `@ControllerAdvice` padronizado · RNF07 Flyway (nunca `ddl-auto=create`) · RNF08
paginação (`Pageable`) em todas as listagens · RNF09 responsivo (desktop+tablet) · RNF10
loading+toasts · RNF11 Swagger público em `/swagger-ui.html` · RNF12 segredos via env vars ·
RNF13 README com URLs de produção + instruções.

### 8. Endpoints da API (contrato REST)

Público: `POST /api/auth/login`, `POST /api/auth/register`, `GET /api/cardapio`,
`GET /api/cardapio/{id}`. CLIENTE: `POST /api/pedidos`, `GET /api/pedidos/meus`,
`GET /api/pedidos/{id}/status`. ADM/GER/COZ: `GET /api/admin/pedidos`,
`PATCH /api/admin/pedidos/{id}/status`, `PATCH .../cancelar` (ADM/GER). ADM/GER: CRUD
`categorias`, `pratos`, `GET /api/admin/pratos/{id}/custo`,
`GET/POST/PUT /api/admin/pratos/{id}/ficha`, CRUD `ingredientes`,
`GET /api/admin/estoque/saldo`, `.../alertas`, `POST .../movimentacao`, CRUD
`fornecedores`, `GET /api/admin/cotacao/{ingredienteId}`, CRUD `compras`,
`POST /api/admin/compras/{id}/receber`, `GET /api/admin/dashboard/resumo`,
`.../top-pratos`. ADM apenas: CRUD `usuarios`.

### 9. Fluxos do sistema

- **Cliente pede:** Cardápio (público) → Detalhe → Carrinho local → Login/Cadastro (se
  preciso) → Checkout (valida estoque) → Pedido RECEBIDO → Acompanhamento.
- **Cozinha processa:** RECEBIDO → (Gerente confirma) CONFIRMADO [baixa estoque automática]
  → (Cozinheiro) EM_PREPARO → PRONTO → (Gerente) SAIU_ENTREGA → FINALIZADO.
- **Compras:** Alerta de estoque baixo → Cotação comparativa → Pedido de compra
  (RASCUNHO→ENVIADO) → Recebimento (RECEBIDO) [entrada estoque + atualiza custo] → Food cost
  recalculado.

### 10. Roteiro de implementação sugerido (12 passos)

1. Setup (Spring Boot + Angular + banco local via env vars). 2. Modelagem Flyway (`V1`
   tabelas, `V2` seed: admin `admin@email.com`/`senha123` + dados de exemplo) + DER visual.
3. Auth/RBAC (JWT, register/login, `@PreAuthorize`, interceptor+guards Angular).
4. Domínio central: cardápio+ficha técnica (CRUDs, cálculo de custo/food cost,
   `FormArray`). 5. Loja pública (cardápio, detalhe, carrinho, cadastro/login). 6. Pedido +
   fluxo transacional (checkout valida estoque, baixa automática `@Transactional` ao
   CONFIRMAR, cancelamento+estorno, telas de acompanhamento/histórico/painel cozinha).
7. Fornecedores e compras (CRUD+CNPJ, catálogo, cotação, RASCUNHO→ENVIADO→RECEBIDO).
8. Estoque completo (saldo, alertas, saída manual, log). 9. Dashboard (KPIs, top 5, vendas
   por período, alertas). 10. Polimento/NFRs (`@ControllerAdvice`, DTOs, paginação,
   responsividade, Swagger). 11. Deploy (banco gerenciado, back, front, CORS, aquecer antes
   de usar). 12. Entrega (README c/ URLs, vídeo pitch 5min individual, link repo+vídeo).

### 11. Critérios de avaliação (Sprint Final = 20% da média = 2,0 pontos)

Stack correta (0,5 — zera se trocar) · Sistema no ar (0,5 — zera se URL não acessível na
avaliação) · Funcionalidades (1,0 — 10 blocos de 0,1, cada bloco só pontua se **todos** os RF
ALTA do bloco estiverem completos):

1. Cardápio público e carrinho (RF-001 a 003) · 2. Jornada do pedido do cliente (RF-004 a
008) · 3. CRUD de cardápio (RF-009, 010, 014) · 4. Ficha técnica e custos (RF-011 a 013) ·
5. Pedidos e cozinha (RF-015, 016, 019, 020) · 6. Integração pedido-estoque (RF-017, 018) ·
7. Fornecedores e compras (RF-021 a 026) · 8. Controle de estoque (RF-027 a 033) ·
9. Dashboard (RF-034 a 037) · 10. Autenticação e RBAC (RF-038 a 043).

### 12. Regras gerais de entrega

Entrega **individual obrigatória** (repositório + vídeo), mesmo em dupla — quem não enviar
fica sem nota. Vídeo YouTube (pode ser não listado), **exatamente 5 minutos**, 3min30
vendendo o sistema funcionando + 1min30 código/deploy. Seed obrigatório
`admin@email.com`/`senha123` + dados de exemplo. IA é permitida, mas é preciso saber explicar
qualquer trecho do código. Plágio = zero para todos os envolvidos. Atraso até 1 semana =
−20%; depois disso, não é mais aceito.

### 13. Checklist final de conferência

Front/back/banco publicados e acessíveis por URL pública · Swagger em `/swagger-ui.html` ·
login funcionando para os 4 perfis com JWT · nenhuma senha em response JSON · todos os CRUDs
com soft delete · cálculo de custo/food cost correto em tempo real · baixa automática de
estoque testada (CONFIRMADO) · cancelamento com estorno testado · todas as listagens
paginadas · CORS liberado para produção · README com URLs+instruções · DER anexado · vídeo
dentro de 5min com as 2 partes · link do repo e do vídeo enviados individualmente.

## Relacionado
- [[bueno-s-house]]
- [[comanda-digital-estado]]
