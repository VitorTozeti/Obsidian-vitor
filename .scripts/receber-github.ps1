<#
    receber-github.ps1
    PUXA o vault do GitHub (repo configurado no 'origin') SEM perder o que
    o colega ja tem localmente.

    Politica SEGURA (nao descarta trabalho local):
      1. Se houver alteracoes locais nao commitadas, COMMITA elas primeiro
         (git add -A + commit). Assim nada do colega e perdido no merge.
      2. Faz 'git pull --no-rebase' (merge normal) para trazer as mudancas do
         GitHub. Em CONFLITO, PARA e pede resolucao manual â€” nunca escolhe lado.

    Codigo de saida:
      0 = sucesso (atualizado)   |   1 = falha/conflito (usado pela tarefa agendada)

    Uso:
      - Duplo clique em "receber-github.bat" (se existir), OU
      - powershell -ExecutionPolicy Bypass -File .scripts\receber-github.ps1
#>

$ErrorActionPreference = "Continue"

# Raiz do vault = pasta pai deste script
$VaultPath = Split-Path -Parent $PSScriptRoot
Set-Location $VaultPath

function Write-Step($m) { Write-Host ">> $m"        -ForegroundColor Cyan }
function Write-Ok($m)   { Write-Host "   OK: $m"    -ForegroundColor Green }
function Write-Warn($m) { Write-Host "   ATENCAO: $m" -ForegroundColor Yellow }
function Write-Err($m)  { Write-Host "   ERRO: $m"  -ForegroundColor Red }

Write-Host "==== Receber vault do GitHub (pull seguro) ====" -ForegroundColor White
Write-Host "Pasta: $VaultPath" -ForegroundColor DarkGray

# 0) Confere repo git + remote
if (-not (Test-Path (Join-Path $VaultPath ".git"))) {
    Write-Err "Esta pasta nao e um repositorio Git. Rode primeiro o setup-git.ps1."
    if ($Host.Name -eq "ConsoleHost" -and $MyInvocation.InvocationName -ne ".") { Read-Host "Pressione Enter para sair" }
    exit 1
}
$temOrigin = git remote 2>$null | Select-String -Pattern "^origin$"
if (-not $temOrigin) {
    Write-Err "Remote 'origin' nao configurado. Rode setup-git.ps1 com a URL do repo."
    if ($Host.Name -eq "ConsoleHost" -and $MyInvocation.InvocationName -ne ".") { Read-Host "Pressione Enter para sair" }
    exit 1
}

# Branch atual (fallback: main)
$branch = (git rev-parse --abbrev-ref HEAD 2>$null)
if ([string]::IsNullOrWhiteSpace($branch) -or $branch -eq "HEAD") { $branch = "main" }

# 1) Protege o trabalho local: commita o que estiver pendente ANTES do pull
$pendente = git status --porcelain
if (-not [string]::IsNullOrWhiteSpace($pendente)) {
    Write-Step "Voce tem alteracoes locais. Commitando primeiro para nao perder nada..."
    git add -A
    $stamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    git commit -m "pre-pull (protege trabalho local): $stamp" | Out-Null
    Write-Ok "Trabalho local salvo em commit."
} else {
    Write-Ok "Nada pendente localmente."
}

# 2) Puxa o remoto (merge normal). Em conflito, para.
Write-Step "Puxando do GitHub (pull --no-rebase)..."
git fetch origin $branch 2>&1 | Out-Null
git pull --no-rebase origin $branch 2>&1 | ForEach-Object { Write-Host "   $_" -ForegroundColor DarkGray }

if ($LASTEXITCODE -ne 0) {
    Write-Err "CONFLITO ao mesclar com o GitHub. Pull abortado para nao perder trabalho."
    Write-Warn "Resolva a mao: 'git status' mostra os arquivos; edite, 'git add' neles e 'git commit'."
    if ($Host.Name -eq "ConsoleHost" -and $MyInvocation.InvocationName -ne ".") { Read-Host "Pressione Enter para fechar" }
    exit 1
}

Write-Ok "Vault atualizado com o GitHub. Seu trabalho local foi preservado."
Write-Host "==== Fim ====" -ForegroundColor White
if ($Host.Name -eq "ConsoleHost" -and $MyInvocation.InvocationName -ne ".") { Read-Host "Pressione Enter para fechar" }
exit 0

