@echo off
:: Verifica se o sinalizador existe para pular direto para o menu do jogador
if exist "%temp%\modo_jogo.txt" (
    del "%temp%\modo_jogo.txt"
    goto :MENU_JOGO
)

setlocal EnableDelayedExpansion
chcp 65001 >nul
title BETA - OTIMIZACAO

:: --- O resto do seu código inicial até o MENU permanece igual ---
:: (Garanta que a verificação de Admin também esteja aqui)

:INICIAR_JOGO
:: 1. Carrega o caminho do jogo
set /p CF_EXEC=<"%USERPROFILE%\Documents\Cross Fire\config_cf.txt"
set "CF_EXEC=!CF_EXEC:"=!"

:: 2. Abre o jogo
for %%I in ("%CF_EXEC%") do set "JOGO_PASTA=%%~dpI"
pushd "%JOGO_PASTA%"
start "" "cfPT_launcher.exe"
popd

:: 3. Cria o arquivo para a nova janela saber que deve ir ao menu de jogo
echo. >"%temp%\modo_jogo.txt"

:: 4. Abre uma nova janela do mesmo arquivo (usando o caminho completo)
start "PAINEL DE OTIMIZACAO" "%~f0"

:: 5. Fecha a janela original
exit

:MENU_JOGO
:: Garante que este bloco não dependa de variáveis iniciadas no outro bloco
cls
echo ==================================================
echo           PAINEL DE OTIMIZACAO DO JOGADOR
echo ==================================================
echo [1] Limpar Memoria RAM
echo [2] Fechar Jogo e Sair
echo [3] Gerenciar Explorer
echo [4] Sair do Painel
echo ==================================================
set /p j_op="Escolha: "

if "%j_op%"=="1" (
    taskkill /f /im chrome.exe /im msedge.exe /im discord.exe /im steam.exe >nul 2>&1
    echo Limpeza concluida!
    timeout /t 2 >nul
    goto :MENU_JOGO
)
if "%j_op%"=="2" (
    taskkill /f /im cfPT_launcher.exe >nul 2>&1
    start "" explorer.exe
    exit
)
if "%j_op%"=="3" (
    taskkill /f /im explorer.exe >nul 2>&1
    timeout /t 2 >nul
    start "" explorer.exe
    goto :MENU_JOGO
)
if "%j_op%"=="4" exit
goto :MENU_JOGO
