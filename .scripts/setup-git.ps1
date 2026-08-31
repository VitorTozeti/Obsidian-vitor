<#
    setup-git.ps1
    Conecta este vault a um repositorio GitHub ja criado (vazio).
    Uso:  powershell -ExecutionPolicy Bypass -File .scripts\setup-git.ps1 "https://github.com/USUARIO/REPO.git"
#>
param(
    [Parameter(Mandatory = $true)]
    [string]$RepoUrl
)

$VaultPath = Split-Path -Parent $PSScriptRoot
Set-Location $VaultPath

if (-not (Test-Path (Join-Path $VaultPath ".git"))) {
    git init | Out-Null
    Write-Host "Repositorio Git iniciado." -ForegroundColor Green
}

# Define branch principal como main
git branch -M main 2>$null

# Configura o remote 'origin'
$hasOrigin = git remote 2>$null | Select-String -Pattern "^origin$"
if ($hasOrigin) {
    git remote set-url origin $RepoUrl
} else {
    git remote add origin $RepoUrl
}
Write-Host "Remote 'origin' -> $RepoUrl" -ForegroundColor Green

# Primeiro commit + push
git add -A | Out-Null
git commit -m "commit inicial: estrutura do vault" | Out-Null
git push -u origin main

Write-Host "Pronto! Vault conectado ao GitHub." -ForegroundColor Green
Write-Host "Agora rode auto-sync.ps1 para manter tudo sincronizado automaticamente." -ForegroundColor Yellow
