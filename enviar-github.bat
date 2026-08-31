@echo off
REM ============================================================
REM  Enviar vault para o GitHub - duplo clique aqui.
REM  Adiciona tudo, faz commit e empurra pro GitHub, resolvendo
REM  erros de compatibilidade automaticamente (versao local vence).
REM ============================================================
powershell -ExecutionPolicy Bypass -NoProfile -File "%~dp0.scripts\enviar-github.ps1" %*
