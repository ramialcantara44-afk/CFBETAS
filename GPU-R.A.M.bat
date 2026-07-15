@echo off
setlocal EnableDelayedExpansion
chcp 65001 >nul
title BETA - OTIMIZACAO TOTAL

echo.
echo ================================================
echo          GPU-R.A.M OTIMIZADOR v1.0
echo ================================================
echo.

:: --- CONFIGURACAO RGB ---
for /F %%a in ('echo prompt $E ^| cmd') do set "esc=%%a"

:: --- ANIMACAO DE ABERTURA ---
cls
for /L %%i in (1,1,6) do (
    set /a "r=%random% %% 255"
    set /a "g=%random% %% 255"
    set /a "b=%random% %% 255"
    echo.
    echo             %esc%[38;2;!r!;!g!;!b%m%     CARREGANDO MODULO R.A.M... [%%i/6] %esc%[0m
    timeout /t 1 >nul
)

:MENU
set /a "r=%random% %% 255"
set /a "g=%random% %% 255"
set /a "b=%random% %% 255"
set "rgb=%esc%[38;2;%r%;%g%;%b%m"
set "reset=%esc%[0m"

cls
echo %rgb%                           █████╗ ███╗   ██╗████████╗██╗  ██████╗  █████╗ %reset%
echo %rgb%                           ██╔══██╗████╗ ██║╚══██╔══╝██║ ██╔════╝ ██╔══██╗%reset%
echo %rgb%                           ███████║██╔██╗██║   ██║   ██║ ██║  ███╗███████║%reset%
echo %rgb%                           ██╔══██║██║╚████║   ██║   ██║ ██║   ██║██╔══██║%reset%
echo %rgb%                           ██║  ██║██║ ╚███║   ██║   ██║ ╚██████╔╝██║  ██║%reset%
echo %rgb%                           ╚═╝  ╚═╝╚═╝  ╚═══╝   ╚═╝   ╚═╝  ╚═════╝ ╚═╝  ╚═╝%reset%
echo.
echo %rgb%                           COPYRIGHT (C) 2026. TODOS OS DIREITOS RESERVADOS.%reset%
echo.
echo %esc%[38;2;0;255;0m    [1] OTIMIZAR (PROFUNDO)%reset%
echo %esc%[38;2;255;0;0m          [2] CRIAR PONTO DE RESTAURACAO%reset%
echo %esc%[38;2;255;255;0m              [3] ABRIR CROSSFIRE%reset%
echo %esc%[38;2;255;255;255m                 [4] SAIR%reset%
echo.
set /p opcao="Escolha uma opcao: "
if "%opcao%"=="1" goto :CONFIRMAR_OTIMIZAR
if "%opcao%"=="2" goto :PREPARAR_BACKUP
if "%opcao%"=="3" goto :SELECIONAR_DISCO
if "%opcao%"=="4" exit
goto :MENU

:: (o resto do seu código continua igual - :CONFIRMAR_OTIMIZAR, :OTIMIZAR, etc.)
