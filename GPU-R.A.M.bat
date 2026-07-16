@echo off
net session >nul 2>&1
if %errorLevel% == 0 (
    goto :admin_ok
) else (
    echo Pedindo privilegios de administrador...
    powershell start -verb runas '%0'
    exit
)
:admin_ok
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
:: (coloque aqui o resto do seu código do MENU em diante)
set /a "r=%random% %% 255"
set /a "g=%random% %% 255"
set /a "b=%random% %% 255"
set "rgb=%esc%[38;2;%r%;%g%;%b%m"
set "reset=%esc%[0m"

cls
echo %rgb%
cls
echo %rgb%                           █████╗ ███╗   ██╗████████╗██╗  ██████╗  █████╗ %reset%
echo %rgb%                           ██╔══██╗████╗ ██║╚══██╔══╝██║ ██╔════╝ ██╔══██╗%reset%
echo %rgb%                           ███████║██╔██╗██║   ██║   ██║ ██║  ███╗███████║%reset%
echo %rgb%                           ██╔══██║██║╚████║   ██║   ██║ ██║   ██║██╔══██║%reset%
echo %rgb%                           ██║  ██║██║ ╚███║   ██║   ██║ ╚██████╔╝██║  ██║%reset%
echo %rgb%                           ╚═╝  ╚═╝╚═╝  ╚═══╝   ╚═╝   ╚═╝  ╚═════╝ ╚═╝  ╚═╝
echo %rgb%                           COPYRIGHT (C) 2026. TODOS OS DIREITOS RESERVADOS.
echo ==================================================
echo %esc%[38;2;0;255;0m    [1] OTIMIZAR (PROFUNDO)%reset%
echo %esc%[38;2;255;0;0m          [2] CRIAR PONTO DE RESTAURACAO%reset%
echo %esc%[38;2;255;255;0m              [3] ABRIR CROSSFIRE%reset%
echo %esc%[38;2;128;128;128m                [4] GERENCIAR DXVK (VULKAN)
echo %esc%[38;2;255;255;255m                 [5] SAIR%reset%
echo ==================================================
set /p opt="Escolha uma opcao: "

if "%opt%"=="1" goto :OTIMIZAR
if "%opt%"=="2" goto :PONTO_RESTAURACAO
if "%opt%"=="3" goto :ABRIR_CF
if "%opt%"=="4" goto :GERENCIAR_DXVK
if "%opt%"=="5" exit
goto :MENU

:OTIMIZAR
cls
echo APLICANDO OTIMIZACOES DE SERVICOS...
:: Serviços que consomem CPU/RAM desnecessariamente
for %%s in (WSearch SysMain DiagTrack bits) do (
    sc stop "%%s" >nul 2>&1
    sc config "%%s" start= disabled >nul 2>&1
)
:: Ajuste de performance
powercfg -h off
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v DisablePagingExecutive /t REG_DWORD /d 1 /f
echo OTIMIZACAO DE SISTEMA CONCLUIDA.
goto :EOF

:MODO_JOGO
cls
echo Otimizando sistema e fechando processos...

:: Finaliza navegadores e apps com /F (Forçar) e /T (Processo e filhos) 
taskkill /f /im chrome.exe /t >nul 2>&1
taskkill /f /im msedge.exe /t >nul 2>&1
taskkill /f /im discord.exe /t >nul 2>&1
taskkill /f /im steam.exe /t >nul 2>&1

:: Desativa serviços pesados [cite: 12]
sc stop "WSearch" >nul 2>&1
sc config "WSearch" start= disabled >nul 2>&1
sc stop "SysMain" >nul 2>&1
sc config "SysMain" start= disabled >nul 2>&1

:: Finaliza o Explorer e espera 2 segundos para garantir o fechamento 
taskkill /f /im explorer.exe >nul 2>&1
timeout /t 2 >nul

:: Inicia o Crossfire [cite: 13]
for /f "delims=" %%f in ('dir /s /b "%DISCO%:\cfPT_launcher.exe" 2^>nul') do (set "CF_EXEC=%%f" & set "CF_PATH=%%~dpf")
pushd "%CF_PATH%"
start "" "cfPT_launcher.exe"
popd

goto :MENU_JOGO

:ABRIR_CF
cls
set "CONFIG_DIR=%USERPROFILE%\Documents\Cross Fire"
set "CONFIG_FILE=%CONFIG_DIR%\config_cf.txt"

:: Se a configuracao existe, le o caminho e vai direto para o inicio
if exist "%CONFIG_FILE%" (
    set /p CF_EXEC=<"%CONFIG_FILE%"
    set "CF_EXEC=%CF_EXEC:"=%"
    if exist "!CF_EXEC!" goto :INICIAR_JOGO
)

:: Se nao existir, pede a letra e faz a busca
echo.
set /p "LETRA=Configuracao nao encontrada. Digite a letra do disco (ex: C): "
echo Buscando cfPT_launcher.exe no disco %LETRA%... Aguarde...

set "CF_EXEC="
for /f "delims=" %%f in ('powershell -Command "Get-ChildItem -Path '%LETRA%:\' -Filter 'cfPT_launcher.exe' -Recurse -ErrorAction SilentlyContinue | Select-Object -ExpandProperty FullName -First 1"') do (
    set "CF_EXEC=%%f"
)

if not defined CF_EXEC (
    echo.
    echo ERRO: Arquivo nao encontrado!
    pause
    goto :MENU
)

:: Salva o caminho formatado corretamente
if not exist "%CONFIG_DIR%" mkdir "%CONFIG_DIR%"
echo %CF_EXEC%>"%CONFIG_FILE%"

:INICIAR_JOGO
:: Carrega e limpa o caminho
set /p CF_EXEC=<"%CONFIG_FILE%"
set "CF_EXEC=%CF_EXEC:"=%"

echo Iniciando o jogo...
:: Extrai a pasta onde o executavel esta (ex: C:\Program Files\CrossFire)
for %%I in ("%CF_EXEC%") do set "JOGO_PASTA=%%~dpI"

:: Entra na pasta do jogo, inicia o executavel e volta para a pasta original
pushd "%JOGO_PASTA%"
start "" "cfPT_launcher.exe"
popd

echo.
echo Comando enviado. Se o jogo nao abrir, verifique se o antivirus bloqueou o arquivo.
echo Pressione qualquer tecla para voltar ao menu.
pause >nul
goto :MENU

:SELECIONAR_DISCO_INST
set /p DISCO="Digite a letra do disco onde esta o jogo (ex: C): "
echo %rgb%Buscando cfPT_launcher.exe no disco %DISCO%...%reset%
set "CF_PATH="
for /f "delims=" %%f in ('dir /s /b "%DISCO%:\cfPT_launcher.exe" 2^>nul') do (set "CF_PATH=%%~dpf")
if not defined CF_PATH (echo %red%Arquivo nao encontrado!%reset% & pause & goto :MENU)
echo Instalando...
set "DXVK_URL=https://github.com/doitsujin/dxvk/releases/download/v1.10.3/dxvk-1.10.3.tar.gz"
set "TEMP_DXVK=%temp%\dxvk_setup"
if not exist "%TEMP_DXVK%" mkdir "%TEMP_DXVK%"
powershell -Command "Invoke-WebRequest -Uri '%DXVK_URL%' -OutFile '%TEMP_DXVK%\dxvk.tar.gz'; tar -xzf '%TEMP_DXVK%\dxvk.tar.gz' -C '%TEMP_DXVK%'"
copy "%TEMP_DXVK%\dxvk-1.10.3\x32\d3d9.dll" "%CF_PATH%\" /y >nul
copy "%TEMP_DXVK%\dxvk-1.10.3\x32\dxgi.dll" "%CF_PATH%\" /y >nul
if exist "%CF_PATH%\x64" (
    copy "%TEMP_DXVK%\dxvk-1.10.3\x64\d3d9.dll" "%CF_PATH%\x64\" /y >nul
    copy "%TEMP_DXVK%\dxvk-1.10.3\x64\dxgi.dll" "%CF_PATH%\x64\" /y >nul
)
rd /s /q "%TEMP_DXVK%"
echo %rgb%Instalado com sucesso!%reset%
pause
goto :MENU

:SELECIONAR_DISCO_REM
set /p DISCO="Digite a letra do disco do jogo para DESINSTALAR: "
for /f "delims=" %%f in ('dir /s /b "%DISCO%:\cfPT_launcher.exe" 2^>nul') do (set "CF_PATH=%%~dpf")
if defined CF_PATH (
    del /f /q "%CF_PATH%d3d9.dll" "%CF_PATH%dxgi.dll" >nul 2>&1
    del /f /q "%CF_PATH%x64\d3d9.dll" "%CF_PATH%x64\dxgi.dll" >nul 2>&1
    echo %rgb%DXVK removido com sucesso!%reset%
) else (echo %red%Pasta do jogo nao encontrada.%reset%)
pause
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
echo APLICANDO OTIMIZACOES PROFUNDAS...

:: --- 1. Ajustes de Energia e CPU ---
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMAX 100
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMIN 100
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR IDLEDISABLE 1
powercfg /setactive SCHEME_MIN
powercfg -h off

:: --- 2. Virtualizacao (Hyper-V) ---
bcdedit /set hypervisorlaunchtype off

:: --- 3. Memoria e Explorer ---
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v LargeSystemCache /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v IoPageLockLimit /t REG_DWORD /d 0x000F4240 /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v DisablePagingExecutive /t REG_DWORD /d 1 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v LaunchTo /t REG_DWORD /d 1 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v SeparateProcess /t REG_DWORD /d 1 /f

:: --- 4. Input Lag (Mouse e Teclado) ---
reg add "HKEY_CURRENT_USER\Control Panel\Mouse" /v MouseSpeed /t REG_SZ /d 0 /f
reg add "HKEY_CURRENT_USER\Control Panel\Mouse" /v MouseThreshold1 /t REG_SZ /d 0 /f
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v MouseSpeed /t REG_SZ /d 0 /f
reg add "HKEY_CURRENT_USER\Control Panel\Accessibility\Keyboard Response" /v DelayBeforeAcceptance /t REG_SZ /d 0 /f
reg add "HKEY_CURRENT_USER\Control Panel\Accessibility\Keyboard Response" /v AutoRepeatDelay /t REG_SZ /d 200 /f
reg add "HKEY_CURRENT_USER\Control Panel\Accessibility\Keyboard Response" /v AutoRepeatRate /t REG_SZ /d 20 /f
for /f "tokens=*" %%a in ('wmic path Win32_USBController get DeviceID /value ^| find "="') do (
    for /f "tokens=2 delims==" %%b in ("%%a") do (
        reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Enum\%%b\Device Parameters" /v EnhancedPowerManagementEnabled /t REG_DWORD /d 0 /f 2>nul
    )
)

:: --- 5. Servicos (Lista Completa) ---
for %%s in (WSearch SysMain DiagTrack wisvc DPS TermService WbioSrvc TabletInputService wuauserv bits DoSvc WaaSMedicSvc RetailDemo igts bthserv RemoteRegistry SessionEnv W32Time) do (
    sc stop "%%s" >nul 2>&1
    sc config "%%s" start= disabled >nul 2>&1
)

:: --- 6. Interface, Privacidade e Telemetria ---
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v PublishUserActivities /t REG_DWORD /d 0 /f
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Search" /v BingSearchEnabled /t REG_DWORD /d 0 /f
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Search" /v SearchHistoryEnabled /t REG_DWORD /d 0 /f
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v EnableTransparency /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v UserPreferencesMask /t REG_BINARY /d 90120000010000000000000000 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v NoAutoUpdate /t REG_DWORD /d 1 /f

:: --- 7. Rede ---
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v NetworkThrottlingIndex /t REG_DWORD /d 0xFFFFFFFF /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v SystemResponsiveness /t REG_DWORD /d 0 /f
powershell -Command "Get-NetAdapterAdvancedProperty | Where-Object {$_.DisplayName -like '*Power Saving*'} | Set-NetAdapterAdvancedProperty -DisplayValue 'Disabled' -ErrorAction SilentlyContinue" >nul 2>&1

:: --- 8. Limpeza Final e Reinicio ---
powershell -Command "Get-AppxPackage *news*,*officehub*,*3dbuilder*,*Cortana*,*alarms*,*calendar*,*maps*,*messaging*,*people*,*phone*,*xbox*,*onedrive* | Remove-AppxPackage; [System.GC]::Collect()"
taskkill /f /im explorer.exe >nul 2>&1
start "" "%windir%\explorer.exe"

echo.
echo OTIMIZACAO CONCLUIDA! REINICIE O PC PARA AS MUDANCAS ENTRAREM EM VIGOR.
pause
goto :MENU

:SELECIONAR_DISCO
cls
echo Escolha o disco onde o jogo esta instalado.
set /p "DISCO=Digite apenas a letra (ex: C): "
:: Remove espacos ou pontos extras caso o usuario digite errado
set "DISCO=%DISCO:~0,1%"
goto :MODO_JOGO

:MODO_JOGO
cls
echo %rgb%    --- OTIMIZANDO SISTEMA PARA O JOGO --- %reset%

echo [1/4] Finalizando navegadores e processos...
taskkill /f /im chrome.exe /t >nul 2>&1
taskkill /f /im msedge.exe /t >nul 2>&1
taskkill /f /im discord.exe /t >nul 2>&1
taskkill /f /im steam.exe /t >nul 2>&1

echo [2/4] Desativando servicos de fundo...
:: Aqui forçamos a parada dos servicos pesados 
sc stop "WSearch" >nul 2>&1
sc stop "SysMain" >nul 2>&1
sc config "WSearch" start= disabled >nul 2>&1
sc config "SysMain" start= disabled >nul 2>&1

echo [3/4] Liberando RAM (Finalizando Explorer)...
taskkill /f /im explorer.exe /t >nul 2>&1

echo [4/4] Iniciando Crossfire...
:: Busca e executa o jogo [cite: 13]
for /f "delims=" %%f in ('dir /s /b "%DISCO%:\cfPT_launcher.exe" 2^>nul') do (set "CF_EXEC=%%f" & set "CF_PATH=%%~dpf")
pushd "%CF_PATH%"
start "" "cfPT_launcher.exe"
popd

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
