<#
    auto-sync.ps1
    Mantem o vault sincronizado com o GitHub por polling:
    a cada intervalo, se houver alteracao, faz commit + push automatico.
    Uso:  clique com o botao direito > "Executar com PowerShell"
          ou:  powershell -ExecutionPolicy Bypass -File .scripts\auto-sync.ps1
    Encerrar: feche a janela ou Ctrl+C.
#>

# Intervalo de verificacao (segundos)
$IntervalSeconds = 8

# Raiz do vault = pasta pai deste script
$VaultPath = Split-Path -Parent $PSScriptRoot
Set-Location $VaultPath

Write-Host "Auto-sync iniciado em: $VaultPath" -ForegroundColor Green
Write-Host "Verificando alteracoes a cada $IntervalSeconds s... (feche a janela para parar)" -ForegroundColor Green

# Verifica se e um repo git
if (-not (Test-Path (Join-Path $VaultPath ".git"))) {
    Write-Host "ERRO: esta pasta ainda nao e um repositorio Git." -ForegroundColor Red
    Write-Host "Rode primeiro o setup-git.ps1." -ForegroundColor Red
    Read-Host "Pressione Enter para sair"
    exit 1
}

function Invoke-Sync {
    $changes = git status --porcelain
    if ([string]::IsNullOrWhiteSpace($changes)) { return }

    $stamp  = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $branch = (git rev-parse --abbrev-ref HEAD 2>$null)
    if ([string]::IsNullOrWhiteSpace($branch) -or $branch -eq "HEAD") { $branch = "main" }

    git add -A | Out-Null
    git commit -m "auto-sync: $stamp" | Out-Null

    # PULL-FIRST: puxa o remoto ANTES do push (evita divergencia com quem subiu na main)
    git pull --no-rebase origin $branch 2>&1 | Out-Null
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[$stamp] CONFLITO no pull. Ciclo abortado, NADA foi enviado." -ForegroundColor Red
        Write-Host "          Resolva a mao (git status/add/commit) — o auto-sync nao escolhe lado." -ForegroundColor Yellow
        return
    }

    $push = git push origin $branch 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[$stamp] alteracoes enviadas ao GitHub." -ForegroundColor Cyan
    } else {
        Write-Host "[$stamp] commit feito, mas o push falhou (remoto avancou?). Sem --force:" -ForegroundColor Yellow
        Write-Host $push -ForegroundColor Yellow
    }
}

# Loop de polling
while ($true) {
    try {
        Invoke-Sync
    }
    catch {
        Write-Host "Erro no ciclo de sync: $_" -ForegroundColor Red
    }
    Start-Sleep -Seconds $IntervalSeconds
}
