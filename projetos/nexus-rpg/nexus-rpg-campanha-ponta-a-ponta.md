---
name: nexus-rpg-campanha-ponta-a-ponta
description: 2026-10-20 — análise de como conduzir uma campanha do começo ao fim no Nexus RPG (sessão zero → preparação → sessões → entre sessões → final), com as ferramentas necessárias por fase, o que o app já tem e o que falta, priorizado
tags: [projeto, proj/nexus-rpg, campanha, analise, planejamento]
updated: 2026-10-20
---

# Nexus RPG — Campanha de ponta a ponta: o que precisa e o que existe (2026-10-20)

Parte do [[nexus-rpg]]. Baseada na [[pesquisa-sistemas-rpg]] (D&D, Ordem Paranormal, Tormenta20, Feiticeiros & Maldições, Fate, PF2e, CoC) e numa varredura do código da suíte de campanha (`src/master/campaign/*`, 2026-10-20).
Legenda: ✅ tem · 🟡 tem em parte / dá para improvisar · ❌ não tem.

## Campanha-exemplo usada na análise
Investigação + combate estilo **Ordem Paranormal / Feiticeiros & Maldições**: 4 jogadores, ~12 sessões em 3 arcos, recursos PV/Energia/Sanidade, técnicas, maldições como inimigos, um "relógio" de ameaça do vilão.

## Fase 0 — Escolher e montar o sistema
| Necessidade | Nexus | Onde / observação |
|---|---|---|
| Atributos, modificador estilo D&D/F&M, perícias, proficiência | ✅ | abas Atributos, Regras, Perícias |
| Recursos PV/PE/SAN, contador, gatilho a 0 | ✅ | Recursos + ⚡ Gatilhos |
| Classes/origens com fórmula de recurso, habilidades por nível, técnicas | ✅ | [[nexus-rpg-classes-origens]] + assistentes ([[nexus-rpg-morte-movimento-assistentes]]) |
| Técnicas/magias por tipo, custo, área, teste, invocação | ✅ | [[nexus-rpg-magias-tecnicas]] |
| Morte, salvamento, movimento, ações | ✅ | aba ☠️ Morte & Movimento |
| Progressão (NEX %, grau) | ✅ | Progressão (colunas viram variáveis) |
| **Graus de sucesso** (crítico ±10, CoC extremo/difícil) | ❌ | só total vs CD |
| **Pool de d20 "fica com o maior"** (Ordem Paranormal) | 🟡 | `kh` existe no motor (`2d20kh1`), mas sem modo "nº de dados = atributo" |
| **Estresse/consequências** (Fate), **ferimento grave** (CoC) | ❌ | só PV linear |
| Livro de regras para os jogadores | 🟡 | 📕 Livro existe; não gera capítulo de morte/movimento sozinho |
| Presets de sistema famoso prontos (Ordem, F&M, T20) | 🟡 | há modelos (`sistema-modelos.js`), sem presets fiéis desses jogos |

## Fase 1 — Sessão zero
| Necessidade | Nexus | Observação |
|---|---|---|
| Apresentar o mundo / tom | 🟡 | Campanha (nome, temas, resumo) + handouts |
| Criação guiada de personagem | ✅ | wizard do Jogador + ficha ao vivo |
| Levar a ficha do jogador ao Mestre | 🟡 | offline: exporta JSON → Mestre importa (sem rede, por design) |
| Ganchos/objetivos pessoais dos PJs | 🟡 | notas por jogador / caderno ligado |
| Ferramentas de segurança (linhas e véus, carta X) | ❌ | nada próprio |

## Fase 2 — Preparar a campanha e cada sessão
| Necessidade | Nexus | Observação |
|---|---|---|
| NPCs e inimigos com ficha | ✅ | Bestiário (statblock com recursos do sistema) |
| Mapas com tokens, grade, névoa/ocultos | ✅ | Mesa (imagem + tokens, ocultos) |
| Notas do Mestre ligadas a NPC/mapa/jogador | ✅ | Caderno |
| Tabelas aleatórias (encontro, loot, rumor, nome) | ✅ | Ferramentas |
| Calculadora de encontro | ✅ | Ferramentas |
| Relógios de ameaça | ✅ | Ferramentas (com "mostrar aos jogadores") |
| **Arcos, missões e pistas** (investigação: pista → cena → revelação) | ❌ | só texto livre no caderno/prep |
| **Facções e relações** (reputação, atitude) | ❌ | — |
| **Calendário / tempo do jogo** | ❌ | — |
| Roteiro da sessão (cenas planejadas) | 🟡 | campo `prep` (texto) |

## Fase 3 — Durante a sessão
| Necessidade | Nexus | Observação |
|---|---|---|
| Iniciar sessão, cronômetro, linha do tempo | ✅ | Sessões e diário |
| Tela dos jogadores (2ª janela/projetor) filtrada | ✅ | Apresentação (sem segredos, PV de inimigo vira "Ferido") |
| Iniciativa, rodadas, sincronia com token | ✅ | Combate/iniciativa |
| Rolagem do Mestre (visual, secreta, histórico) | ✅ | Dados |
| Ficha do jogador interativa (técnicas, recursos, morte, ações) | ✅ | ficha em modo jogo |
| **Aplicar dano/condição da técnica direto no inimigo** | ❌ | resultado é informativo; Mestre digita à mão |
| **Invocações na iniciativa** | ❌ | pendência registrada |
| **Inimigos com regra de morte do sistema** | ❌ | bestiário só PV |
| Teste de Sanidade com perda X/Y | 🟡 | dá com recurso + Dano manual; sem botão "perda X/Y" |
| Deslocamento medido no mapa | ❌ | grade existe, sem régua/alcance do token |
| Jogadores em outro computador ao vivo | ❌ | offline por design (CSP `connect-src 'none'`) — só mesma máquina/projetor |

## Fase 4 — Entre sessões
| Necessidade | Nexus | Observação |
|---|---|---|
| Resumo "da última vez" | ✅ | diário |
| XP do grupo e loot | ✅ | Ferramentas + Itens |
| **Subir de nível guiado** (o que ganhou, escolhas novas) | 🟡 | muda o nível e as escolhas destravam; sem tela "Subiu de nível!" |
| Descanso curto/longo | ✅ | ficha |
| Backup e exportar campanha | ✅ | `.campanha` + lembrete |

## Fase 5 — Clímax e fim
| Necessidade | Nexus | Observação |
|---|---|---|
| Combate final com fases/lendário | 🟡 | gatilhos de recurso servem para fase; sem "ação lendária" |
| Epílogo por personagem | 🟡 | handouts/diário |
| Arquivo final (diário + fichas + mapas) | 🟡 | export `.campanha`; sem "livro da campanha" em PDF |

## Veredito
O Nexus **já roda uma campanha inteira de forma efetiva** para um Mestre presencial: monta o sistema, cria personagens, prepara NPCs/mapas/tabelas/relógios, conduz a sessão com tela dos jogadores e iniciativa, e registra diário/XP/loot. O que falta não impede jogar — obriga o Mestre a fazer à mão:

### Prioridade (impacto × esforço)
1. **Ligar ficha ↔ combate**: aplicar dano/condição/teste da técnica no alvo da iniciativa; invocações entram na ordem; inimigos usam a regra de morte. *(maior ganho no jogo ao vivo)*
2. **Missões, pistas e arcos** (+ facções simples): quadro de missões com estados e pistas ligadas a NPC/local — essencial para Ordem Paranormal/CoC (investigação).
3. **Modos de dados**: graus de sucesso (PF2e/CoC), pool "N d20 fica com o maior" (Ordem), botão de Sanidade X/Y.
4. **Subir de nível guiado** e **capítulo automático** de morte/movimento no 📕 Livro.
5. **Presets fiéis** de Ordem Paranormal / Feiticeiros & Maldições / Tormenta20 (depende de conferir regras no livro — ver lacunas em [[pesquisa-ordem-paranormal]] e [[pesquisa-feiticeiros-e-maldicoes]]).
6. Menores: ferramentas de segurança, calendário, régua de alcance no mapa, livro-da-campanha em PDF.

Fora de escopo por decisão de projeto: jogo online multi-computador (app é 100% offline).
