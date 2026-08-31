@echo off
REM Puxa o vault do GitHub sem perder o trabalho local (pull seguro).
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0.scripts\receber-github.ps1"
