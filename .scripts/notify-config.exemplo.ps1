<#
    notify-config.exemplo.ps1  â€”  MODELO (nao contem segredo real)

    COPIE este arquivo para  notify-config.local.ps1  (na mesma pasta) e
    preencha os valores. O arquivo .local NAO vai para o GitHub (esta no
    .gitignore) â€” a senha de app do Gmail fica so na maquina.

    Como gerar a "senha de app" do Gmail:
      1. A conta remetente precisa ter a verificacao em 2 etapas ativada.
      2. https://myaccount.google.com/apppasswords  -> gere uma senha de 16 letras.
      3. Cole essa senha (sem espacos) em $GmailAppPassword abaixo.
#>

# Conta Gmail que ENVIA o aviso (precisa da senha de app)
$GmailUser        = "conta-remetente@gmail.com"

# Senha de APP de 16 caracteres (NAO e a senha normal do Gmail)
$GmailAppPassword = "xxxxxxxxxxxxxxxx"

# Para quem vai o aviso de falha
$NotifyTo         = "seu-email@exemplo.com"

