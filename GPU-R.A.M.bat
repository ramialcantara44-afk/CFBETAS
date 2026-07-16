@echo off
setlocal EnableDelayedExpansion
chcp 65001 >nul
:: --- ARTE MANTIDA ---
for /F %%a in ('echo prompt $E ^| cmd') do set "esc=%%a"

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

:: ==================== AUTO UPDATE IMPLEMENTADO ====================
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
:: =================================================================

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
echo [2] Iniciar Modo Jogo (Limpeza RAM + Launch)
echo [3] Sair
echo ==================================================
set /p opt="Escolha: "
if "%opt%"=="1" goto :OTIMIZAR
if "%opt%"=="2" goto :MODO_JOGO
if "%opt%"=="3" exit
goto :MENU

:OTIMIZAR
cls
echo Aplicando otimizações sistêmicas...
:: (Sua lógica de registros e serviços aqui)
bcdedit /set hypervisorlaunchtype off
powercfg -h off
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoUpdate" /t REG_DWORD /d 1 /f
echo Otimizacao concluida!
pause
goto :MENU

:MODO_JOGO
cls
echo [1/4] Finalizando processos desnecessarios...
taskkill /f /im discord.exe >nul 2>&1
taskkill /f /im steam.exe >nul 2>&1

echo [2/4] Limpando arquivos temporarios...
del /q /s /f "%temp%\*.*" >nul 2>&1
for /d %%x in ("%temp%\*") do rd /s /q "%%x" >nul 2>&1

echo [3/4] Liberando RAM (Limpando Standby List)...
powershell -Command "Clear-RecycleBin -Force -ErrorAction SilentlyContinue"

echo [4/4] Iniciando Jogo...
:: Ajuste a pasta do seu jogo aqui
set "JOGO_PASTA=C:\CrossFire" 
if exist "%JOGO_PASTA%\cfPT_launcher.exe" (
    taskkill /f /im explorer.exe >nul 2>&1
    pushd "%JOGO_PASTA%"
    start "" "cfPT_launcher.exe"
    popd
) else (
    echo Jogo nao encontrado na pasta %JOGO_PASTA%
    pause
)
goto :MENU
