<#
    enviar-github.ps1
    Envio "de uma vez" para o GitHub (repo configurado no 'origin').

    Politica PULL-FIRST SEGURA (nao apaga o trabalho de quem subiu na main):
      1. Adiciona TUDO (git add -A), inclusive arquivos novos/nao rastreados.
      2. Faz commit com data/hora (ou mensagem passada por parametro).
      3. PUXA o remoto ANTES de enviar (pull --no-rebase, merge normal). Se
         houver CONFLITO, o script PARA e pede resolucao manual â€” nunca escolhe
         lado nem descarta o que o outro subiu.
      4. Faz push normal. Se o remoto tiver avancado no meio do caminho, orienta
         rodar de novo (puxa e reenvia). NUNCA usa --force.

    Uso:
      - Duplo clique em "enviar-github.bat" (recomendado), OU
      - powershell -ExecutionPolicy Bypass -File .scripts\enviar-github.ps1
      - Mensagem custom: ... enviar-github.ps1 -Mensagem "minha nota"
#>
param(
    [string]$Mensagem = ""
)

$ErrorActionPreference = "Continue"

# Raiz do vault = pasta pai deste script
$VaultPath = Split-Path -Parent $PSScriptRoot
Set-Location $VaultPath

function Write-Step($msg) { Write-Host ">> $msg" -ForegroundColor Cyan }
function Write-Ok($msg)   { Write-Host "   OK: $msg" -ForegroundColor Green }
function Write-Warn($msg) { Write-Host "   ATENCAO: $msg" -ForegroundColor Yellow }
function Write-Err($msg)  { Write-Host "   ERRO: $msg" -ForegroundColor Red }

Write-Host "==== Enviar vault para o GitHub ====" -ForegroundColor White
Write-Host "Pasta: $VaultPath" -ForegroundColor DarkGray

# 0) Confere se e um repo git com remote configurado
if (-not (Test-Path (Join-Path $VaultPath ".git"))) {
    Write-Err "Esta pasta nao e um repositorio Git. Rode primeiro o setup-git.ps1."
    Read-Host "Pressione Enter para sair"; exit 1
}
$temOrigin = git remote 2>$null | Select-String -Pattern "^origin$"
if (-not $temOrigin) {
    Write-Err "Remote 'origin' nao configurado. Rode setup-git.ps1 com a URL do repo."
    Read-Host "Pressione Enter para sair"; exit 1
}

# Descobre a branch atual (fallback: main)
$branch = (git rev-parse --abbrev-ref HEAD 2>$null)
if ([string]::IsNullOrWhiteSpace($branch) -or $branch -eq "HEAD") { $branch = "main" }

# 1) Adiciona tudo
Write-Step "Adicionando TODOS os arquivos (novos, alterados e removidos)..."
git add -A
Write-Ok "Arquivos preparados."

# 2) Commit (so se houver algo para commitar)
$temMudanca = git status --porcelain
if (-not [string]::IsNullOrWhiteSpace($temMudanca)) {
    if ([string]::IsNullOrWhiteSpace($Mensagem)) {
        $stamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        $Mensagem = "envio manual: $stamp"
    }
    Write-Step "Commitando: $Mensagem"
    git commit -m $Mensagem | Out-Null
    Write-Ok "Commit criado."
} else {
    Write-Warn "Nada novo para commitar localmente. Vou sincronizar mesmo assim."
}

# 3) Sincroniza com o remoto ANTES do push (pull-first, merge normal)
#    NUNCA sobrescreve o trabalho de quem subiu na main: em conflito, PARA e
#    pede resolucao manual (nao escolhe lado).
Write-Step "Puxando o remoto ANTES de enviar (pull --no-rebase, merge)..."
git fetch origin $branch 2>&1 | Out-Null
git pull --no-rebase origin $branch 2>&1 | ForEach-Object { Write-Host "   $_" -ForegroundColor DarkGray }

if ($LASTEXITCODE -ne 0) {
    Write-Err "O merge com o remoto encontrou CONFLITO. Envio abortado para nao perder trabalho."
    Write-Warn "Resolva os conflitos a mao (arquivos marcados em 'git status'), rode 'git add' neles"
    Write-Warn "e 'git commit', depois rode este script de novo. NADA foi enviado."
    if ($Host.Name -eq "ConsoleHost" -and $MyInvocation.InvocationName -ne ".") {
        Read-Host "Pressione Enter para fechar"
    }
    exit 1
}

# 4) Push (sem forcar â€” remoto ja esta incorporado pelo pull acima)
Write-Step "Enviando para o GitHub (push)..."
$push = git push origin $branch 2>&1
Write-Host $push -ForegroundColor DarkGray
if ($LASTEXITCODE -eq 0) {
    Write-Ok "Tudo enviado ao GitHub com sucesso."
} else {
    Write-Err "Push rejeitado. O remoto avancou depois do pull (alguem subiu agora)."
    Write-Warn "Rode este script de novo: ele vai puxar o novo estado e reenviar. NUNCA use --force aqui."
}

Write-Host "==== Fim ====" -ForegroundColor White
# Pausa so quando aberto por duplo clique (janela fecharia sozinha)
if ($Host.Name -eq "ConsoleHost" -and $MyInvocation.InvocationName -ne ".") {
    Read-Host "Pressione Enter para fechar"
}

