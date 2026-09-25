---
name: bueno-s-house
description: Sistema de gestão para restaurantes (monólito Spring Boot + Angular/React) usado como base para o trabalho acadêmico "Comanda Digital" (ex-"DaHorta")
tags: [proj/bueno-s-house]
updated: 2026-09-25
---

# Bueno's House — Sistema de Gestão para Restaurantes

## Contexto

Projeto de portfólio pessoal (não é trabalho da faculdade em si), mas está sendo
**reaproveitado como base/inspiração** para o trabalho acadêmico **DaHorta**, pedido por um
professor em capítulos sucessivos (material entregue aos poucos). A usuária deixou claro que
**não quer copiar o projeto do professor**, só usar este sistema já construído como ponto de
partida técnico.

Repositório real no disco: `C:\Users\v.tozeti\Desktop\Vitor\teste\thiagolas\Bueno-sHouse`
(fora do vault — este projeto não tem Git iniciado ainda, ver Pendências).

## Conteúdo

### O que é

Plataforma de gestão operacional ponta a ponta para restaurantes/lanchonetes/hamburguerias/
pizzarias: cardápio → mesa/atendimento/comanda → pedido → cozinha → pagamento → caixa →
delivery → motoboy → confirmação de entrega. Multiperfil (Administrador, Gerente, Caixa,
Garçom, Cozinha, Motoboy, Cliente) com RBAC.

### Stack

- **Backend:** Java 21, Spring Boot 3.3, Spring Data JPA/Hibernate, Spring Security, Flyway,
  Maven, MySQL 8.
- **Frontend staff:** React + TypeScript + Vite (`frontend/`) — existente e funcional.
- **Frontend Angular:** pasta `frontend-angular/` já existe no repo (Angular 20, standalone
  components/signals, Tailwind 4), preparada para a jornada do Cliente exigida pela faculdade.
- **Tempo real:** WebSocket + STOMP autenticado por JWT.
- **Infra:** Docker/Docker Compose.
- **Testes:** JUnit 5 + Testcontainers (MySQL real em container).

### Arquitetura

Monólito modular por domínio de negócio (`Controller → Service → Repository → JPA/JDBC →
MySQL`), módulos desacoplados por eventos de domínio: `identity, organization, catalog,
dinein, ordering, kitchen, payments, cashregister, customers, delivery, couriers, inventory,
reports, notifications`.

### O pivô acadêmico "Comanda Digital" (ex-"DaHorta")

Em 2026-08-07 a usuária trouxe capítulos de um material de faculdade descrevendo um projeto
então chamado internamente **DaHorta**: uma *dark kitchen* (sem salão), 4 atores (Cliente,
Funcionário/Cozinha, Motoboy, Dono/Administração), fluxo `received → preparing → ready →
delivering → delivered` com confirmação por código, stack obrigatória **Angular (cliente) +
Spring Boot + MySQL**.

Em 2026-09-25 a usuária trouxe o **SRS v3.2 completo e oficial** do professor, com o nome
formal **"Comanda Digital"** — muito mais detalhado (ficha técnica com food cost,
fornecedores/compras/cotação, dashboard com Chart.js, 43 requisitos funcionais, critérios de
nota por bloco). Guia completo em [[comanda-digital-srs]]; comparação com o que o Bueno's
House já cobre em [[comanda-digital-estado]] — **essas duas notas substituem o resumo abaixo
como fonte de verdade**, que fica só como contexto histórico da primeira auditoria.

Auditoria de 2026-08-07 (capítulo a capítulo: Git, MySQL, API REST, tela pura, SOLID, OWASP,
padrões GoF), contra a versão parcial do material disponível até então. Resumo:

- **Núcleo acadêmico DaHorta** (precisa estar 100% correto): Cliente, Cardápio, Pedido,
  Cozinha, Motoboy, Código de entrega, Estoque/admin — já coberto pelos módulos
  `identity/catalog/ordering/kitchen/delivery/couriers/organization/payments`.
- **Extensões do produto** (mantidas, não removidas, só fora do foco do núcleo): Salão, Mesa,
  Atendimento, Comanda, Garçom, Caixa avançado, Multiunidade.
- **Maior gap identificado:** não existe porta de entrada para o ator "Cliente" — hoje todo
  endpoint exige login de `staff`; falta autenticação própria do Cliente, permissão para criar
  o próprio pedido e checagem de propriedade em "ver meu pedido".
- **Gaps técnicos confirmados:** projeto **nunca teve Git iniciado** (sem repositório, sem
  `.gitignore` — `.env` real solto sem proteção) e **sem HTTPS** (dev local apenas, esperado).
- Decisão pendente: se a migração para Angular vale para todo o frontend staff ou só para a
  jornada do Cliente (React é preservado até essa confirmação).

### Ambiente local (nesta máquina, sem Docker)

JDK 21 + Maven 3.9 + MySQL 8.4 instalados nativamente no Windows (MySQL não roda como
serviço — precisa iniciar manualmente a cada boot). `mvn test` (Testcontainers) nunca foi
executado de fato nesta máquina; validação estrita do Hibernate foi desligada localmente
(`SPRING_JPA_HIBERNATE_DDL_AUTO=none`) por divergências de tipo entre JPA e as migrations
Flyway ainda não auditadas linha a linha.

### Pendências em aberto (na data desta nota)

1. Rodar `mvn test` de verdade pelo menos uma vez (nunca foi validado).
2. `git init` + `.gitignore` (nessa ordem) — aguardando aprovação da usuária.
3. Resolver a "porta de entrada do Cliente" (autenticação, criação de pedido, ownership).
4. Aguardando novos capítulos do material do professor para continuar a auditoria progressiva
   (processo formal já definido: capítulo novo → auditoria em 5 pontos → aprovação → só então
   código).

## Relacionado
- [[mapa-projetos]]
- [[comanda-digital-srs]]
- [[comanda-digital-estado]]
