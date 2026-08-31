<#
    forcar-github.ps1
    Envio FORCADO para o GitHub - aceita QUALQUER situacao de divergencia.

    Diferente do enviar-github.ps1 (que tenta preservar o remoto), este aqui
    faz a versao LOCAL prevalecer SEMPRE, aconteca o que acontecer:

      1. Se ainda nao ha repo git / remote, ajuda a configurar.
      2. Adiciona TUDO (git add -A), inclusive arquivos novos.
      3. Faz commit de tudo (ou --amend se nada mudou, so pra ter o que enviar).
      4. Push --force-with-lease: sobrescreve o remoto com o estado local, MAS
         so se o remoto NAO avancou desde o ultimo fetch (protege o trabalho do
         colega). Se ate isso falhar, ha um fallback de reescrita do zero.

    ATENCAO: e DESTRUTIVO no remoto e e ULTIMO RECURSO. Antes de usar, sempre
    tente 'git pull --no-rebase' e o enviar-github.ps1 (pull-first seguro).
    Commits que estao SO no GitHub e nunca foram baixados podem ser perdidos.

    Uso:
      - Duplo clique em "forcar-github.bat", OU
      - powershell -ExecutionPolicy Bypass -File .scripts\forcar-github.ps1
      - Com URL (configura o remote na hora):
          ... forcar-github.ps1 -RepoUrl "https://github.com/USER/REPO.git"
#>
param(
    [string]$Mensagem = "",
    [string]$RepoUrl  = "",
    [string]$Branch   = "main"
)

$ErrorActionPreference = "Continue"

$VaultPath = Split-Path -Parent $PSScriptRoot
Set-Location $VaultPath

function Write-Step($m){ Write-Host ">> $m" -ForegroundColor Cyan }
function Write-Ok($m)  { Write-Host "   OK: $m" -ForegroundColor Green }
function Write-Warn($m){ Write-Host "   ATENCAO: $m" -ForegroundColor Yellow }
function Write-Err($m) { Write-Host "   ERRO: $m" -ForegroundColor Red }

Write-Host "==== ENVIO FORCADO para o GitHub (local vence sempre) ====" -ForegroundColor White
Write-Host "Pasta: $VaultPath" -ForegroundColor DarkGray

# 1) Garante repo git
if (-not (Test-Path (Join-Path $VaultPath ".git"))) {
    Write-Step "Iniciando repositorio Git..."
    git init | Out-Null
}

# Garante a branch
git branch -M $Branch 2>$null

# Garante o remote origin
$temOrigin = git remote 2>$null | Select-String -Pattern "^origin$"
if ($RepoUrl -ne "") {
    if ($temOrigin) { git remote set-url origin $RepoUrl } else { git remote add origin $RepoUrl }
    Write-Ok "Remote origin -> $RepoUrl"
    $temOrigin = $true
}
if (-not $temOrigin) {
    Write-Err "Nao ha remote 'origin'. Rode de novo passando -RepoUrl 'https://github.com/USER/REPO.git'"
    Read-Host "Pressione Enter para sair"; exit 1
}

# 2) Adiciona tudo
Write-Step "Adicionando TODOS os arquivos..."
git add -A
Write-Ok "Arquivos preparados."

# 3) Commit (garante que exista pelo menos um commit para enviar)
if ([string]::IsNullOrWhiteSpace($Mensagem)) {
    $Mensagem = "envio forcado: " + (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
}
$temMudanca = git status --porcelain
$temCommit  = git rev-parse --verify HEAD 2>$null
if (-not [string]::IsNullOrWhiteSpace($temMudanca)) {
    Write-Step "Commitando: $Mensagem"
    git commit -m $Mensagem | Out-Null
    Write-Ok "Commit criado."
} elseif ([string]::IsNullOrWhiteSpace($temCommit)) {
    Write-Step "Criando primeiro commit vazio..."
    git commit --allow-empty -m $Mensagem | Out-Null
} else {
    Write-Warn "Nada mudou localmente. Vou forcar o remoto para o estado atual mesmo assim."
}

# 4) Push forcado SEGURO (--force-with-lease)
#    So sobrescreve se o remoto NAO avancou desde o ultimo fetch — assim, se o
#    colega subiu algo que voce ainda nao baixou, o push falha em vez de apagar.
Write-Warn "ULTIMO RECURSO e DESTRUTIVO: isto reescreve o remoto com a sua versao local."
Write-Warn "Se alguem subiu na main e voce nao puxou, PARE e rode antes: git pull --no-rebase"
Write-Step "Enviando com push --force-with-lease (nao apaga se o remoto avancou)..."
$p = git push --force-with-lease -u origin $Branch 2>&1
Write-Host $p -ForegroundColor DarkGray

if ($LASTEXITCODE -eq 0) {
    Write-Ok "Remoto sobrescrito com a versao local. Concluido."
} else {
    Write-Warn "Push --force falhou (historicos totalmente incompativeis?)."
    Write-Warn "Tentando reescrever o remoto do zero a partir do local..."

    # Reescreve: cria uma raiz nova com o conteudo atual e forca por cima.
    $tmpBranch = "envio-forcado-tmp"
    git checkout --orphan $tmpBranch 2>&1 | Out-Null
    git add -A 2>&1 | Out-Null
    git commit -m $Mensagem 2>&1 | Out-Null
    $p2 = git push --force origin "${tmpBranch}:${Branch}" 2>&1
    Write-Host $p2 -ForegroundColor DarkGray
    if ($LASTEXITCODE -eq 0) {
        # Reposiciona a branch local para bater com o que foi enviado
        git branch -M $Branch 2>$null
        Write-Ok "Remoto reescrito com sucesso a partir do local."
    } else {
        Write-Err "Nao foi possivel enviar. Detalhes acima."
        Write-Warn "Verifique: (a) login/credencial do GitHub, (b) se a branch '$Branch' esta protegida no repo, (c) a URL do remote (git remote -v)."
    }
}

Write-Host "==== Fim ====" -ForegroundColor White
if ($Host.Name -eq "ConsoleHost" -and $MyInvocation.InvocationName -ne ".") {
    Read-Host "Pressione Enter para fechar"
}
