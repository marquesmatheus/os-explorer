@echo off
chcp 65001 >nul 2>&1
title OS Explorer - Threads, Concorrencia e Clocks

echo ============================================
echo    OS Explorer - Threads, Concorrencia e Clocks
echo ============================================
echo.

:: Detect Python
where python >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo [ERRO] Python nao encontrado no PATH.
    echo        Baixe em: https://www.python.org/downloads/
    echo        Marque "Add Python to PATH" durante a instalacao.
    pause
    exit /b 1
)

:: Get Python version
for /f "tokens=2 delims= " %%v in ('python --version 2^>^&1') do set PYVER=%%v
for /f "tokens=1,2 delims=." %%a in ("%PYVER%") do (
    set PY_MAJOR=%%a
    set PY_MINOR=%%b
)

echo [INFO] Python encontrado: %PYVER%

:: Validate version >= 3.8
if %PY_MAJOR% lss 3 (
    echo [ERRO] Python 3.8+ e necessario. Versao encontrada: %PYVER%
    echo        Baixe Python 3.8+: https://www.python.org/downloads/
    pause
    exit /b 1
)
if %PY_MAJOR% equ 3 if %PY_MINOR% lss 8 (
    echo [ERRO] Python 3.8+ e necessario. Versao encontrada: %PYVER%
    echo        Baixe Python 3.8+: https://www.python.org/downloads/
    pause
    exit /b 1
)

echo [OK] Versao compativel: %PYVER%

:: Create virtualenv if not exists
if not exist "venv" (
    echo [INFO] Criando ambiente virtual...
    python -m venv venv
    if %ERRORLEVEL% neq 0 (
        echo [ERRO] Falha ao criar ambiente virtual.
        pause
        exit /b 1
    )
)

:: Activate venv
call venv\Scripts\activate.bat
if %ERRORLEVEL% neq 0 (
    echo [ERRO] Falha ao ativar ambiente virtual.
    pause
    exit /b 1
)

:: Upgrade pip
echo [INFO] Atualizando pip...
python -m pip install --upgrade pip >nul 2>&1

:: Install Flask based on Python version
echo [INFO] Instalando Flask...
if %PY_MAJOR% gtr 3 (
    pip install "flask>=3.0,<4.0"
) else if %PY_MAJOR% equ 3 if %PY_MINOR% geq 12 (
    pip install "flask>=3.0,<4.0"
) else (
    pip install "flask>=2.3,<4.0"
)

if %ERRORLEVEL% neq 0 (
    echo [ERRO] Falha ao instalar Flask.
    pause
    exit /b 1
)

echo.
echo [OK] Dependencias instaladas com sucesso.
echo [INFO] Iniciando servidor em http://localhost:8080
echo        Pressione Ctrl+C para parar.
echo.

python app.py

pause
