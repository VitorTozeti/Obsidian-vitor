@echo off
REM ============================================================
REM  ENVIO FORCADO para o GitHub - duplo clique aqui.
REM  A versao LOCAL sobrescreve o remoto, aconteca o que acontecer.
REM  ATENCAO: destrutivo no remoto (commits que estao SO no GitHub
REM  podem ser perdidos). Use quando a maquina local e a fonte da verdade.
REM ============================================================
powershell -ExecutionPolicy Bypass -NoProfile -File "%~dp0.scripts\forcar-github.ps1" %*
