#!/bin/bash
set -e

echo "============================================"
echo "   OS Explorer - WSL"
echo "============================================"
echo ""

# Detect WSL
if grep -qi microsoft /proc/version 2>/dev/null; then
    echo "[INFO] Ambiente WSL detectado."
else
    echo "[AVISO] Este script e para WSL. Use run.sh para Linux nativo."
fi
echo ""

# Check Python3
if ! command -v python3 &> /dev/null; then
    echo "[ERRO] python3 nao encontrado."
    echo ""
    echo "  Instale com:"
    echo "    sudo apt update && sudo apt install -y python3 python3-pip python3-venv"
    echo ""
    exit 1
fi

# Check if venv module works
if ! python3 -m venv --help > /dev/null 2>&1; then
    echo "[ERRO] Modulo 'venv' nao encontrado."
    echo ""
    echo "  Instale com:"
    echo "    sudo apt update && sudo apt install -y python3-venv"
    echo ""
    exit 1
fi

PYVER=$(python3 --version 2>&1 | awk '{print $2}')
PY_MAJOR=$(echo "$PYVER" | cut -d. -f1)
PY_MINOR=$(echo "$PYVER" | cut -d. -f2)

echo "[INFO] Python encontrado: $PYVER"

if [ "$PY_MAJOR" -lt 3 ] || { [ "$PY_MAJOR" -eq 3 ] && [ "$PY_MINOR" -lt 6 ]; }; then
    echo "[ERRO] Python 3.6+ necessario. Versao: $PYVER"
    echo "       sudo apt install python3.8 python3.8-venv (ou superior)"
    exit 1
fi

echo "[OK] Versao compativel: $PYVER"

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Create venv if needed
if [ ! -d "$SCRIPT_DIR/venv" ]; then
    echo "[INFO] Criando ambiente virtual..."
    python3 -m venv "$SCRIPT_DIR/venv"
fi

source "$SCRIPT_DIR/venv/bin/activate"

echo "[INFO] Instalando dependencias..."
pip install --upgrade pip > /dev/null 2>&1

# Flask version based on Python
if [ "$PY_MAJOR" -gt 3 ] || { [ "$PY_MAJOR" -eq 3 ] && [ "$PY_MINOR" -ge 8 ]; }; then
    pip install "flask>=2.3,<4.0"
elif [ "$PY_MINOR" -eq 7 ]; then
    pip install "flask>=2.0,<3.0"
else
    pip install "flask>=2.0,<2.3"
fi

echo ""
echo "[OK] Dependencias instaladas."
echo "[INFO] Iniciando servidor em http://localhost:8080"
echo "       Acesse do Windows: http://localhost:8080"
echo "       Pressione Ctrl+C para parar."
echo ""

python "$SCRIPT_DIR/app.py"
