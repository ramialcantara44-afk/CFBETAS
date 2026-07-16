@echo off
:: Verifica se o arquivo de controle existe para abrir direto o menu do jogador
if exist "%temp%\modo_jogo.txt" (
    del "%temp%\modo_jogo.txt"
    goto :MENU_JOGO
)

setlocal EnableDelayedExpansion
chcp 65001 >nul
title BETA - OTIMIZACAO

:: ==================== VERIFICAR ADMIN ====================
net session >nul 2>&1
if %errorLevel% NEQ 0 (
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit
)

:: ==================== AUTO UPDATE ====================
echo Verificando atualizacoes...
set "RAW_URL=https://raw.githubusercontent.com/ramialcantara44-afk/CFBETAS/refs/heads/main/GPU-R.A.M.bat"
set "NEW_FILE=%~dp0GPU-R.A.M_NEW.bat"
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('%RAW_URL%?v=%random%', '%NEW_FILE%')" >nul 2>&1
if exist "%NEW_FILE%" (
    fc "%~f0" "%NEW_FILE%" >nul 2>&1
    if errorlevel 1 (
        echo Nova versao encontrada! Atualizando...
        powershell -Command "Start-Sleep -Seconds 2; Move-Item -Path '%NEW_FILE%' -Destination '%~f0' -Force; Start-Process '%~f0'"
        exit
    ) else ( del "%NEW_FILE%" >nul 2>&1 )
)

:: ==================== MENU PRINCIPAL ====================
for /F %%a in ('echo prompt $E ^| cmd') do set "esc=%%a"
:MENU
cls
echo █████╗ ███╗   ██╗████████╗██╗  ██████╗  █████╗ 
echo ██╔══██╗████╗  ██║╚══██╔══╝██║ ██╔════╝ ██╔══██╗
echo ███████║██╔██╗ ██║   ██║   ██║ ██║  ███╗███████║
echo ██╔══██║██║╚████║   ██║   ██║ ██║   ██║██╔══██║
echo ██║  ██║██║ ╚███║   ██║   ██║ ╚██████╔╝██║  ██║
echo ╚═╝  ╚═╝╚═╝  ╚═══╝   ╚═╝   ╚═╝  ╚═════╝ ╚═╝  ╚═╝
echo [1] OTIMIZAR [2] BACKUP [3] ABRIR JOGO [4] DXVK [5] SAIR
set /p opt="Escolha: "
if "%opt%"=="1" goto :OTIMIZAR
if "%opt%"=="2" goto :PREPARAR_BACKUP
if "%opt%"=="3" goto :ABRIR_CF
if "%opt%"=="4" goto :GERENCIAR_DXVK
if "%opt%"=="5" exit
goto :MENU

:OTIMIZAR
powercfg /setactive SCHEME_MIN
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v DisablePagingExecutive /t REG_DWORD /d 1 /f
echo Otimizado!
pause
goto :MENU

:PREPARAR_BACKUP
powershell -Command "Checkpoint-Computer -Description 'Backup_RAM_Total' -RestorePointType 'MODIFY_SETTINGS'"
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
:: Cria sinalizador para o painel abrir em nova janela
echo. >"%temp%\modo_jogo.txt"
start "PAINEL DE OTIMIZACAO" "%~f0"
exit

:MENU_JOGO
cls
echo --- PAINEL DE OTIMIZACAO DO JOGADOR ---
echo [1] Limpar Memoria | [2] Fechar Jogo e Sair | [3] Gerenciar Explorer | [4] Sair
set /p j_op="Escolha: "
if "%j_op%"=="1" (taskkill /f /im chrome.exe /im msedge.exe /im discord.exe /im steam.exe >nul 2>&1 & goto :MENU_JOGO)
if "%j_op%"=="2" (taskkill /f /im cfPT_launcher.exe >nul 2>&1 & start "" explorer.exe & exit)
if "%j_op%"=="3" (taskkill /f /im explorer.exe >nul 2>&1 & timeout /t 2 >nul & start "" explorer.exe & goto :MENU_JOGO)
if "%j_op%"=="4" exit
goto :MENU_JOGO

:GERENCIAR_DXVK
echo Em desenvolvimento...
pause
goto :MENU
