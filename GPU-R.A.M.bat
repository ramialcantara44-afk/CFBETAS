@echo off
:: --- CORRECAO PARA NAO PISCAR: Pula direto para o Painel se receber o comando ---
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

:: ==================== CONFIGURACOES GERAIS ====================
for /F %%a in ('echo prompt $E ^| cmd') do set "esc=%%a"

cls
for /L %%i in (1,1,6) do (
    set /a "r=%random% %% 255", "g=%random% %% 255", "b=%random% %% 255"
    echo.
    echo           %esc%[38;2;!r!;!g!;!b%m%     CARREGANDO... [%%i/6] %esc%[0m
    timeout /t 1 >nul
)

:MENU
set /a "r=%random% %% 255", "g=%random% %% 255", "b=%random% %% 255"
set "rgb=%esc%[38;2;%r%;%g%;%b%m"
set "reset=%esc%[0m"

cls
echo %rgb%
echo           █████╗ ███╗   ██╗████████╗██╗  ██████╗  █████╗ 
echo           ██╔══██╗████╗  ██║╚══██╔══╝██║ ██╔════╝ ██╔══██╗
echo           ███████║██╔██╗ ██║   ██║   ██║ ██║  ███╗███████║
echo           ██╔══██║██║╚████║   ██║   ██║ ██║   ██║██╔══██║
echo           ██║  ██║██║ ╚███║   ██║   ██║ ╚██████╔╝██║  ██║
echo           ╚═╝  ╚═╝╚═╝  ╚═══╝   ╚═╝   ╚═╝  ╚═════╝ ╚═╝  ╚═╝
echo           COPYRIGHT (C) 2026. TODOS OS DIREITOS RESERVADOS.
echo ==================================================
echo %esc%[38;2;0;255;0m    [1] OTIMIZAR (PROFUNDO)%reset%
echo %esc%[38;2;255;0;0m          [2] CRIAR PONTO DE RESTAURACAO%reset%
echo %esc%[38;2;255;255;0m              [3] ABRIR CROSSFIRE%reset%
echo %esc%[38;2;128;128;128m                [4] GERENCIAR DXVK (VULKAN)%reset%
echo %esc%[38;2;255;255;255m                 [5] SAIR%reset%
echo ==================================================
set /p opt="Escolha uma opcao: "
if "%opt%"=="1" goto :CONFIRMAR_OTIMIZAR
if "%opt%"=="2" goto :PREPARAR_BACKUP
if "%opt%"=="3" goto :ABRIR_CF
if "%opt%"=="4" goto :GERENCIAR_DXVK
if "%opt%"=="5" exit
goto :MENU

:CONFIRMAR_OTIMIZAR
cls
echo %esc%[38;2;255;0;0m!!! ATENCAO: MODIFICACOES PROFUNDAS NO SISTEMA !!!%reset%
set /p confirm="Deseja prosseguir? (S/N): "
if /i "%confirm%"=="S" goto :OTIMIZAR
goto :MENU

:OTIMIZAR
echo APLICANDO OTIMIZACOES...
powercfg /setactive SCHEME_MIN
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v DisablePagingExecutive /t REG_DWORD /d 1 /f >nul 2>&1
echo OTIMIZACAO CONCLUIDA!
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
:: --- ABRIR PAINEL EM JANELA SEPARADA ---
start "PAINEL DE OTIMIZACAO" "%~f0" MENU_JOGO
exit

:: ==================== PAINEL DO JOGADOR ====================
:MENU_JOGO
cls
echo --- PAINEL DE OTIMIZACAO DO JOGADOR ---
echo [1] Limpar Memoria RAM
echo [2] Fechar Jogo e Sair
echo [3] Gerenciar Explorer
echo [4] Sair
set /p j_op="Escolha: "
if "%j_op%"=="1" (taskkill /f /im chrome.exe /im msedge.exe /im discord.exe /im steam.exe >nul 2>&1 & goto :MENU_JOGO)
if "%j_op%"=="2" (taskkill /f /im cfPT_launcher.exe >nul 2>&1 & start "" explorer.exe & exit)
if "%j_op%"=="3" (taskkill /f /im explorer.exe >nul 2>&1 & timeout /t 1 >nul & start "" explorer.exe & goto :MENU_JOGO)
if "%j_op%"=="4" exit
goto :MENU_JOGO

:GERENCIAR_DXVK
echo Em desenvolvimento...
pause
goto :MENU
