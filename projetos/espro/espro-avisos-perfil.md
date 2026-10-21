---
name: espro-avisos-perfil
description: ESPRO — avisos com app fechado (Web Push sem payload + VAPID automático), e-mail automático via Resend, lembrete diário de prazo, perfil (foto/função/bio) e organograma (2026-10-21)
tags: [projeto, proj/espro, push, email, perfil, organograma]
updated: 2026-10-21
---

# ESPRO — Avisos, e-mail e organograma (ideias 1, 2 e 34)

Hub: [[espro]] · Plano: [[espro-40-ideias]] · Fluxo: [[espro-fluxo-tarefas]] · Dados: [[espro-dados]].

## 1. Avisos com o app fechado (Web Push)
- **Sino** no topo (`#avisos-btn`, `js/avisos.js`) com contador; abre a caixa de avisos (vinda do servidor) e o botão **Ativar avisos**. Faixa "Receba as tarefas no celular" no Início até ativar (ou "Agora não").
- `sw.js` na raiz: só trata `push` e `notificationclick`, **sem cache do app** (nunca serve versão velha).
- **Push sem conteúdo**: o servidor manda só o "toque" com VAPID; o SW busca o texto em `GET /api/avisos` usando o token que o app guarda no **Cache Storage** (`espro-sw` → `/__auth`), porque o SW não lê o localStorage. Assim não precisa criptografar o payload.
- **Chaves VAPID** geradas sozinhas e guardadas em `config('vapid')`. Inscrição em `push_subs`; endpoint 404/410 é apagado.
- **O que gera aviso** (`eventosDoCartao` em `functions/_lib/avisos.js`, calculado no `sync` comparando antes/depois do cartão; o autor não é avisado): novo repasse → responsáveis; conclusão → quem repassou (`repasse.porEmail`, novo); nova cobrança → responsáveis; **prazo hoje/amanhã** → responsáveis (`lembretesDePrazo`, 1x por dia, puxado pela 1ª requisição autenticada do dia, já que o Pages não tem cron).
- Rotas: `GET /api/avisos`, `POST /api/avisos/lidos`, `GET /api/push/chave`, `POST|DELETE /api/push/inscrever`, `POST /api/push/teste`. Envio em `waitUntil` (não atrasa a resposta).
- **iPhone:** só funciona com o ESPRO adicionado à Tela de Início (iOS 16.4+). Ícone novo `icon-192.png`/`icon.svg` no manifesto.

## 2. E-mail automático (Resend)
- Variáveis no painel do Pages: `RESEND_API_KEY`, `EMAIL_FROM` (domínio verificado no Resend), opcional `SITE_URL`. **Sem a chave, nada quebra:** só não manda e-mail.
- E-mail sai junto do aviso para **repasse** e **prazo**; a **cobrança formal** ganha o botão "Enviar pelo sistema" (só quando `ping.recursos.email` é true), via `POST /api/cobrar` — só admin/diretor/instrutor, e o destinatário vem do `respEmail` do cartão **gravado no servidor** (o cliente não escolhe para quem manda).
- `onboarding@resend.dev` (sem domínio) só entrega para o dono da conta Resend.

## 34. Perfil e organograma
- `usuarios` ganhou `funcao`, `bio`, `foto` (miniatura 160×160 JPEG em data-URL, ≤80 KB). `PUT /api/perfil` (só o próprio); `GET /api/equipe` devolve os campos.
- `js/perfil.js`: **Meu perfil** (foto, nome, função, sobre), **ficha da pessoa** (cargo, função, setores, bio, tarefas abertas visíveis, e-mail) e **Organograma** (Direção e instrução no topo → um bloco por setor com líderes e equipe → "Ainda sem setor"). Acesso para todos pelo menu da empresa (toque no nome); na aba Equipe os avatares mostram a foto e abrem a ficha.

## Testes / limites
- Testado no preview: lógica da API com repositório em memória (repasse → aviso para a Ana; conclusão → aviso para quem repassou; cobrança 403 para membro e 502 sem e-mail; perfil; lembrete 1x/dia), telas (sino, avisos, organograma, perfil) em desktop e 375 px.
- **Não testado:** entrega real de push (precisa do site publicado + celular) e envio real de e-mail (precisa da chave do Resend). D1 real.
