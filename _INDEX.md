# Índice do Vault

> Este é o índice mestre. Uma linha por nota — título, caminho e um gancho de 1 frase.
> O Claude lê SÓ este arquivo por padrão e abre uma nota específica apenas quando ela for relevante.
> Sempre que criar/renomear/apagar uma nota, atualize a linha correspondente aqui.
>
> **Carregamento de contexto por projeto:** ao trabalhar num projeto, comece por
> ⭐[[mapa-projetos]] — ele diz o hub a abrir, o repositório real no disco e as referências
> `sempre-considerar` daquele projeto. O **estado corrente** ("onde estamos agora") de cada
> projeto mora na seção `## Estado atual` do respectivo **hub**, não aqui — as linhas deste
> índice são só ganchos de 1 frase.
>
> ℹ️ **Vault-base:** este índice começa só com as notas de infraestrutura (processos de
> sync, manutenção, mapa de projetos vazio e template). Conforme criar clientes, projetos e
> referências, adicione a linha de cada nota na seção certa (ver "Como o Claude deve montar
> o `_INDEX.md`" no `CLAUDE.md`).

## Clientes
<!-- ainda sem notas — crie a primeira em clientes/ e adicione a linha aqui -->

## Processos
- [Manutenção do Vault](processos/manutencao-vault.md) — método editorial + regra de pesquisa proativa (pesquisar nas pastas antes de assumir/perguntar)
- [Enviar vault para o GitHub](processos/enviar-vault-github.md) — envio pull-first seguro (enviar-github.bat); conflito para e pede resolução
- [Receber vault do GitHub](processos/receber-vault-github.md) — pull seguro (commita local antes, não perde nada) + tarefa de sexta 12h e/ou sync 1x/dia ao abrir o Claude (hook SessionStart), ambos com aviso por e-mail se falhar

## Projetos
- [GreenFinance](projetos/greenfinance/greenfinance.md) — app PWA de controle financeiro pessoal, carteira de investimentos e conciliação bancária (Pluggy/extratos)
  - [GreenFinance — Onde os dados vivem](projetos/greenfinance/greenfinance-dados.md) — mapa de localização de dados, repositório, APIs, worker e armazenamento do GreenFinance

## Referências
- ⭐ [Mapa de Projetos](referencias/mapa-projetos.md) — carregamento de contexto: por projeto, o hub, o repo real no disco e as refs sempre-considerar (COMECE AQUI ao entrar num projeto)

## Templates
- [Template de Nota](templates/nota-template.md) — modelo com frontmatter para criar notas novas
