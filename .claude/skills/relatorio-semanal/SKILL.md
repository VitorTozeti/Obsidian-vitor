---
name: relatorio-semanal
description: >-
  Rodada semanal do Relatório Comercial de ponta a ponta com UM comando (rodar_semanal.py):
  atualiza as bases (ETL), gera os relatórios de Diretoria, Nacional, Regional e Vendedor
  (inclusive Franquias), converte os PDFs e envia os e-mails — primeiro em SANDBOX (QA) e,
  depois da validação do usuário, em PROD com os mesmos arquivos. Use quando o usuário pedir
  para "rodar o relatório comercial", "atualizar os dados e enviar os relatórios", "mandar o
  semanal", "rodar em QA/sandbox", "enviar com o Elite", "enviar sem IA", "mandar em prod"
  ou "reenviar os que falharam".
---

# Relatório semanal (ponteiro)

A skill de verdade mora no repositório do relatório comercial, junto com o código que ela
roda. **Leia e siga** este arquivo:

`C:\Users\m.milani\OneDrive - Pharmaesthetics do Brasil\Documents\Marcelo\Relatórios Comercial\.agents\skills\relatorio-semanal\SKILL.md`

Na `dev` desde 24/09/2026 (PR #26, otimização; PR #25, SAP voltando a atualizar). Rode **da
pasta `Relatórios Comercial`, pelo PowerShell** (o Python chamado pelo Bash não enxerga o `O:\`).

Resumo, para não errar a ordem:
1. **QA** (dados + relatórios + e-mail de teste; ~10 min):
   `python rodar_semanal.py --modo sandbox --elite --sem-ia` (Elite/IA conforme o pedido).
2. **Espere o usuário validar** os e-mails de teste. Nunca pule.
3. **PROD** com os mesmos arquivos: `python rodar_semanal.py --modo prod --so-envio --sem-ia`.
4. Falhas de envio: avise e ofereça `python rodar_semanal.py --modo prod --reenviar-falhas`.
- Não edite `config.py` nem `envio_emails.py` para ligar Elite/IA/modo — é tudo por opção.
- Relate por etapa: bases (falhas), relatórios (PPTX/PDF), e-mails (enviados/falhas/cancelados),
  tempo total, modo e se foi com Elite/IA. Detalhe em `output/rodadas/ultima.json`.

Contexto e medições no vault: [[relatorio-otimizacao-pipeline]], [[relatorio-envio-email]],
[[relatorio-comercial]].
