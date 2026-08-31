<#
    pull-agendado.ps1
    Acao executada pela TAREFA AGENDADA de sexta (12:00).

    O que faz:
      1. Roda o receber-github.ps1 (pull seguro, preserva trabalho local).
      2. Grava o resultado em .scripts/pull-agendado.log (com data/hora).
      3. Se o pull FALHAR (conflito, sem rede, sem credencial, etc.), envia um
         e-mail de aviso via Gmail para o destinatario configurado.

    A config (remetente + senha de app do Gmail) vem de:
        .scripts/notify-config.local.ps1   (fora do Git)
    Se esse arquivo nao existir, a falha ainda e registrada no log, mas o
    e-mail nao e enviado (e o log avisa isso).

    Uso manual (teste):
      powershell -ExecutionPolicy Bypass -File .scripts\pull-agendado.ps1
#>

$ErrorActionPreference = "Continue"

$ScriptDir = $PSScriptRoot
$VaultPath = Split-Path -Parent $ScriptDir
Set-Location $VaultPath

$LogFile = Join-Path $ScriptDir "pull-agendado.log"
function Log($m) {
    $line = "[{0}] {1}" -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss"), $m
    Add-Content -Path $LogFile -Value $line -Encoding utf8
    Write-Host $line
}

Log "=== Inicio do pull agendado ==="

# 1) Roda o pull seguro e captura sucesso/falha pelo codigo de saida
$receber = Join-Path $ScriptDir "receber-github.ps1"
$saida = & powershell -NoProfile -ExecutionPolicy Bypass -File $receber 2>&1
$ok = ($LASTEXITCODE -eq 0)
$saida | ForEach-Object { Log ("  " + $_) }

if ($ok) {
    Log "Pull concluido com sucesso."
    Log "=== Fim (OK) ==="
    exit 0
}

# 2) Falhou -> tenta avisar por e-mail
Log "PULL FALHOU (codigo $LASTEXITCODE). Tentando enviar e-mail de aviso..."

$cfg = Join-Path $ScriptDir "notify-config.local.ps1"
if (-not (Test-Path $cfg)) {
    Log "SEM notify-config.local.ps1 -> nao da para enviar e-mail. Copie notify-config.exemplo.ps1 e preencha."
    Log "=== Fim (FALHA, sem e-mail) ==="
    exit 1
}

try {
    . $cfg  # carrega $GmailUser, $GmailAppPassword, $NotifyTo

    $computador = $env:COMPUTERNAME
    $usuario    = $env:USERNAME
    $corpo = @"
O pull automatico do vault (Obsidian) FALHOU.

Maquina : $computador
Usuario : $usuario
Pasta   : $VaultPath
Quando  : $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

Provavel causa: conflito de merge, sem internet, ou credencial do GitHub.
Veja o detalhe no log: $LogFile

--- ultimas linhas do pull ---
$($saida -join "`n")
"@

    $sec = ConvertTo-SecureString $GmailAppPassword -AsPlainText -Force
    $cred = New-Object System.Management.Automation.PSCredential($GmailUser, $sec)

    Send-MailMessage `
        -From $GmailUser `
        -To $NotifyTo `
        -Subject "[Vault] Pull de sexta FALHOU em $computador" `
        -Body $corpo `
        -SmtpServer "smtp.gmail.com" `
        -Port 587 `
        -UseSsl `
        -Credential $cred `
        -Encoding UTF8

    Log "E-mail de aviso enviado para $NotifyTo."
}
catch {
    Log "ERRO ao enviar e-mail: $_"
}

Log "=== Fim (FALHA) ==="
exit 1
