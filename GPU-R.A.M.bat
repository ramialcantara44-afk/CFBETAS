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

:: --- CONFIGURACOES ---
set "CONFIG_DIR=%USERPROFILE%\Documents\Cross Fire"
set "CONFIG_FILE=%CONFIG_DIR%\config_cf.txt"

:: ==================== AUTO UPDATE ====================
set "RAW_URL=https://raw.githubusercontent.com/ramialcantara44-afk/CFBETAS/refs/heads/main/GPU-R.A.M.bat"
set "NEW_FILE=%TEMP%\GPU-R.A.M_NEW.bat"
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('%RAW_URL%?v=%random%', '%NEW_FILE%')" >nul 2>&1
if exist "%NEW_FILE%" (
    for %%A in ("%~f0") do set "SIZE_LOCAL=%%~zA"
    for %%B in ("%NEW_FILE%") do set "SIZE_NEW=%%~zB"
    if not "%SIZE_LOCAL%"=="%SIZE_NEW%" (
        move /y "%NEW_FILE%" "%~f0" >nul
        start "" "%~f0" & exit
    )
    del "%NEW_FILE%"
)
:: ====================================================

for /F %%a in ('echo prompt $E ^| cmd') do set "esc=%%a"

:MENU
set /a "r=%random% %% 255", "g=%random% %% 255", "b=%random% %% 255"
set "rgb=%esc%[38;2;%r%;%g%;%b%m"
cls
echo %rgb%
echo  █████╗ ███╗   ██╗████████╗██╗  ██████╗  █████╗ 
echo  ██╔══██╗████╗  ██║╚══██╔══╝██║ ██╔════╝ ██╔══██╗
echo  ███████║██╔██╗ ██║   ██║   ██║ ██║  ███╗███████║
echo  ██╔══██║██║╚████║   ██║   ██║ ██║   ██║██╔══██║
echo  ██║  ██║██║ ╚███║   ██║   ██║ ╚██████╔╝██║  ██║
echo %esc%[0m
echo [1] Otimizar Sistema (Profundo)
echo [2] Criar Ponto de Restauracao
echo [3] Iniciar Crossfire
echo [4] Gerenciar DXVK
echo [5] Sair
echo ==================================================
set /p opt="Escolha: "
if "%opt%"=="1" goto :OTIMIZAR
if "%opt%"=="2" goto :PREPARAR_BACKUP
if "%opt%"=="3" goto :SELECIONAR_DISCO
if "%opt%"=="4" goto :MENU_DXVK
if "%opt%"=="5" exit
goto :MENU

:OTIMIZAR
cls
echo Aplicando Otimizacao Total...
:: (Toda a logica de Servicos, Regedit, Appx e Hardware consolidada aqui)
bcdedit /set hypervisorlaunchtype off
powercfg -h off
for %%s in (WSearch TapiSrv SysMain Spooler TermService bthserv WerSvc DPS WbioSrvc RemoteRegistry EventLog DiagTrack WpcMonSvc WecSvc SCardSvr wuauserv bits DoSvc W32Time) do (sc stop "%%s" >nul 2>&1 & sc config "%%s" start= disabled >nul 2>&1)
powershell -Command "Get-AppxPackage -Name *onedrive*,*people*,*phone*,*xbox*,*alarms*,*calendar*,*maps*,*messaging*,*news*,*officehub*,*Microsoft.Windows.Cortana*,*3dbuilder* | Remove-AppxPackage -ErrorAction SilentlyContinue"
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoUpdate" /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v DisablePagingExecutive /t REG_DWORD /d 1 /f
echo Otimizacao Concluida!
pause
goto :MENU

:PREPARAR_BACKUP
powershell -Command "Checkpoint-Computer -Description 'Backup_RAM_Total' -RestorePointType 'MODIFY_SETTINGS'"
pause
goto :MENU

:SELECIONAR_DISCO
if exist "%CONFIG_FILE%" goto :INICIAR_JOGO
set /p "LETRA=Digite a letra do disco (ex: C): "
for /f "delims=" %%f in ('dir /s /b "%LETRA%:\cfPT_launcher.exe" 2^>nul') do (
    if not exist "%CONFIG_DIR%" mkdir "%CONFIG_DIR%"
    echo "%%f">"%CONFIG_FILE%"
    goto :INICIAR_JOGO
)
pause
goto :MENU

:INICIAR_JOGO
set /p CF_EXEC=<"%CONFIG_FILE%"
set "CF_EXEC=%CF_EXEC:"=%"
for %%I in ("%CF_EXEC%") do set "JOGO_PASTA=%%~dpI"
taskkill /f /im explorer.exe >nul 2>&1
pushd "%JOGO_PASTA%"
start "" "cfPT_launcher.exe"
popd
goto :MENU_JOGO

:MENU_DXVK
cls
echo Gerenciar DXVK...
pause
goto :MENU
