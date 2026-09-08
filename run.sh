#!/bin/bash
set -e

echo "============================================"
echo "   OS Explorer - Threads, Concorrência e Clocks"
echo "============================================"
echo ""

# Check Python
if ! command -v python3 &> /dev/null; then
    echo "[ERRO] Python3 não encontrado."
    echo "       macOS: brew install python3"
    echo "       Linux: sudo apt install python3 python3-venv"
    exit 1
fi

PYVER=$(python3 --version 2>&1 | awk '{print $2}')
PY_MAJOR=$(echo "$PYVER" | cut -d. -f1)
PY_MINOR=$(echo "$PYVER" | cut -d. -f2)

echo "[INFO] Python encontrado: $PYVER"

if [ "$PY_MAJOR" -lt 3 ] || { [ "$PY_MAJOR" -eq 3 ] && [ "$PY_MINOR" -lt 8 ]; }; then
    echo "[ERRO] Python 3.8+ necessário. Versão: $PYVER"
    exit 1
fi

echo "[OK] Versão compatível: $PYVER"

# Create venv if needed
if [ ! -d "venv" ]; then
    echo "[INFO] Criando ambiente virtual..."
    python3 -m venv venv
fi

source venv/bin/activate

echo "[INFO] Instalando dependências..."
pip install --upgrade pip > /dev/null 2>&1
pip install "flask>=2.3,<4.0"

echo ""
echo "[OK] Dependências instaladas."
echo "[INFO] Iniciando servidor em http://localhost:5000"
echo "       Pressione Ctrl+C para parar."
echo ""

python app.py
