# =============================================================================
#  usar_ollama.ps1 - roda a K.E.M.Y usando um Ollama LOCAL (gratis/offline).
#  Uso:  clique com o botao direito > "Executar com o PowerShell"
#        ou no terminal:  ./usar_ollama.ps1
#  Nao gasta credito, nao precisa de internet, sem chave de API.
# =============================================================================

# --- Configuracao (mude o modelo aqui se quiser) ---
$env:KEMY_API_URL        = "http://localhost:11434/v1/chat/completions"
$env:KEMY_MODEL          = "qwen2.5:7b"
$env:KEMY_MODEL_FALLBACKS = "qwen2.5:7b"
$env:KEMY_API_KEY        = "ollama"

Write-Host "============================================================" -ForegroundColor Cyan
Write-Host " K.E.M.Y - modo OLLAMA LOCAL (gratis/offline)" -ForegroundColor Cyan
Write-Host " Modelo:   $($env:KEMY_MODEL)"
Write-Host " Endpoint: $($env:KEMY_API_URL)"
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

# --- Checa se o Ollama esta instalado ---
if (-not (Get-Command ollama -ErrorAction SilentlyContinue)) {
    Write-Host "[!] Ollama nao encontrado. Instale em https://ollama.com/download" -ForegroundColor Yellow
    Write-Host "    e depois rode:  ollama pull $($env:KEMY_MODEL)"
    Read-Host "Enter para sair"
    exit 1
}

# --- Garante que o modelo existe (baixa se faltar) ---
if (-not (ollama list | Select-String -SimpleMatch $env:KEMY_MODEL)) {
    Write-Host "[i] Baixando o modelo $($env:KEMY_MODEL) pela primeira vez (pode demorar)..." -ForegroundColor Yellow
    ollama pull $env:KEMY_MODEL
}

# --- Roda a K.E.M.Y ---
Set-Location $PSScriptRoot
python kemy.py
