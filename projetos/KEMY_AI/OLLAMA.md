# K.E.M.Y com Ollama LOCAL (grátis / offline)

Guia rápido para rodar a K.E.M.Y usando um modelo **na sua própria máquina**, sem
gastar crédito, sem internet e sem chave de API.

> Ollama = servidor de modelos que roda **no seu PC**. É "grátis" no sentido de não
> ter custo por token nem limite de uso — o custo é o hardware. Modelos pequenos (3B)
> rodam em quase tudo; 7B–8B pedem uma máquina boa (idealmente GPU com ~8 GB de VRAM).

## 1. Instalar o Ollama
Baixe e instale: https://ollama.com/download (tem instalador para Windows).
Depois de instalar, ele sobe sozinho um servidor em `http://localhost:11434`.

## 2. Baixar um modelo (que suporte ferramentas)
No terminal (uma vez só):

```
ollama pull qwen2.5:7b
```

Alternativas:
- `qwen2.5:3b`  → mais leve/rápido, para PCs modestos
- `llama3.1:8b` → mais capaz, porém mais pesado

Todos esses suportam **tool-calling** (as ferramentas da K.E.M.Y funcionam).

## 3. Rodar a K.E.M.Y no modo Ollama
Escolha uma das opções:

- **Duplo-clique** em `usar_ollama.bat`  ← mais fácil
- Ou, no PowerShell: botão direito em `usar_ollama.ps1` → "Executar com o PowerShell"
- Ou manualmente:

```powershell
$env:KEMY_API_URL="http://localhost:11434/v1/chat/completions"
$env:KEMY_MODEL="qwen2.5:7b"
$env:KEMY_MODEL_FALLBACKS="qwen2.5:7b"
$env:KEMY_API_KEY="ollama"
python kemy.py
```

Pronto — a K.E.M.Y passa a "pensar" 100% local.

## Trocar de modelo
Edite a linha `KEMY_MODEL` dentro do `usar_ollama.bat` (ou `.ps1`) para o nome de
qualquer modelo que você já tenha baixado com `ollama pull`.

## Voltar para a nuvem (OpenRouter)
É só rodar `python kemy.py` normalmente (sem as variáveis do Ollama). Nesse caso
você precisa de uma chave da OpenRouter — defina em `KEMY_API_KEY` (recomendado) em
vez de deixar hardcoded. **Nunca** mande a chave por WhatsApp/e-mail: foi assim que a
chave anterior vazou e foi revogada.

## Variáveis úteis
| Variável | Para quê | Exemplo |
|---|---|---|
| `KEMY_API_URL` | endpoint do motor | `http://localhost:11434/v1/chat/completions` |
| `KEMY_MODEL` | modelo em uso | `qwen2.5:7b` |
| `KEMY_MODEL_FALLBACKS` | fila de rodízio | `qwen2.5:7b` |
| `KEMY_API_KEY` | header de auth (o Ollama ignora o valor) | `ollama` |
