<#
    instalar-tarefa-sexta.ps1
    Registra no Agendador de Tarefas do Windows uma tarefa que roda o
    pull-agendado.ps1 TODA SEXTA as 12:00.

    Cada colega roda ESTE script UMA vez na maquina dele:
        powershell -ExecutionPolicy Bypass -File .scripts\instalar-tarefa-sexta.ps1

    Para remover depois:
        powershell -ExecutionPolicy Bypass -File .scripts\instalar-tarefa-sexta.ps1 -Remover

    Observacoes:
      - A tarefa roda no usuario logado. Se o PC estiver desligado as 12:00, o
        Windows executa assim que possivel (StartWhenAvailable).
      - Para o e-mail de falha funcionar, tenha o .scripts/notify-config.local.ps1
        preenchido (copie de notify-config.exemplo.ps1).
#>
param(
    [switch]$Remover,
    [string]$Hora = "12:00"
)

$TaskName  = "Vault-Pull-Sexta"
$ScriptDir = $PSScriptRoot
$Runner    = Join-Path $ScriptDir "pull-agendado.ps1"

if ($Remover) {
    if (Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue) {
        Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false
        Write-Host "Tarefa '$TaskName' removida." -ForegroundColor Green
    } else {
        Write-Host "Tarefa '$TaskName' nao existe." -ForegroundColor Yellow
    }
    return
}

if (-not (Test-Path $Runner)) {
    Write-Host "ERRO: nao encontrei $Runner" -ForegroundColor Red
    exit 1
}

$action = New-ScheduledTaskAction `
    -Execute "powershell.exe" `
    -Argument "-NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$Runner`""

# Toda semana, na sexta, no horario informado
$trigger = New-ScheduledTaskTrigger -Weekly -DaysOfWeek Friday -At $Hora

$settings = New-ScheduledTaskSettingsSet `
    -StartWhenAvailable `
    -DontStopOnIdleEnd `
    -AllowStartIfOnBatteries `
    -DontStopIfGoingOnBatteries

# Roda como o usuario logado (para ter as credenciais do Git dele)
$principal = New-ScheduledTaskPrincipal -UserId "$env:USERDOMAIN\$env:USERNAME" -LogonType Interactive -RunLevel Limited

# Substitui se ja existir
if (Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue) {
    Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false
}

Register-ScheduledTask `
    -TaskName $TaskName `
    -Action $action `
    -Trigger $trigger `
    -Settings $settings `
    -Principal $principal `
    -Description "Puxa o vault do GitHub toda sexta as $Hora (pull seguro). Avisa por e-mail se falhar." | Out-Null

Write-Host "Tarefa '$TaskName' criada: toda SEXTA as $Hora." -ForegroundColor Green
Write-Host "Runner: $Runner" -ForegroundColor DarkGray
Write-Host ""
Write-Host "Teste agora sem esperar sexta:" -ForegroundColor Cyan
Write-Host "   Start-ScheduledTask -TaskName '$TaskName'" -ForegroundColor White
Write-Host "Lembre de preencher .scripts\notify-config.local.ps1 para o e-mail funcionar." -ForegroundColor Yellow
