@echo off
setlocal EnableDelayedExpansion
chcp 65001 >nul
title BETA - OTIMIZACAO

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
    ) else (
        del "%NEW_FILE%" >nul 2>&1
    )
)

:: ==================== CONFIGURACOES GERAIS ====================
for /F %%a in ('echo prompt $E ^| cmd') do set "esc=%%a"

:: --- ANIMACAO DE ABERTURA ---
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

:: ==================== FUNCOES DE OTIMIZACAO ====================
:CONFIRMAR_OTIMIZAR
cls
echo %esc%[38;2;255;0;0m!!! ATENCAO: MODIFICACOES PROFUNDAS NO SISTEMA !!!%reset%
echo.
set /p confirm="Deseja prosseguir com a APLICACAO TOTAL destas mudancas? (S/N): "
if /i "%confirm%"=="S" goto :OTIMIZAR
goto :MENU

:OTIMIZAR
cls
echo APLICANDO OTIMIZACOES PROFUNDAS...
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMAX 100
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMIN 100
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR IDLEDISABLE 1
powercfg /setactive SCHEME_MIN
powercfg -h off
bcdedit /set hypervisorlaunchtype off

:: Registros de Memoria e Performance
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v LargeSystemCache /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v IoPageLockLimit /t REG_DWORD /d 0x000F4240 /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v DisablePagingExecutive /t REG_DWORD /d 1 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v LaunchTo /t REG_DWORD /d 1 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v SeparateProcess /t REG_DWORD /d 1 /f

:: Input Lag
reg add "HKEY_CURRENT_USER\Control Panel\Mouse" /v MouseSpeed /t REG_SZ /d 0 /f
reg add "HKEY_CURRENT_USER\Control Panel\Accessibility\Keyboard Response" /v DelayBeforeAcceptance /t REG_SZ /d 0 /f

:: Servicos e Limpeza
for %%s in (WSearch SysMain DiagTrack wisvc DPS TermService WbioSrvc TabletInputService wuauserv bits DoSvc WaaSMedicSvc RetailDemo igts bthserv RemoteRegistry SessionEnv W32Time) do (
    sc stop "%%s" >nul 2>&1
    sc config "%%s" start= disabled >nul 2>&1
)

powershell -Command "Get-AppxPackage *news*,*officehub*,*3dbuilder*,*Cortana*,*alarms*,*calendar*,*maps*,*messaging*,*people*,*phone*,*xbox*,*onedrive* | Remove-AppxPackage; [System.GC]::Collect()"
taskkill /f /im explorer.exe >nul 2>&1
start "" "%windir%\explorer.exe"
echo OTIMIZACAO CONCLUIDA! REINICIE O PC.
pause
goto :MENU

:PREPARAR_BACKUP
powershell -Command "Checkpoint-Computer -Description 'Backup_RAM_Total' -RestorePointType 'MODIFY_SETTINGS'"
echo Ponto de restauracao criado!
pause
goto :MENU

:: ==================== JOGO E DXVK ====================
:ABRIR_CF
set "CONFIG_DIR=%USERPROFILE%\Documents\Cross Fire"
set "CONFIG_FILE=%CONFIG_DIR%\config_cf.txt"

if exist "%CONFIG_FILE%" (
    set /p CF_EXEC=<"%CONFIG_FILE%"
    set "CF_EXEC=!CF_EXEC:"=!"
    if exist "!CF_EXEC!" goto :INICIAR_JOGO
)

set /p "LETRA=Configuracao nao encontrada. Digite a letra do disco (ex: C): "
for /f "delims=" %%f in ('powershell -Command "Get-ChildItem -Path '%LETRA%:\' -Filter 'cfPT_launcher.exe' -Recurse -ErrorAction SilentlyContinue | Select-Object -ExpandProperty FullName -First 1"') do (set "CF_EXEC=%%f")

if not defined CF_EXEC (
    echo Arquivo nao encontrado!
    pause
    goto :MENU
)

if not exist "%CONFIG_DIR%" mkdir "%CONFIG_DIR%"
echo "%CF_EXEC%">"%CONFIG_FILE%"

:INICIAR_JOGO
:: Limpa e carrega o caminho novamente para garantir
set /p CF_EXEC=<"%CONFIG_FILE%"
set "CF_EXEC=!CF_EXEC:"=!"

echo Iniciando o jogo...
start "" "%CF_EXEC%"

:: ESTA PARTE E CRUCIAL:
:: O comando 'timeout' da um tempo para o jogo carregar 
:: antes de exibir o menu, evitando que a janela feche.
timeout /t 5 >nul

:: Redireciona obrigatoriamente para o menu do jogador
goto :MENU_JOGO

:GERENCIAR_DXVK
echo [1] Instalar DXVK | [2] Remover DXVK
set /p sub_op="Opcao: "
if "%sub_op%"=="1" goto :SELECIONAR_DISCO_INST
if "%sub_op%"=="2" goto :SELECIONAR_DISCO_REM
goto :MENU

:SELECIONAR_DISCO_INST
set /p DISCO="Disco do jogo (ex: C): "
for /f "delims=" %%f in ('dir /s /b "%DISCO%:\cfPT_launcher.exe" 2^>nul') do (set "CF_PATH=%%~dpf")
set "TEMP_DXVK=%temp%\dxvk_setup"
mkdir "%TEMP_DXVK%"
powershell -Command "Invoke-WebRequest -Uri 'https://github.com/doitsujin/dxvk/releases/download/v1.10.3/dxvk-1.10.3.tar.gz' -OutFile '%TEMP_DXVK%\dxvk.tar.gz'; tar -xzf '%TEMP_DXVK%\dxvk.tar.gz' -C '%TEMP_DXVK%'"
copy "%TEMP_DXVK%\dxvk-1.10.3\x32\d3d9.dll" "%CF_PATH%\" /y >nul
copy "%TEMP_DXVK%\dxvk-1.10.3\x32\dxgi.dll" "%CF_PATH%\" /y >nul
rd /s /q "%TEMP_DXVK%"
echo Instalado!
pause
goto :MENU

:SELECIONAR_DISCO_REM
set /p DISCO="Disco do jogo: "
for /f "delims=" %%f in ('dir /s /b "%DISCO%:\cfPT_launcher.exe" 2^>nul') do (set "CF_PATH=%%~dpf")
del /f /q "%CF_PATH%d3d9.dll" "%CF_PATH%dxgi.dll" >nul 2>&1
echo Removido!
pause
goto :MENU

:MENU_JOGO
cls
echo --- MENU DO JOGADOR ---
echo [1] Limpar Memoria | [2] Fechar Jogo e Sair | [3] Gerenciar Explorer
set /p j_op="Escolha: "
if "%j_op%"=="1" (taskkill /f /im chrome.exe /im msedge.exe /im discord.exe /im steam.exe >nul 2>&1 & goto :MENU_JOGO)
if "%j_op%"=="2" (taskkill /f /im cfPT_launcher.exe >nul 2>&1 & start "" explorer.exe & goto :MENU)
if "%j_op%"=="3" (taskkill /f /im explorer.exe >nul 2>&1 & pause & start "" explorer.exe & goto :MENU_JOGO)
goto :MENU_JOGO
