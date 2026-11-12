# grok-code-cli

Simulacao simples de um "Claude Code" no terminal, mas usando a API da xAI (Grok)
com function calling. Loop de agente: le a tarefa, decide se precisa usar uma
ferramenta (ler/escrever arquivo, listar diretorio, rodar comando de shell),
executa e responde.

## Como usar no VS Code

1. Extraia o zip e abra a pasta `grok-code-cli` no VS Code.
2. Abra um terminal integrado (`Ctrl+\``) e rode:

   ```bash
   npm install
   ```

3. Copie `.env.example` para `.env` e cole sua chave da xAI:

   ```bash
   cp .env.example .env
   ```

   Edite o `.env` e defina `GROK_API_KEY=sk-...` (chave obtida em https://console.x.ai).

4. Rode o CLI a partir da pasta do projeto que voce quer editar (ou desta mesma pasta
   para testar nela mesma):

   ```bash
   npm start
   ```

5. Digite pedidos como "liste os arquivos desta pasta" ou "crie um arquivo hello.txt
   com um poema curto". O agente vai chamar as ferramentas automaticamente e mostrar
   cada chamada no terminal.

Digite `sair` para encerrar.

## Ferramentas disponiveis para o agente

- `read_file(path)` — le um arquivo de texto.
- `write_file(path, content)` — cria/sobrescreve um arquivo.
- `list_dir(path)` — lista o conteudo de um diretorio.
- `run_command(command)` — roda um comando de shell na pasta do projeto.

Todas as operacoes de arquivo sao restritas a pasta onde o CLI foi iniciado
(`process.cwd()`), como protecao basica contra sair da pasta do projeto.

## Aviso

`run_command` executa comandos reais no seu computador sem confirmacao. Use por
sua conta e risco, revise o que o agente propoe antes de aceitar em cenarios
sensiveis, e nunca rode isso em pastas que voce nao controla.

## Configuracao

- `GROK_API_KEY` — obrigatoria, chave da API xAI.
- `GROK_MODEL` — opcional, padrao `grok-code-fast-1` (ajuste para outro modelo Grok
  disponivel na sua conta, ex. `grok-4`).
