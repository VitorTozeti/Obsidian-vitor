---
name: planejamento-mural-postits
description: planejamento de arquitetura, funcionalidades, modelo de dados e criptografia do mural de post-its
tags: [projeto, proj/mural, planejamento, roadmap, crypto]
updated: 2026-09-28
---

# 📌 Mural de Post-its para Conversas: Planejamento

Um mural de post-its só pra duas pessoas, com assuntos que queremos conversar, post-its customizáveis e post-its "guardados" que só aparecem quando quem criou decide revelar.

---

## 1. Visão geral

**Ideia:** um site em formato de mural onde cada um adiciona post-its com assuntos para conversar. Funciona como um espaço leve e divertido, sem a frieza de uma lista de tarefas.

**Público:** apenas duas pessoas (eu e ela).

**Tom:** brincadeira e carinho. Apresentar como um jogo ("deixei um post-it guardado pra você"), não como uma lista de cobranças.

**Restrição principal:** sem banco de dados tradicional, tudo rodando só com GitHub.

---

## 2. Funcionalidades

### MVP (versão 1)
- [x] Mural com fundo estilo cortiça/quadro
- [x] Criar, editar e apagar post-its
- [x] Arrastar e soltar os post-its pelo mural
- [x] Customização do post-it:
  - [x] Cor (paleta de post-its clássicos)
  - [x] Fonte (algumas opções, incluindo estilo manuscrito)
  - [x] Tamanho
  - [x] Rotação leve (pra dar aparência de colado à mão)
  - [x] Emoji/ícone opcional
- [x] Identificação do autor (cada post-it mostra quem criou, por cor ou etiqueta)
- [x] Sincronização entre os dois via GitHub

### Versão 2
- [x] **Post-its guardados** (criptografados, revelados quando quem criou decidir)
- [x] Status do post-it: "quero falar", "já conversamos", "resolvido", "preciso de mais tempo"
- [x] Nível de delicadeza: leve, médio, conversa séria
- [x] Histórico de assuntos resolvidos

### Ideias futuras
- [x] Reações rápidas (❤️, 👀, 😅) em cada post-it
- [ ] Comentário/resposta curta em cada post-it
- [ ] Notificação de novo post-it (pode ser só um indicador visual ao abrir o site)
- [x] Temas do mural (cortiça, madeira, escuro)
- [ ] "Post-it surpresa" que se revela numa data específica

---

## 3. Arquitetura

```
┌─────────────────────┐        ┌──────────────────────────┐
│  GitHub Pages       │        │  Repositório GitHub      │
│  (site estático)    │◄──────►│  data.json (o "banco")   │
│  HTML + CSS + JS    │  API   │                          │
└─────────────────────┘        └──────────────────────────┘
        ▲                                  ▲
        │                                  │
   Eu (navegador)                   Ela (navegador)
```

- **Front-end:** HTML, CSS e JavaScript puro (sem framework, para manter simples).
- **Hospedagem:** GitHub Pages.
- **"Banco de dados":** um arquivo `data.json` no repositório.
- **Leitura/escrita:** API REST do GitHub (`/repos/{owner}/{repo}/contents/data.json`).
- **Sincronização:** *polling* a cada 10 a 15 segundos, e ao focar novamente na aba.

### Estrutura de arquivos

```
/
├── index.html
├── css/
│   └── style.css
├── js/
│   ├── app.js          # inicialização e fluxo principal
│   ├── board.js        # mural, arrastar e soltar
│   ├── postit.js       # criação e customização dos post-its
│   ├── github.js       # leitura/escrita via API do GitHub
│   └── crypto.js       # criptografia dos post-its guardados
└── data.json           # dados do mural (ver formato abaixo)
```

---

## 4. Modelo de dados

```json
{
  "version": 1,
  "updatedAt": "2026-09-28T12:00:00Z",
  "postits": [
    {
      "id": "p_8f3k2a",
      "author": "eu",
      "text": "Quero falar sobre o fim de semana",
      "color": "#FFF176",
      "font": "Caveat",
      "size": "medium",
      "rotation": -2,
      "emoji": "💬",
      "x": 120,
      "y": 80,
      "status": "quero_falar",
      "sensitivity": "leve",
      "locked": false,
      "reactions": { "❤️": ["ela"], "👀": ["eu", "ela"] },
      "createdAt": "2026-09-28T12:00:00Z"
    },
    {
      "id": "p_1x9z7q",
      "author": "eu",
      "locked": true,
      "encrypted": {
        "salt": "base64...",
        "iv": "base64...",
        "ciphertext": "base64..."
      },
      "color": "#F48FB1",
      "x": 300,
      "y": 200,
      "hint": "Abre no sábado 👀",
      "createdAt": "2026-09-28T12:05:00Z"
    }
  ]
}
```

Para post-its guardados (`locked: true`), o campo `text` **não existe**. O conteúdo fica só dentro de `encrypted`. Cor, posição e autor continuam visíveis, então ela vê que existe um post-it misterioso, mas não consegue ler.

**Campos adicionados na implementação** (além do previsto originalmente neste planejamento):
- `reactions`: mapa `{ emoji: [autores_que_reagiram] }`, usado pelas reações rápidas ❤️/👀/😅.
- `hint`: dica pública opcional de um post-it guardado (mostrada no modal de revelar antes de pedir a senha).
- `resolvedAt`: timestamp de quando o post-it foi marcado como `resolvido`, usado na gaveta de Histórico.

---

## 5. Sincronização via GitHub

### Fluxo de escrita
1. Ler `data.json` (guardar o `sha` do arquivo).
2. Aplicar a alteração localmente.
3. Enviar `PUT` na API com o novo conteúdo em base64 e o `sha` anterior.
4. Se a API retornar **409 (conflito)**: reler o arquivo, reaplicar a alteração e tentar de novo.

### Fluxo de leitura
- `GET` no `data.json` a cada 10 a 15 segundos.
- Comparar o `sha` com o último conhecido: só re-renderizar se mudou.

### Cuidados
- **Limite da API:** 5.000 requisições/hora com token autenticado. Polling de 15s usa ~240/hora, então sobra bastante.
- **Salvar com debounce:** ao arrastar um post-it, só salvar a posição quando soltar (não a cada pixel).
- **Muitos commits:** cada edição vira um commit. Não é problema pro uso de vocês, mas o histórico vai ficar cheio.

---

## 6. Autenticação (token do GitHub)

O site é estático, então não há servidor pra esconder segredos. A solução:

1. Criar um **Fine-grained Personal Access Token** em *GitHub → Settings → Developer settings*.
2. Permissões: acesso **apenas ao repositório do mural**, com **Contents: Read and write**.
3. Na primeira vez, cada pessoa cola o token numa tela de configuração do site.
4. O token fica salvo no `localStorage` do navegador (nunca no código).

> ⚠️ **Nunca** colocar o token dentro dos arquivos do repositório. O GitHub costuma detectar e revogar automaticamente, e qualquer pessoa poderia usá-lo.

**Como ela entra:** o mais simples é criar um token pra ela (ou usar a conta dela como colaboradora no repo) e mandar por uma mensagem privada junto com o link do site. Dá pra fazer um link de configuração, mas o mais seguro é ela colar o token uma vez só.

---

## 7. Post-its guardados (criptografia)

Como o `data.json` é só um arquivo, esconder na interface **não basta**: qualquer um poderia abrir o JSON e ler. O texto precisa ser criptografado no navegador.

### Como funciona
- **Algoritmo:** AES-GCM via Web Crypto API (nativa do navegador, sem bibliotecas).
- **Derivação de chave:** PBKDF2 a partir de uma **senha de quem criou** (com `salt` aleatório).
- **Criar guardado:** o texto é criptografado com a senha e só o `ciphertext` vai pro JSON.
- **Revelar:** quem criou digita a senha, o site descriptografa, grava o texto em claro no JSON e marca `locked: false`.

### Decisões pra tomar
- **Uma senha por post-it ou uma senha geral?** Uma senha geral (pedida uma vez por sessão) é mais prática. Uma por post-it dá mais controle, mas é chato.
- **Esqueci a senha:** não há recuperação. O conteúdo fica perdido. Vale avisar isso na interface.
- **Detalhe de UX:** um post-it guardado pode aparecer com um cadeado e uma dica opcional ("abre no sábado 👀"), que fica em claro.

---

## 8. Privacidade e repositório

O combinado é que isso fica só entre vocês dois, então o risco é baixo, mas vale conhecer as opções:

| Opção | Prós | Contras |
|---|---|---|
| **Repo público** | Simples; GitHub Pages gratuito | Qualquer pessoa que achar o link/repo pode ler o `data.json` |
| **Repo privado** | Dados não ficam expostos | GitHub Pages em repo privado exige plano pago; alternativa é separar em dois repos (site público, dados privados) |

**Sugestão prática:** dois repositórios.
- `mural-site` (público): só HTML/CSS/JS, hospedado no Pages.
- `mural-dados` (privado): só o `data.json`.
- O token (com acesso ao repo privado) lê e escreve os dados.

Se preferir manter tudo num repo só e público, funciona, mas: evite escrever coisas muito pessoais em post-its comuns e use os guardados (criptografados) pro que for mais delicado.

---

## 9. Design e experiência

- **Fundo:** textura de cortiça ou quadro, com opção de tema escuro.
- **Post-its:** leve sombra, cantos com curvatura sutil, rotação aleatória pequena (-4° a 4°).
- **Fontes sugeridas** (Google Fonts): Caveat, Patrick Hand, Shadows Into Light, Indie Flower, Kalam.
- **Paleta:** amarelo, rosa, azul, verde, laranja, lilás, mais um seletor de cor livre.
- **Interações:**
  - Arrastar pra mover
  - Duplo clique pra editar
  - Painel flutuante de customização ao selecionar
  - Lixeira ou botão de apagar com confirmação
- **Mobile:** suporte a toque (arrastar com o dedo) e layout responsivo. Provavelmente vão usar mais pelo celular.
- **Identificação:** cada pessoa com uma cor de "etiqueta" (ex.: bolinha no canto do post-it).

---

## 10. Roadmap

### Fase 1: Mural local (1 a 2 dias) — ✅ concluída
- Estrutura HTML/CSS e o mural
- Criar, editar, apagar e arrastar post-its
- Customização de cor, fonte, tamanho
- Salvar no `localStorage` (só pra testar a sensação)

### Fase 2: Sincronização (1 a 2 dias) — ✅ concluída
- Tela de configuração do token
- Leitura e escrita do `data.json` via API
- Polling e tratamento de conflito
- Deploy no GitHub Pages — site no ar em [vitortozeti.github.io/Mural](https://vitortozeti.github.io/Mural/)

### Fase 3: Post-its guardados (1 dia) — ✅ concluída
- Criptografia e descriptografia
- Interface de cadeado, revelar e dica
- Testes com senha errada e conteúdo perdido *(pendente teste manual com os dois usuários reais)*

### Fase 4: Extras (quando bater vontade) — ✅ maior parte concluída
- Status, nível de delicadeza, histórico — feito
- Reações, temas — feito
- Comentário/resposta curta e "post-it surpresa" com data — ainda não implementados

---

## 11. Riscos e como lidar

| Risco | Como lidar |
|---|---|
| Token vazado | Fine-grained, só um repo, expiração definida; revogar e gerar outro se preciso |
| Conflito de escrita simultânea | Reler + reaplicar + tentar de novo (retry automático) |
| Esquecer a senha de um guardado | Avisar na hora de criar; sem recuperação |
| Dados públicos por engano | Usar repo de dados privado ou só guardados pro que for sensível |
| Ela achar pesado/estranho | Apresentar como brincadeira, começar com post-its leves e divertidos |
| Cair a API/limite do GitHub | Mostrar aviso e manter alterações locais até reconectar |

---

## 12. Próximos passos

1. ~~Decidir: um repo ou dois (site + dados).~~ Feito: repo único público `VitorTozeti/Mural` (site + `data.json` juntos).
2. Combinar com ela a brincadeira e o tom.
3. ~~Criar o repositório e ativar o GitHub Pages.~~ Feito.
4. Gerar os dois tokens (o seu e o dela) e configurar cada um na tela de engrenagem ⚙️ do site.
5. ~~Construir o protótipo da Fase 1 e testar a sensação do mural.~~ Feito — MVP, V2 e a maior parte dos extras já implementados.
6. Testar sincronização em tempo real com os dois tokens configurados, em celular e desktop.

---

## 13. Checklist técnico rápido

- [x] Repositório criado no GitHub (`VitorTozeti/Mural`, público)
- [x] GitHub Pages ativado — [vitortozeti.github.io/Mural](https://vitortozeti.github.io/Mural/)
- [x] `data.json` inicial no repositório
- [ ] Token fine-grained gerado (Contents: read/write, só nesse repo) para os dois usuários
- [x] Token do site nunca commitado (fica só no `localStorage`)
- [ ] Testado em celular e desktop
- [ ] Testado com os dois usando ao mesmo tempo
