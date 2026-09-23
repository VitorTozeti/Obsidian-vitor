---
name: megabrain-indice
description: mapa de competências técnicas prioritárias, cobertas e pendentes para orientar a expansão do vault quando o Megabrain for ativado
tags: [megabrain, referencia, arquitetura, desenvolvimento]
updated: 2026-09-10
---

# Megabrain - Índice de Contextos

> Contexto restrito. Leia este arquivo somente quando a mensagem atual do usuário
> contiver `Use o megabrain`. A ativação não persiste para a próxima mensagem.

## Arquitetura de Software e Design Systems

| Tópico | Estado | Direção |
|---|---|---|
| Arquitetura orientada a eventos | Parcial | Criar nota própria. |
| Microsserviços vs. monólitos | Coberto | `software-architecture-design-patterns.md`. |
| Padrões de resiliência | Lacuna crítica | Circuit Breaker, Retry, Bulkhead e Timeout. |
| Domain-Driven Design | Lacuna crítica | Linguagem ubíqua, Bounded Contexts e agregados. |
| Arquitetura hexagonal | Coberto | `software-architecture-design-patterns.md`. |
| CQRS e Event Sourcing | Lacuna crítica | Separação de leitura/escrita e eventos como estado. |
| Padrões de API | Coberto | REST e GraphQL em `api-development`. |

## Cloud, DevOps e SRE

| Tópico | Estado | Direção |
|---|---|---|
| Infraestrutura como código | Lacuna | Terraform, Bicep e Pulumi. |
| Contêineres e orquestração | Coberto | Expandir Kubernetes quando necessário. |
| CI/CD avançado | Parcial | GitOps, Blue/Green e Canary. |
| FinOps | Lacuna | Otimização de custos em Azure e AWS. |
| Observabilidade | Coberto | OpenTelemetry e tracing. |
| Estratégias de deploy | Parcial | Nota própria sobre Blue/Green, Canary e feature flags. |
| Serverless | Lacuna | Azure Functions e Lambda. |
| Multi-cloud e híbrido | Lacuna | Gerenciamento entre provedores. |

## Engenharia de Dados e Analytics

| Tópico | Estado | Direção |
|---|---|---|
| Data warehouse vs. data lake | Lacuna | Arquiteturas, medalhões e modelagem dimensional. |
| Batch e streaming | Lacuna | Spark, Kafka, Flink e decisões de latência. |
| Modelagem analítica | Parcial | Kimball e Data Vault. |
| Governança e qualidade | Lacuna | Catálogos, master data e qualidade. |
| ETL/ELT | Coberto | `data-engineering-etl-best-practices.md`. |
| Bancos vetoriais | Lacuna | Pinecone, pgvector, Milvus, embeddings e RAG. |

## Inteligência Artificial e Machine Learning

| Tópico | Estado | Direção |
|---|---|---|
| Fundamentos de ML | Lacuna | Aprendizado supervisionado, não supervisionado e validação. |
| Large Language Models | Lacuna crítica | Tokens, janelas de contexto, prompting e fine-tuning. |
| RAG | Lacuna crítica | Recuperação aumentada e aplicação com LLMs. |
| MLOps | Lacuna crítica | Ciclo de vida, experimentos e versionamento. |
| Fine-tuning | Parcial | Aprofundar critérios e processo. |
| Agentes autônomos | Lacuna | LangChain, LlamaIndex e AutoGen. |

## Segurança e DevSecOps

| Tópico | Estado | Direção |
|---|---|---|
| Zero Trust | Lacuna | Princípios e implementação. |
| IAM, OAuth2 e OIDC | Parcial | Aprofundar além de `api_auth.md`. |
| Criptografia | Lacuna | Simétrica, assimétrica, hash e gestão de chaves. |
| OWASP Top 10 | Parcial | Detalhar cada categoria. |
| Testes de segurança | Coberto | SAST, DAST, SCA e gates de CI. |
| LGPD e GDPR | Lacuna | Conformidade e privacidade. |

## Algoritmos, Estruturas e Performance

| Tópico | Estado | Direção |
|---|---|---|
| Estruturas avançadas | Parcial | B-trees, tries e grafos. |
| Big-O | Coberto | `big_o_complexity.md`. |
| Algoritmos de grafo | Parcial | BFS e DFS em nota dedicada. |
| Concorrência e assíncrono | Coberto | `js_async.md` e `py_async.md`. |
| Estratégias de cache | Coberto | `performance-caching-best-practices.md`. |
| Profiling e benchmarking | Lacuna | Ferramentas e metodologia. |

## Desenvolvimento Web e Frontend

| Tópico | Estado | Direção |
|---|---|---|
| Web performance e Core Web Vitals | Lacuna | LCP, FID, CLS e otimização. |
| Progressive Web Apps | Lacuna | Service workers, offline e instalação. |
| Micro-frontends | Lacuna | Arquitetura e Module Federation. |
| WebAssembly | Lacuna | Fundamentos e casos de uso. |
| Acessibilidade web | Parcial | Implementação de ARIA e componentes. |

## Gestão Tecnológica e Metodologias

| Tópico | Estado | Direção |
|---|---|---|
| Metodologias ágeis | Coberto | Scrum, Kanban, Shape Up e testes ágeis. |
| DORA Metrics | Lacuna | Frequência de deploy, lead time, MTTR e taxa de falha. |
| System Design Interviews | Lacuna | Framework e exemplos práticos. |
| Escrita técnica e ADRs | Lacuna | Registros de decisão e documentação. |
| Gestão de incidentes | Lacuna | Post-mortems sem culpabilização e causa raiz. |
| Prompt engineering | Lacuna crítica | Few-shot, estruturação e técnicas de prompt. |

## Prioridades de expansão

1. Padrões de resiliência, DDD, CQRS e Event Sourcing.
2. Infraestrutura como código, FinOps, deploy, serverless e multi-cloud.
3. Fundamentos de ML, LLMs, RAG, MLOps, fine-tuning e agentes autônomos.
4. Segurança avançada, dados, web performance e gestão tecnológica.

## Relacionado

- [Política de ativação](../MEGABRAIN.md)
- [Índice mestre do vault](../_INDEX.md)
