@echo off
REM ==========================================================================
REM  usar_ollama.bat - roda a K.E.M.Y usando um Ollama LOCAL (gratis/offline).
REM  Basta dar DUPLO-CLIQUE neste arquivo (com o Ollama instalado e um modelo
REM  ja baixado). Nao gasta credito, nao precisa de internet, sem chave de API.
REM ==========================================================================

REM --- Configuracao (mude o modelo aqui se quiser) --------------------------
set "KEMY_API_URL=http://localhost:11434/v1/chat/completions"
set "KEMY_MODEL=qwen2.5:7b"
set "KEMY_MODEL_FALLBACKS=qwen2.5:7b"
set "KEMY_API_KEY=ollama"

echo ============================================================
echo  K.E.M.Y - modo OLLAMA LOCAL (gratis/offline)
echo  Modelo: %KEMY_MODEL%
echo  Endpoint: %KEMY_API_URL%
echo ============================================================
echo.

REM --- Checa se o Ollama esta rodando ---------------------------------------
where ollama >nul 2>nul
if errorlevel 1 (
  echo [!] Ollama nao encontrado. Instale em https://ollama.com/download
  echo     e depois rode:  ollama pull %KEMY_MODEL%
  echo.
  pause
  exit /b 1
)

REM --- Garante que o modelo existe (baixa se faltar) ------------------------
ollama list | findstr /i "qwen2.5:7b" >nul 2>nul
if errorlevel 1 (
  echo [i] Baixando o modelo %KEMY_MODEL% pela primeira vez (pode demorar)...
  ollama pull %KEMY_MODEL%
)

REM --- Roda a K.E.M.Y -------------------------------------------------------
cd /d "%~dp0"
python kemy.py
pause
