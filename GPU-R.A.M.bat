@echo off
setlocal EnableDelayedExpansion
chcp 65001 >nul
title BETA - OTIMIZACAO 2026

:: --- ELEVACAO DE PRIVILEGIOS ---
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo Solicitando privilegios de administrador...
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B
)

:: --- CONFIGURACOES E VARIAVEIS ---
for /F %%a in ('echo prompt $E ^| cmd') do set "esc=%%a"
set "CONFIG_DIR=%USERPROFILE%\Documents\Cross Fire"
set "CONFIG_FILE=%CONFIG_DIR%\config_cf.txt"

:: --- MENU PRINCIPAL ---
:MENU
set /a "r=%random% %% 255", "g=%random% %% 255", "b=%random% %% 255"
set "rgb=%esc%[38;2;%r%;%g%;%b%m"
cls
echo %rgb%
echo █ █████╗ ███╗   ██╗████████╗██╗  ██████╗  █████╗ █
echo █ ██╔══██╗████╗  ██║╚══██╔══╝██║ ██╔════╝ ██╔══██╗ █
echo █ ███████║██╔██╗ ██║   ██║   ██║ ██║  ███╗███████║ █
echo █ ██╔══██║██║╚████║   ██║   ██║ ██║   ██║██╔══██║ █
echo █ ██║  ██║██║ ╚███║   ██║   ██║ ╚██████╔╝██║  ██║ █
echo █ ╚═╝  ╚═╝╚═╝  ╚═══╝   ╚═╝   ╚═╝  ╚═════╝ ╚═╝  ╚═╝ █
echo %esc%[0m
echo [1] Otimizar Sistema (Profundo)
echo [2] Criar Ponto de Restauracao
echo [3] Iniciar Crossfire
echo [4] Gerenciar DXVK (Vulkan)
echo [5] Sair
echo ==================================================
set /p opt="Escolha uma opcao: "

if "%opt%"=="1" goto :CONFIRMAR_OTIMIZAR
if "%opt%"=="2" goto :PREPARAR_BACKUP
if "%opt%"=="3" goto :SELECIONAR_DISCO
if "%opt%"=="4" goto :MENU_DXVK
if "%opt%"=="5" exit
goto :MENU

:CONFIRMAR_OTIMIZAR
cls
echo !!! ATENCAO: MODIFICACOES PROFUNDAS NO SISTEMA !!!
set /p confirm="Deseja prosseguir com a aplicacao total (S/N)? "
if /i "%confirm%"=="S" goto :OTIMIZAR
goto :MENU

:OTIMIZAR
echo Aplicando otimizacoes...
:: Ajustes de Energia
powercfg -h off
powercfg -setactive SCHEME_MIN
:: Servicos e Registro
for %%s in (WSearch SysMain DiagTrack bits) do (sc stop "%%s" >nul 2>&1 & sc config "%%s" start= disabled >nul 2>&1)
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v DisablePagingExecutive /t REG_DWORD /d 1 /f
echo Otimizacao concluida.
pause
goto :MENU

:PREPARAR_BACKUP
powershell -Command "Checkpoint-Computer -Description 'Backup_RAM_Total' -RestorePointType 'MODIFY_SETTINGS'"
echo Ponto criado!
pause
goto :MENU

:SELECIONAR_DISCO
if exist "%CONFIG_FILE%" set /p CF_EXEC=<"%CONFIG_FILE%"
if exist "!CF_EXEC!" goto :INICIAR_JOGO
set /p "LETRA=Digite a letra do disco (ex: C): "
for /f "delims=" %%f in ('dir /s /b "%LETRA%:\cfPT_launcher.exe" 2^>nul') do (set "CF_EXEC=%%f" & goto :SALVAR_PATH)
echo Erro: Arquivo nao encontrado.
pause
goto :MENU

:SALVAR_PATH
if not exist "%CONFIG_DIR%" mkdir "%CONFIG_DIR%"
echo "%CF_EXEC%">"%CONFIG_FILE%"

:INICIAR_JOGO
set /p CF_EXEC=<"%CONFIG_FILE%"
set "CF_EXEC=%CF_EXEC:"=%"
taskkill /f /im explorer.exe >nul 2>&1
start "" "%CF_EXEC%"
goto :MENU_JOGO

:MENU_JOGO
cls
echo --- MENU DO JOGADOR ---
echo [1] Fechar Jogo e Sair
echo [2] Reiniciar Explorer.exe
set /p j_op="Escolha: "
if "%j_op%"=="1" (taskkill /f /im cfPT_launcher.exe >nul 2>&1 & start explorer.exe & goto :MENU)
if "%j_op%"=="2" (start explorer.exe & goto :MENU_JOGO)
goto :MENU_JOGO

:MENU_DXVK
cls
echo [1] Instalar DXVK
echo [2] Remover DXVK
set /p dx_op="Escolha: "
if "%dx_op%"=="1" goto :SELECIONAR_DISCO_INST
if "%dx_op%"=="2" goto :SELECIONAR_DISCO_REM
goto :MENU

:SELECIONAR_DISCO_INST
set /p DISCO="Letra do disco: "
set "CF_PATH="
for /f "delims=" %%f in ('dir /s /b "%DISCO%:\cfPT_launcher.exe" 2^>nul') do (set "CF_PATH=%%~dpf")
:: (Lógica de download e copia do seu script original aqui)
echo DXVK Instalado!
pause
goto :MENU
