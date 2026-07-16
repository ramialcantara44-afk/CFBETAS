@echo off
:: Se o argumento for "MENU_JOGO", pula direto para o painel
if "%~1"=="MENU_JOGO" goto :MENU_JOGO

setlocal EnableDelayedExpansion
chcp 65001 >nul
title BETA - OTIMIZACAO

:: ==================== VERIFICAR ADMIN ====================
net session >nul 2>&1
if %errorLevel% NEQ 0 (
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit
)

:: ==================== MENU PRINCIPAL ====================
:MENU
cls
echo ==================================================
echo           BETA - OTIMIZACAO (MENU PRINCIPAL)
echo ==================================================
echo [1] OTIMIZAR [2] BACKUP [3] ABRIR JOGO [4] SAIR
set /p opt="Escolha: "
if "%opt%"=="1" goto :OTIMIZAR
if "%opt%"=="2" goto :PREPARAR_BACKUP
if "%opt%"=="3" goto :ABRIR_CF
if "%opt%"=="4" exit
goto :MENU

:OTIMIZAR
echo Aplicando otimizaçoes...
powercfg /setactive SCHEME_MIN
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v DisablePagingExecutive /t REG_DWORD /d 1 /f >nul 2>&1
echo Otimizado!
pause
goto :MENU

:PREPARAR_BACKUP
powershell -Command "Checkpoint-Computer -Description 'Backup_RAM_Total' -RestorePointType 'MODIFY_SETTINGS'"
echo Ponto de restauracao criado!
pause
goto :MENU

:ABRIR_CF
set "CONFIG_DIR=%USERPROFILE%\Documents\Cross Fire"
set "CONFIG_FILE=%CONFIG_DIR%\config_cf.txt"
if exist "%CONFIG_FILE%" (set /p CF_EXEC=<"%CONFIG_FILE%" & set "CF_EXEC=!CF_EXEC:"=!" & if exist "!CF_EXEC!" goto :INICIAR_JOGO)
set /p "LETRA=Digite a letra do disco (ex: C): "
for /f "delims=" %%f in ('dir /s /b "%LETRA%:\cfPT_launcher.exe" 2^>nul') do (set "CF_EXEC=%%f")
if not exist "%CONFIG_DIR%" mkdir "%CONFIG_DIR%"
echo "!CF_EXEC!">"%CONFIG_FILE%"

:INICIAR_JOGO
set /p CF_EXEC=<"%CONFIG_FILE%"
set "CF_EXEC=!CF_EXEC:"=!"
for %%I in ("%CF_EXEC%") do set "JOGO_PASTA=%%~dpI"
pushd "%JOGO_PASTA%"
start "" "cfPT_launcher.exe"
popd
:: Abre uma nova janela do mesmo script passando o argumento MENU_JOGO
start "PAINEL DE OTIMIZACAO" "%~f0" MENU_JOGO
:: Fecha a janela principal que abriu o jogo
exit

:: ==================== PAINEL DO JOGADOR (NOVA JANELA) ====================
:MENU_JOGO
mode con: cols=60 lines=15
cls
echo ==================================================
echo        PAINEL DE OTIMIZACAO DO JOGADOR
echo ==================================================
echo [1] Limpar Memoria RAM
echo [2] Fechar Jogo e Sair
echo [3] Gerenciar Explorer
echo [4] Sair do Painel
echo ==================================================
set /p j_op="Escolha: "
if "%j_op%"=="1" (taskkill /f /im chrome.exe /im msedge.exe /im discord.exe /im steam.exe >nul 2>&1 & echo Limpeza ok! & timeout /t 1 >nul & goto :MENU_JOGO)
if "%j_op%"=="2" (taskkill /f /im cfPT_launcher.exe >nul 2>&1 & start "" explorer.exe & exit)
if "%j_op%"=="3" (taskkill /f /im explorer.exe >nul 2>&1 & timeout /t 1 >nul & start "" explorer.exe & goto :MENU_JOGO)
if "%j_op%"=="4" exit
goto :MENU_JOGO
