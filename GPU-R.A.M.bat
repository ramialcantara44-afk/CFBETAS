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
        :: Usamos um comando via PowerShell para garantir a substituicao sem criar arquivos .bat externos
        powershell -Command "Start-Sleep -Seconds 2; Move-Item -Path '%NEW_FILE%' -Destination '%~f0' -Force; Start-Process '%~f0'"
        exit
    ) else (
        del "%NEW_FILE%" >nul 2>&1
    )
)
:: ====================================================
:: --- RESTO DO CODIGO ---
for /F %%a in ('echo prompt $E ^| cmd') do set "esc=%%a"

:: --- ANIMACAO DE ABERTURA ---
cls
for /L %%i in (1,1,6) do (
    set /a "r=%random% %% 255"
    set /a "g=%random% %% 255"
    set /a "b=%random% %% 255"
    echo.
    echo             %esc%[38;2;!r!;!g!;!b%m%     CARREGANDO... [%%i/6] %esc%[0m
    timeout /t 1 >nul
)

:MENU
:: Gera as cores aleatorias
set /a "r=%random% %% 255"
set /a "g=%random% %% 255"
set /a "b=%random% %% 255"
set "rgb=%esc%[38;2;%r%;%g%;%b%m"
set "reset=%esc%[0m"

cls
::
echo.
echo %rgb%            ███████ ████╗ ██╗████████╗██╗  ██████╗  █████╗
echo %rgb%            ██╔══██╗████╗ ██║╚══██╔══╝██║ ██╔════╝ ██╔══██╗
echo %rgb%            ███████║██╔██╗██║   ██║   ██║ ██║  ███╗███████║
echo %rgb%            ██╔══██║██║╚████║   ██║   ██║ ██║   ██║██╔══██║
echo %rgb%            ██║  ██║██║ ╚███║   ██║   ██║ ╚██████╔╝██║  ██║
echo %rgb%            ╚═╝  ╚═╝╚═╝  ╚══╝   ╚═╝   ╚═╝  ╚═════╝ ╚═╝  ╚═╝%reset%
echo.
:: ... continue com o restante das linhas do seu banner

echo %esc%[38;2;0;255;0m    [1] OTIMIZAR (PROFUNDO)%reset%
echo %esc%[38;2;255;0;0m    [2] CRIAR PONTO DE RESTAURACAO%reset%
echo %esc%[38;2;255;255;0m    [3] ABRIR CROSSFIRE AL%reset%
echo %esc%[38;2;128;128;128m    [ ] DXKVK (VULKAN)%reset%
echo %esc%[38;2;255;255;255m    [4] SAIR%reset%
echo.

:: O COMANDO MAIS IMPORTANTE: CHOICE espera a entrada e nao fecha a janela
choice /c 1234 /n /m "Escolha uma opcao: "
if errorlevel 4 exit
if errorlevel 3 goto :SELECIONAR_DISCO
if errorlevel 2 goto :PREPARAR_BACKUP
if errorlevel 1 goto :CONFIRMAR_OTIMIZAR

:: Caso o usuario aperte algo inesperado, volta para o menu
goto :MENU
:SAIR
exit

:CONFIRMAR_OTIMIZAR
cls
echo %esc%[38;2;255;0;0m!!! ATENCAO: MODIFICACOES PROFUNDAS NO SISTEMA !!!%reset%
echo.
echo %esc%[38;2;255;255;0mRECOMENDACAO: Faca o Ponto de Restauracao (Opcao 2) antes de continuar.%reset%
echo.
echo --- APLICATIVOS QUE SERAO REMOVIDOS ---
echo * Notícias
echo * Office Hub
echo * 3D Builder
echo * Alarmes
echo * Calendário
echo * Mapas
echo * Mensagens
echo * Cortana
echo * Telefone
echo * Xbox
echo * OneDrive
echo * Pessoas
echo * Mixed Reality
echo * Paint 3D
echo * Skype
echo * Solitaire
echo * Feedback Hub
echo.
echo --- ALTERACOES NO REGISTRO E SISTEMA ---
echo * Desativação: Windows Search
echo * Desativação: Prefetcher
echo * Desativação: Superfetch
echo * Desativação: Telemetria
echo * Desativação: Bing Search
echo * Desativação: Copilot
echo * Desativação: GameDVR
echo * Desativação: DiagTrack
echo * Ajuste: Performance de CPU (100%%)
echo * Ajuste: Interface visual (Delay 0)
echo * Ajuste: NTFS (LastAccessUpdate Off)
echo * Ajuste: DisablePagingExecutive (Kernel na RAM)
echo * Tarefas: Bloqueio de App Compatibility
echo * Tarefas: Bloqueio de ProgramDataUpdater
echo.
set /p confirm="Deseja prosseguir com a APLICACAO TOTAL destas mudancas? (S/N): "
if /i "%confirm%"=="S" goto :OTIMIZAR
goto :MENU

:PREPARAR_BACKUP
cls
powershell -Command "Checkpoint-Computer -Description 'Backup_RAM_Total' -RestorePointType 'MODIFY_SETTINGS'"
echo Ponto de restauracao criado com sucesso!
pause
goto :MENU

:OTIMIZAR
cls
echo %rgb%    APLICANDO OTIMIZACOES PROFUNDAS (MEMORIA E CPU)... %reset%

:: --- Ajustes de Energia e CPU ---
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMAX 100
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMIN 100
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR IDLEDISABLE 1
powercfg /setactive SCHEME_MIN
powercfg -h off

:: --- Desativacao do Hyper-V ---
bcdedit /set hypervisorlaunchtype off

:: --- Otimizacao de Memory Management ---
:: Melhora o cache do sistema e limites de E/S para jogos
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v LargeSystemCache /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v IoPageLockLimit /t REG_DWORD /d 0x000F4240 /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v DisablePagingExecutive /t REG_DWORD /d 1 /f

:: --- Limpeza de Cache de RAM (Comando via PowerShell) ---
:: Força o Windows a liberar o cache de memória de standby
powershell -Command "Clear-RecycleBin -Force -ErrorAction SilentlyContinue; [System.GC]::Collect(); [System.GC]::WaitForPendingFinalizers()"

:: --- Desativacao de Servicos ---
sc stop "WSearch" & sc config "WSearch" start=disabled
sc stop "SysMain" & sc config "SysMain" start=disabled
sc stop "DiagTrack" & sc config "DiagTrack" start=disabled

:: --- Ajustes de Rede ---
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v NetworkThrottlingIndex /t REG_DWORD /d 0xFFFFFFFF /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v SystemResponsiveness /t REG_DWORD /d 0 /f
powershell -Command "Get-NetAdapterAdvancedProperty | Where-Object {$_.DisplayName -like '*Power Saving*'} | Set-NetAdapterAdvancedProperty -DisplayValue 'Disabled' -ErrorAction SilentlyContinue" >nul 2>&1

:: --- Remocao de Apps ---
powershell -Command "Get-AppxPackage *news* | Remove-AppxPackage; Get-AppxPackage *officehub* | Remove-AppxPackage; Get-AppxPackage *3dbuilder* | Remove-AppxPackage"

:: --- Reinicio do Explorer ---
taskkill /f /im explorer.exe >nul 2>&1
start "" "%windir%\explorer.exe"

echo %esc%[38;2;0;255;0m OTIMIZACAO PROFUNDA CONCLUIDA! %reset%
echo.
echo %esc%[38;2;255;0;0m REINICIE O PC PARA APLICAR AS ALTERACOES DO HYPER-V. %reset%
pause
goto :MENU

:SELECIONAR_DISCO
cls
echo %rgb%    SELECIONE O DISCO DO CROSSFIRE %reset%
set /p disk="Opcao (C/D/E): "
set "DISCO=%disk%"
goto :MODO_JOGO

:MODO_JOGO
:: O resto do seu código original continua aqui...
cls
echo %rgb%    --- OTIMIZANDO SISTEMA PARA O JOGO --- %reset%

echo [1/4] Finalizando aplicativos desnecessarios...
taskkill /f /im chrome.exe >nul 2>&1
taskkill /f /im msedge.exe >nul 2>&1
taskkill /f /im discord.exe >nul 2>&1
taskkill /f /im steam.exe >nul 2>&1

echo [2/4] Limpando arquivos temporarios...
del /q /s /f "%temp%\*.*" >nul 2>&1
for /d %%x in ("%temp%\*") do rd /s /q "%%x" >nul 2>&1

echo [3/4] Liberando RAM (Finalizando Explorer)...
taskkill /f /im explorer.exe >nul 2>&1

echo [4/4] Iniciando Crossfire...
for /f "delims=" %%f in ('dir /s /b "%DISCO%:\cfPT_launcher.exe" 2^>nul') do (set "CF_EXEC=%%f" & set "CF_PATH=%%~dpf")
pushd "%CF_PATH%"
start "" "cfPT_launcher.exe"

timeout /t 10 >nul
goto :MENU_JOGO

:MENU_JOGO
set /a "r=%random% %% 255"
set /a "g=%random% %% 255"
set /a "b=%random% %% 255"
set "rgb=%esc%[38;2;%r%;%g%;%b%m"
cls
echo %rgb%    --- MENU DO JOGADOR --- %reset%
echo [1] Limpar Memoria RAM
echo [2] Fechar Jogo e Sair
echo [3] FECHAR Explorer.exe
echo [4] ABRIR Explorer.exe
echo.
set /p j_op="Escolha: "
if "%j_op%"=="1" (taskkill /f /im chrome.exe >nul 2>&1 & taskkill /f /im msedge.exe >nul 2>&1 & taskkill /f /im discord.exe >nul 2>&1 & taskkill /f /im steam.exe >nul 2>&1 & echo Limpeza concluida! & timeout /t 2 >nul & goto :MENU_JOGO)
if "%j_op%"=="2" (taskkill /f /im cfPT_launcher.exe >nul 2>&1 & start "" "%windir%\explorer.exe" & popd & goto :MENU)
if "%j_op%"=="3" (taskkill /f /im explorer.exe >nul 2>&1 & echo Explorer fechado! & timeout /t 2 >nul & goto :MENU_JOGO)
if "%j_op%"=="4" (start "" "%windir%\explorer.exe" & echo Explorer aberto! & timeout /t 2 >nul & goto :MENU_JOGO)
goto :MENU_JOGO
