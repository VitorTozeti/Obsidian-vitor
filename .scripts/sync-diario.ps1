<#
    sync-diario.ps1
    Sincronizacao "1x por dia" disparada pelo hook SessionStart do Claude Code:
    na PRIMEIRA vez que o Claude abre o vault no dia, sobe/baixa tudo.

    Guarda de 1x/dia: usa o marcador .scripts/.last-sync-date. Se ja rodou hoje,
    sai na hora (nao repete a cada sessao). O marcador so avanca no fim, entao o
    dia inteiro conta como "feito" apos a primeira execucao.

    O que faz (pull-first seguro, nao perde nada):
      1. git add -A + commit do que houver local (protege o trabalho local).
      2. git pull --no-rebase (merge do remoto). Conflito => aborta e avisa.
      3. git push (sobe tudo). Sem --force.
    Se qualquer passo falhar, envia e-mail via Gmail (config em
    .scripts/notify-config.local.ps1). Sem essa config, so registra no log.

    Rodar na mao (forcar mesmo se ja rodou hoje):
      powershell -ExecutionPolicy Bypass -File .scripts\sync-diario.ps1 -Force
#>
param([switch]$Force)

$ErrorActionPreference = "Continue"

$ScriptDir = $PSScriptRoot
$VaultPath = Split-Path -Parent $ScriptDir
Set-Location $VaultPath

$LogFile = Join-Path $ScriptDir "sync-diario.log"
$Marker  = Join-Path $ScriptDir ".last-sync-date"
$Today   = Get-Date -Format "yyyy-MM-dd"

function Log($m) {
    $line = "[{0}] {1}" -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss"), $m
    Add-Content -Path $LogFile -Value $line -Encoding utf8
}

# Guarda de 1x por dia
if (-not $Force -and (Test-Path $Marker)) {
    $last = (Get-Content $Marker -Raw -ErrorAction SilentlyContinue).Trim()
    if ($last -eq $Today) { exit 0 }   # ja sincronizou hoje
}

# Precisa ser repo git com origin
if (-not (Test-Path (Join-Path $VaultPath ".git"))) { Log "Nao e repo git; abortado."; exit 0 }
$temOrigin = git remote 2>$null | Select-String -Pattern "^origin$"
if (-not $temOrigin) { Log "Sem remote origin; abortado."; exit 0 }

$branch = (git rev-parse --abbrev-ref HEAD 2>$null)
if ([string]::IsNullOrWhiteSpace($branch) -or $branch -eq "HEAD") { $branch = "main" }

Log "=== Sync diario ($Today) inicio ==="
$falha = $null

# 1) Protege o local
$pendente = git status --porcelain
if (-not [string]::IsNullOrWhiteSpace($pendente)) {
    git add -A
    git commit -m "sync-diario (protege local): $Today" 2>&1 | Out-Null
    Log "Commit local feito."
}

# 2) Pull (merge)
$pullOut = git pull --no-rebase origin $branch 2>&1
Log ("pull: " + ($pullOut -join " | "))
if ($LASTEXITCODE -ne 0) { $falha = "Conflito/erro no pull. Resolva a mao (git status)." }

# 3) Push (so se o pull deu certo)
if (-not $falha) {
    $pushOut = git push origin $branch 2>&1
    Log ("push: " + ($pushOut -join " | "))
    if ($LASTEXITCODE -ne 0) { $falha = "Push rejeitado (remoto avancou ou sem credencial)." }
}

# Marca o dia como feito (evita repetir/spam de e-mail nas proximas sessoes de hoje)
Set-Content -Path $Marker -Value $Today -Encoding utf8

if (-not $falha) {
    Log "=== Sync diario OK ==="
    exit 0
}

# Falhou -> e-mail
Log "FALHA: $falha"
$cfg = Join-Path $ScriptDir "notify-config.local.ps1"
if (Test-Path $cfg) {
    try {
        . $cfg
        $corpo = @"
O sync diario do vault (Obsidian) FALHOU.

Maquina : $env:COMPUTERNAME
Usuario : $env:USERNAME
Pasta   : $VaultPath
Quando  : $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
Motivo  : $falha

Log: $LogFile
"@
        $sec  = ConvertTo-SecureString $GmailAppPassword -AsPlainText -Force
        $cred = New-Object System.Management.Automation.PSCredential($GmailUser, $sec)
        Send-MailMessage -From $GmailUser -To $NotifyTo `
            -Subject "[Vault] Sync diario FALHOU em $env:COMPUTERNAME" `
            -Body $corpo -SmtpServer "smtp.gmail.com" -Port 587 -UseSsl `
            -Credential $cred -Encoding UTF8
        Log "E-mail de falha enviado para $NotifyTo."
    } catch {
        Log "ERRO ao enviar e-mail: $_"
    }
} else {
    Log "Sem notify-config.local.ps1: falha nao notificada por e-mail."
}
exit 1
